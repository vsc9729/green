import 'package:green/components/rounded_button.dart';
import 'package:green/screens/login_screen.dart';
import 'package:green/screens/people_screen.dart';
import 'package:flutter/material.dart';
import 'package:green/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green/animations/fade_animation.dart';
final _firestore = FirebaseFirestore.instance;
class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> with TickerProviderStateMixin{
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool spinner = false;

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
                      ),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeAnimation(1.7,Text(
                      "Register",
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
                          try{
                            final newUser = await _auth
                                .createUserWithEmailAndPassword(
                                email: email, password: password);
                            setState(() {
                              spinner = false;
                            });
                            if(newUser != null){
                              Navigator.pushNamed(context, PeopleScreen.id);
                              _firestore.collection("allUsers").add(
                                {"email": email},
                              );
                            }
                          }
                          catch(e){
                            print(e);
                          }
                        },
                        buttonText: "Register",
                      ),
                    ),),
                    SizedBox(height: 20,),
                    FadeAnimation(2.2,Center(
                      child: TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        child: Text(
                          'Existing User',
                          style: TextStyle(
                            color: Color.fromRGBO(49, 39, 79, 0.6),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),),
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

// child: Padding(
//   padding: EdgeInsets.symmetric(horizontal: 24.0),
//   child: Center(
//     child: SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           Hero(
//             tag: 'logo',
//             child: Container(
//               height: 200,
//               child: Image.asset('images/logo.png'),
//             ),
//           ),
//           SizedBox(
//             height: 48.0,
//           ),
//           TextField(
//             keyboardType: TextInputType.emailAddress,
//             textAlign: TextAlign.center,
//             style: kInputTextStyle,
//             onChanged: (value) {
//               email = value;
//             },
//             decoration: kTextFieldDecoration.copyWith(hintText: "Enter your email"),
//           ),
//           SizedBox(
//             height: 8.0,
//           ),
//           TextField(
//             obscureText: true,
//             textAlign: TextAlign.center,
//             style: kInputTextStyle,
//             onChanged: (value) {
//               password = value;
//             },
//             decoration: kTextFieldDecoration.copyWith(hintText: "Enter your password"),
//           ),
//           SizedBox(
//             height: 24.0,
//           ),
//           RoundedButton(
//             color: Colors.blueAccent,
//             onClick: () async{
//               setState(() {
//                 spinner = true;
//               });
//               try{
//                 final newUser = await _auth
//                     .createUserWithEmailAndPassword(
//                     email: email, password: password);
//                 setState(() {
//                   spinner = false;
//                 });
//                 if(newUser != null){
//                   Navigator.pushNamed(context, PeopleScreen.id);
//                   _firestore.collection("allUsers").add(
//                     {"email": email},
//                   );
//                 }
//               }
//               catch(e){
//                 print(e);
//               }
//             },
//             buttonText: "Register",
//           ),
//         ],
//       ),
//     ),
//   ),
// ),