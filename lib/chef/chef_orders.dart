import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// SERVE ORDERS -- (currently) IRRESPECTIVE of WHICH CHEF is named
//       >> Display All Orders (Menu Item Names)
//       >> 'SERVED' Button
//       >> Firestore 'Orders' database : 
//                >> 'isOrderComplete' == true

// NOTE 0 : in 'Menu', currently queries for 'Name' field or 'itemName' field
//          in 'Orders', assumes 'order' array exists; collection of 'Menu' item references

// NOTE 1 : Haven't implemented account/authentication so CHEF's PENDING ORDERS
//          won't be for an INDIVIDUAL chef & any Chef can SERVE any order

// TODO 1 : match 'chef/chefID' (in 'Orders') to document ID (in 'users') & filter: 'role' == 'chef'

// NOTE 2 : Can't Update the Ingredients Inventory AUTOMATICALLY
//              if 'Menu' items aren't created with an 'Ingredients' array,
//          SO---- Chefs MUST Update the Ingredients Inventory MANUALLY (<< currently method )
//          OR---- Could make a 'Menu-Ingre' database; each document is a Menu item;
//                  has an array of Ingredients; & use Ingredients array to update Inventory
//
//              BUT !! INGREDIENTS database needs to be populated upon 'Menu' item creation 
//

/* IDEA : 

Pending Orders
____________________________________

Order ID: (ABC123)
Menu Item: (Item 1)
Menu Item: (Item 2)
Menu Item: (Item 3)
[SERVED]

Order ID: (DEF000)
Menu Item: (Item 4)
Menu Item: (Item 5)
[SERVED]

Order ID: (XYZ999)
Menu Item: (Item 6)
Menu Item: (Item 7)
Menu Item: (Item 8)
Menu Item: (Item 9)
[SERVED]

... [ cont'd list of orders    ]
... [ from 'Orders' collection ]

*/



class Order {
  final String id;
  final bool isOrderComplete;
  final List<DocumentReference> order;

  Order({required this.id, required this.isOrderComplete, required this.order});
}

class MenuItem {
  final String name;
  MenuItem({required this.name});
}

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pending Orders')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Orders').where('isOrderComplete', isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final orderRef = snapshot.data!.docs.map((doc) {
            final order = List<DocumentReference>.from(doc['order']);
            return Order(id: doc.id, isOrderComplete: doc['isOrderComplete'], order: order);
          }).toList();

          return ListView.builder(
            itemCount: orderRef.length,
            itemBuilder: (context, index) {
              final order = orderRef[index];
              return ListTile(
                title: Text('Order ID: ${order.id}'),
                subtitle: FutureBuilder<List<MenuItem>>(
                  future: _getMenuItems(order.order),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    final menuItems = snapshot.data ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final menuItem in menuItems) Text('Menu Item: ${menuItem.name}'), // .name ?
                      ],
                    );
                  },
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('Orders').doc(order.id).update({
                      'isOrderComplete': true,
                    })
                    .then((_) => print('Order marked as served: ${order.id}'))
                    .catchError((error) => print('Error updating order: $error'));
                  },
                  child: Text('SERVED'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<MenuItem>> _getMenuItems(List<DocumentReference> orderReferences) async {
    final menuItems = <MenuItem>[];
    for (final reference in orderReferences) {
      final snapshot = await reference.get();
      if (snapshot.exists) {
        final menuItemName = snapshot['Name'] ?? snapshot['itemName'];    // checks for 'Name' or 'itemName'
        menuItems.add(MenuItem(name: menuItemName));
      }
    }
    return menuItems;
  }
}
