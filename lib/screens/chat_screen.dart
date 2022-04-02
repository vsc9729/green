import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:green/service/encryption_decryption_service.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';


String getKeyFromDevice(email) {
  return GetStorage().read("${FirebaseAuth.instance.currentUser.email}-$email");
}

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  final String email;
  ChatScreen({@required this.email});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  var c1 = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  var c2 = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  String messageText;
  @override
  void initState(){
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Row(
          children: [
            CircleAvatar(
              child: Text(
                widget.email[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: c2,
            ),
            SizedBox(width: 20,),
            Text(
              widget.email.substring(0, widget.email.indexOf("@")),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            PositivityWidget(email: widget.email),
            MessageStream(email: widget.email,c1: c1,c2: c2),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                        },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async{
                      messageTextController.clear();
                      String url = "https://sour-duck-19.loca.lt/predict?data=$messageText";
                      print(messageText);
                      var response = await http.get(Uri.parse(url));
                      String positive = jsonDecode(response.body)["result"];
                      print(positive);
                      GetStorage().write("${widget.email}_total_messages",GetStorage().hasData("${widget.email}_total_messages")?GetStorage().read("${widget.email}_total_messages")+1:1);
                      if(positive == "1") {
                        GetStorage().write(
                            "${widget.email}_positive_messages",
                            GetStorage().hasData("${widget.email}_positive_messages")?GetStorage().read("${widget.email}_positive_messages")+1:1);
                      }
                      double positivity = GetStorage().read("${widget.email}_positive_messages")/GetStorage().read("${widget.email}_total_messages");
                      print(positivity);
                      var encryptedText = EncryptionDecryptionService().encryptAES(messageText, EncryptionDecryptionService().retrieveKey(getKeyFromDevice(widget.email)));
                      _firestore.collection("messages").add(
                          {
                        "text": encryptedText,
                        "sender": loggedInUser.email,
                        "receiver": widget.email,
                        "time": FieldValue.serverTimestamp(),
                        "positivity": positivity,
                      });
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(198, 123, 227, 1),
                      ),
                      child: Icon(
                          Icons.send,
                          color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  final String email;
  final dynamic c1;
  final dynamic c2;
  MessageStream({@required this.email, this.c1 ,this.c2});
  @override
  Widget build(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time', descending: false).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for(var message in messages){
          if(message.get("sender") == loggedInUser.email&&message.get("receiver") == email || message.get("receiver") == loggedInUser.email&&message.get("sender") == email) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final messageReceiver = message.get('receiver');
            final currentUser = loggedInUser.email;
            final messageBubble = MessageBubble(
              sender: messageSender,
              text: EncryptionDecryptionService().decryptAES(messageText, EncryptionDecryptionService().retrieveKey(getKeyFromDevice(email))),
              isMe: currentUser == messageSender,
              receiver: messageReceiver,
              c1: c1,
              c2:c2,
            );
            messageBubbles.add(messageBubble);
          }
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
class MessageBubble extends StatelessWidget {
  const MessageBubble({this.sender, this.text, this.isMe, this.receiver, this.c1,this.c2});
  final String sender;
  final String receiver;
  final String text;
  final bool isMe;
  final dynamic c1;
  final dynamic c2;
  @override
  Widget build(BuildContext context) {
    List<Widget> messages = [CircleAvatar(
      child: Text(
        sender[0].toUpperCase(),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: isMe?c1:c2,
    ),
      SizedBox(width:10),
      Column(
        children: [
          Material(
            borderRadius: isMe?
            BorderRadius.only(topLeft: Radius.circular(30.0),topRight: Radius.circular(30.0),bottomRight: Radius.circular(30.0)):BorderRadius.only(topLeft: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),topRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe?Colors.white:Color.fromRGBO(198, 123, 227, 1),
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal:15.0),
                child: Text(
                  '$text',
                  style: TextStyle(
                    color: isMe?Colors.black:Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,)
        ],
      )];
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: isMe?MainAxisAlignment.start:MainAxisAlignment.end,
            children: isMe?messages:messages.reversed.toList(),
          ),
        ],
      ),
    );
  }
}
class PositivityWidget extends StatelessWidget {
  final String email;
  PositivityWidget({@required this.email});
  @override
  Widget build(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time', descending: false).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        double netPositivity;
        final messages = snapshot.data.docs.reversed;
        for(var message in messages){
          if(message.get("receiver") == loggedInUser.email&&message.get("sender") == email) {
            netPositivity = message.get("positivity");
            break;
          }
        }
        return PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Colors.blue, Colors.pink],
              ),
            ),
            child: Center(
              child: Text(
                netPositivity!=null?"${double.parse(netPositivity.toStringAsFixed(4))*100}% positive":"No Message Received Yet",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),);
      },
    );
  }
}
