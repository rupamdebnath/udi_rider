import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:udi_rider/AllScreens/mainscreen.dart';
import 'package:udi_rider/main.dart';

import 'loginScreen.dart';


class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 45.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text(
                "Sign up as a Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 20.0,),
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Register New Account",
                              style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                            ),
                          )
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0)
                      ),
                      onPressed: ()
                      {
                        if(nameTextEditingController.text.length < 3)
                        {
                            displayToastMessage("name must be at least 3 characters", context);
                        }
                        else if(!emailTextEditingController.text.contains("@"))
                        {
                            displayToastMessage("Email address is not valid", context);
                        }
                        else if(phoneTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("Phone number is mandatory", context);
                        }
                        else if(passwordTextEditingController.text.length < 6)
                        {
                          displayToastMessage("Password must be at least 6 characters", context);
                        }
                        else
                        {
                          registerNewUser(context);
                        }
                      },
                    ),
                  ],
                ),
              ),

              FlatButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Already have an account? Login here",
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async
  {
      final User firebaseUser = (await _firebaseAuth
      .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
      ).catchError((errMsg){
        displayToastMessage("Error: " + errMsg.toString(), context);
      })).user;

      if(firebaseUser != null)  //user created
        {
            Map userDataMap = {
            "name": nameTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "phone": phoneTextEditingController.text.trim(),
          };

            usersRef.child(firebaseUser.uid).set(userDataMap);
            displayToastMessage("congratulations, your account has been successfully created", context);
            //save user info to database
        
            Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
        }
      else
        {
          displayToastMessage("New user account has not been created", context);
          //error occured - display error
        }
  }

}

displayToastMessage(String message, BuildContext context)
{
  Fluttertoast.showToast(msg: message);
}
//function to display toast message