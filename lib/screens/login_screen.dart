import 'package:firebase_auth/firebase_auth.dart';
import 'package:green/components/rounded_button.dart';
import 'package:green/screens/chat_screen.dart';
import 'package:green/screens/people_screen.dart';
import 'package:green/screens/registration_screen.dart';
import 'package:green/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:green/animations/fade_animation.dart';
class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  bool spinner = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 400,
                width: width,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                        height: 400,
                        width: width,
                        child: FadeAnimation(1,Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("images/background-3.png"),
                                fit: BoxFit.fill,
                            ),
                          ),
                        ),),
                    ),
                    Positioned(
                      width: width+20,
                      height: 400,
                      child: FadeAnimation(1.5,Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/background-2.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      FadeAnimation(1.7,Text(
                      "Login",
                      style: TextStyle(
                        color: Color.fromRGBO(49, 39, 79, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),),
                    SizedBox(height: 40,),
                    FadeAnimation(1.9,Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(196, 135, 198, 0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[200]
                                  ),
                              ),
                            ),
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                email = value;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Username",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              obscureText: true,
                              onChanged: (value) {
                                password = value;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),),
                    SizedBox(height: 20,),
                    SizedBox(height: 40,),
                    FadeAnimation(2.0,Center(
                      child: RoundedButton(
                        color: Color.fromRGBO(49, 39, 79, 1),
                        onClick: () async{
                          setState(() {
                            spinner = true;
                          });
                          try {
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            setState(() {
                              spinner = false;
                            });
                            Navigator.pushNamed(context, PeopleScreen.id);
                          }catch(e){
                            print(e);
                          }
                        },
                        buttonText: "Login",
                      ),
                    ),),
                    SizedBox(height: 20,),
                    FadeAnimation(2.2,Center(
                      child: TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RegistrationScreen.id);
                        },
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            color: Color.fromRGBO(49, 39, 79, 0.6),
                            fontSize: 18,
                          ),
                        ),
                      ),),
                    ),
                  ],
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
