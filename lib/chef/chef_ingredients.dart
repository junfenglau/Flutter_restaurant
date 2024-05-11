import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// CHEFS MANUALLY UPDATE INGREDIENTS
//       >> Display Ingredients
//       >> Integer Input & 'GET' Button
//       >> Firestore 'Ingredients' database : 
//                >> 'amount' increases by integer value
//                >> 'needRestock' == true, if false 

/* IDEA : 

Ingredients Inventory
____________________________________

ID: (Ingredient1)
Amount: (15)
Need Restock: (true)
Input Field: [ int ]   [GET]

ID: (Ingredient2)
Amount: (3)
Need Restock: (false)
Input Field: [ int ]   [GET]

ID: (Ingredient3)
Amount: (23)
Need Restock: (true)
Input Field: [ int ]   [GET]

... [ cont'd list of ingredients    ]
... [ from 'Ingredients' collection ]

*/


class ChefIngredient {
  final String id;
  final int amount;
  final bool needRestock;

  ChefIngredient({required this.id, required this.amount, required this.needRestock});

  factory ChefIngredient.fromDocument(DocumentSnapshot doc) {
    return ChefIngredient(
      id: doc.id,
      amount: doc['amount'],
      needRestock: doc['needRestock'],
    );
  }
}

class IngredientModel extends ChangeNotifier {
  int _inputValue = 0;

  int get inputValue => _inputValue;

  void updateInputValue(int newValue) {
    _inputValue = newValue;
    notifyListeners();
  }
}

class ChefIngredientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ingredientModel = context.watch<IngredientModel>();

    return Scaffold(
      appBar: AppBar(title: Text('Ingredients Inventory')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Ingredients').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final ingredients = snapshot.data!.docs.map((doc) => ChefIngredient.fromDocument(doc)).toList();

          return ListView.builder(
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              return ListTile(
                title: Text('ID: ${ingredient.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount: ${ingredient.amount}'),
                    Text('Need Restock: ${ingredient.needRestock}'),
                  ],
                ),
                trailing: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final parsedValue = int.tryParse(value) ?? 0;
                        ingredientModel.updateInputValue(parsedValue);
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final inputValue = ingredientModel.inputValue;
                        FirebaseFirestore.instance
                            .collection('Ingredients')
                            .doc(ingredient.id)
                            .update({
                              'amount': FieldValue.increment(inputValue),
                              'needRestock': true,
                            })
                            .then((_) => print('Document updated successfully'))
                            .catchError((error) => print('Error updating document: $error'));
                      },
                      child: Text('GET'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}