import 'package:firebase_core/firebase_core.dart';
import 'package:green/components/rounded_button.dart';
import 'package:green/service/encryption_decryption_service.dart';
import 'package:flutter/material.dart';
import 'package:green/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green/screens/add_user_screen.dart';
import 'package:green/widgets/users_list.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:green/widgets/user_tile.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final _firestore = FirebaseFirestore.instance;

void saveKeyToDevice(email, key) async{
  GetStorage().write("${FirebaseAuth.instance.currentUser.email}-$email", key);
}
String getKeyFromDevice(email) {
  return GetStorage().read("${FirebaseAuth.instance.currentUser.email}-$email");
}
void checkKey(email) async{
  var key;
  if(!GetStorage().hasData("${FirebaseAuth.instance.currentUser.email}-$email")){
    await _firestore.collection("keys").where("person_1", isEqualTo: email).where("person_2", isEqualTo: FirebaseAuth.instance.currentUser.email).get().then((qs){
        qs.docs.forEach((doc) {
          key = doc.get("key");
          doc.reference.delete();
        });
    });
    saveKeyToDevice(email, key);
  }
}

class PeopleScreen extends StatefulWidget {
  static const String id = 'people_screen';
  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  List allUsers = [];
  final _auth = FirebaseAuth.instance;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }
  void callbackUpdateChats(String email,key) async {
    await usersStream(email);
    bool userExists = allUsers.contains(email);
    if (userExists) {
      GetStorage().write("${email}_total_messages", 1);
      GetStorage().write("${email}_positive_messages", 1);
      saveKeyToDevice(email, key);
      setState(() {
        _firestore.collection("messages").add(
            {
              "text": EncryptionDecryptionService().encryptAES("Hi👋", EncryptionDecryptionService().retrieveKey(key)),
              "sender": loggedInUser.email,
              "receiver": email,
              "time": FieldValue.serverTimestamp(),
              "positivity": 1.0,
            });
        _firestore.collection("keys").add(
            {
              "key": key,
              "person_1": loggedInUser.email,
              "person_2": email,
            });
      });
      Navigator.pop(context);
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "ERROR",
        desc: "User Not Found",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(
                  color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    }
  }

  Future<bool> usersStream(String email) async {
    QuerySnapshot snapshot = await _firestore.collection("allUsers").get();
    snapshot.docs.forEach((element) {
      String user = element.get("email");
      allUsers.add(user);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(186, 111, 215, 1),
        child: Icon(
          Icons.search,
          color: Colors.white,
          size: 30.0,
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return AddUserScreen(addUser: callbackUpdateChats);
              });
        },
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Conversations",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 40,),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(253, 228, 236, 1),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: TextButton(
                        onPressed: (){
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return AddUserScreen(addUser: callbackUpdateChats);
                              });
                        },
                        child: Row(
                          children: [
                            Text(
                              "+",
                              style: TextStyle(
                                color: Color.fromRGBO(239, 39, 106, 1),
                              ),
                            ),
                            SizedBox(width: 3,),
                            Text(
                              "Add New",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                    ),
                  )
                ],
              ),
            ),
            UsersStream()
          ]
        )
      )
    );
  }
}
class UsersStream extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time', descending: false).snapshots(),
      builder: (context, snapshot){
        List<String> trackUsers = [];
        if(!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final messages = snapshot.data.docs;
        List<UserTile> userTiles = [];
        var userPositivity = new Map();
        for(var message in messages){
          final messageSender = message.get('sender');
          final messageReceiver = message.get('receiver');
          final netPositivity = message.get("positivity");
          final currentUser = loggedInUser.email;
          if(messageSender==currentUser||messageReceiver==currentUser){
            if(messageSender==currentUser){
              if(!trackUsers.contains(messageReceiver)){
                trackUsers.add(messageReceiver);
              }
            }
            if(messageReceiver==currentUser){
              if(!userPositivity.containsKey("messageSender")) {
                userPositivity[messageSender] = netPositivity;
              }
              if(!trackUsers.contains(messageSender)){
                trackUsers.add(messageSender);
              }
            }
          }
        }
        for(var user in trackUsers){
          print(user);
          print(userPositivity[user]);
          int isPos;
          if(userPositivity.containsKey(user)) {
            if (userPositivity[user] > 0.5) {
              isPos = 1;
            } else if (userPositivity[user] < 0.5) {
              isPos = 0;
            } else {
              isPos = -1;
            }
          }else{
            isPos = -1;
          }
          userTiles.add(UserTile(email: user, isPos: isPos));
          checkKey(user);
        }
        return Expanded(
          child: ListView(
            children: userTiles,
          ),
        );
      },
    );
  }
}