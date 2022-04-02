import 'package:flutter/material.dart';
import 'package:green/screens/welcome_screen.dart';
import 'package:green/screens/login_screen.dart';
import 'package:green/screens/registration_screen.dart';
import 'package:green/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/people_screen.dart';
import 'package:get_storage/get_storage.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        PeopleScreen.id: (context) => PeopleScreen(),
      },
    );
  }
}
