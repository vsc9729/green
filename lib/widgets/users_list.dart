import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green/widgets/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'package:green/widgets/user_tile.dart';

final _firestore = FirebaseFirestore.instance;

User loggedInUser;
class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async{
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }catch(e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return UsersStream();
  }
}
class UsersStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time', descending: false).snapshots(),
      builder: (context, snapshot){
        List<String> trackUsers = [];
        if(!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final messages = snapshot.data.docs.reversed;
        List<UserTile> userTiles = [];
        for(var message in messages){
          final messageSender = message.get('sender');
          final messageReceiver = message.get('receiver');
          final currentUser = loggedInUser.email;
          if(messageSender==currentUser||messageReceiver==currentUser){
            if(messageSender==currentUser){
              if(!trackUsers.contains(messageReceiver)){
                trackUsers.add(messageReceiver);
              }
            }
            if(messageReceiver==currentUser){
              if(!trackUsers.contains(messageSender)){
                trackUsers.add(messageSender);
              }
            }
          }
        }
        for(var user in trackUsers){
          userTiles.add(UserTile(email: user));
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: userTiles,
          ),
        );
      },
    );
  }
}
// class UserTile extends StatelessWidget {
//   final String email;
//   UserTile({this.email});
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top:10,bottom: 10),
//       child: ListTile(
//         leading: CircleAvatar(
//           child: Text(
//             email[0].toUpperCase(),
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
//         ),
//         title: Text(
//           email,
//         ),
//         trailing: Icon(
//           Icons.send,
//           color: Colors.blue,
//         ),
//       ),
//     );
//   }
// }


