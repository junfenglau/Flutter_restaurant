
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/widget_support.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {








  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:SingleChildScrollView(
          child: Container(
            child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/1.2,
                    width: MediaQuery.of(context).size.width,
                    /*LinearGradient is a class that creates a gradient effect,
                we can use it to create a gradient effect for the container,
                can take multiple colors, begin and end properties are used to
                define the direction of the gradient effect
                 */
                    decoration: BoxDecoration(gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue, Colors.green])),
                  ),
                  Container(
                    /*
                * MediaQuary is responsible for getting the size of the screen
                * and then we can use it to set the margin of the container
                * it also helps in making the app responsive.
                *
                * */
                    margin:EdgeInsets.only(top:MediaQuery.of(context).size.height/3),
                    height: MediaQuery.of(context).size.height/2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )
                    ),
                  ),
          
                  //need a logo or something nice for the login page
                  Container(
                    margin: EdgeInsets.only(top: 50, left: 30, right: 30),
                    child: Column(
          
                      children:
                      [
          
                        Center(
                          child: Text("MANJU ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
          
          
                        /*if we want to add a logo, we can use the Image.asset() widget
                    plus we need to adjust the size of the image and the space
                    between the image and the text
          
                 */
                        SizedBox(height: 50,),
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height/1.8,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child:
                            Column(
                              children:
                              [
                                SizedBox(height: 30,),
                                Text("Register",
                                  style: AppWidget.headLineTextFieldStyle(),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 30,),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                    hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                    prefixIcon: Icon(Icons.person),
          
                                  ),
                                ),
                                SizedBox(height: 30,),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                    prefixIcon: Icon(Icons.email),
          
                                  ),
                                ),
          
                                SizedBox(height: 30,),
                                TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                    prefixIcon: Icon(Icons.password),
          
                                  ),
                                ),
                                SizedBox(height: 30,),
          

                                SizedBox(height: 50,),
                                Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: 200,
                                    decoration:  BoxDecoration(gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Colors.blue, Colors.green],
          
                                    ),
                                        borderRadius: BorderRadius.circular(30)),
                                    child: const Center(
                                      child: Text("Register",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                )
          
          
                              ],
                            ),
          
                          ),
                        ),
                        SizedBox(height: 50,),
                        GestureDetector(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                LogIn()));
                          },
                          child: Text("Already have an account? Log In",
                            style: AppWidget.semiBoldTextFieldStyle(),
                          ),
                        ),
                      ],
                    ),
                  )
                ]
            ),
          ),
        )
    );
  }
}
