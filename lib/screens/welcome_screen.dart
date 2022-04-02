import 'package:green/screens/login_screen.dart';
import 'package:green/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:green/components/rounded_button.dart';
import 'package:green/animations/fade_animation.dart';
class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            children: [
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/background.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeAnimation(1,Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/light-1.png'),
                          )
                        ),
                      )
                    ),),
                    Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.3,Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/light-2.png'),
                              )
                          ),
                        )
                    ),),
                    Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.6,Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/clock.png'),
                              )
                          ),
                        )
                    ),),
                    Positioned(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: FadeAnimation(1.8,Center(
                            child: Text(
                              "GREEN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 100,),
                    FadeAnimation(2,Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(143, 148, 251, 1),
                            Color.fromRGBO(143, 148, 251, .6)
                          ],
                        ),
                      ),
                      child: TextButton(
                        onPressed: (){
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),),
                    SizedBox(height: 30,),
                    FadeAnimation(2,Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(143, 148, 251, 1),
                            Color.fromRGBO(143, 148, 251, .6)
                          ],
                        ),
                      ),
                      child: TextButton(
                        onPressed: (){
                          Navigator.pushNamed(context, RegistrationScreen.id);
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
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


// class WelcomeScreen extends StatefulWidget {
//   static const String id = 'welcome_screen';
//   @override
//   _WelcomeScreenState createState() => _WelcomeScreenState();
// }
//
// class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
//   AnimationController controller;
//   Animation animation;
//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//         duration: Duration(seconds: 4),
//         vsync: this,
//     );
//     animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
//     controller.forward();
//     controller.addListener(() {
//       setState(() {});
//     });
//   }
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 Hero(
//                   tag: 'logo',
//                   child: Container(
//                     child: Image.asset('images/logo.png'),
//                     height: animation.value*60,//This height will transition to 200 in the login screen via the hero widget
//                   ),
//                 ),
//                 AnimatedTextKit(
//                   animatedTexts: [
//                     TypewriterAnimatedText(
//                         "FLASH CHAT",
//                         textStyle: TextStyle(
//                           fontSize: 30.0,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       speed: const Duration(milliseconds: 500),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 48.0,
//             ),
//             RoundedButton(
//               color: Colors.lightBlueAccent,
//               onClick: () {
//                 Navigator.pushNamed(context, LoginScreen.id);
//               },
//               buttonText: "Log In",
//             ),
//             RoundedButton(
//               color: Colors.blueAccent,
//               onClick: () {
//                 Navigator.pushNamed(context, RegistrationScreen.id);
//               },
//               buttonText: "Register",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

