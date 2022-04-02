import 'package:flutter/material.dart';
import 'package:green/screens/people_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:green/service/encryption_decryption_service.dart';

String email;
class AddUserScreen extends StatelessWidget {
  AddUserScreen({this.addUser});
  final Function addUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Add User",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter E-mail",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(186, 111, 215, 1)),
                    ),
                    onPressed: () async{
                      var key = EncryptionDecryptionService().generateKey();
                      print(key);
                      addUser(email, key);
                    },
                    child: Center(
                        child: Text(
                          "Say Hi👋",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
