import 'package:green/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'users_list.dart';
import 'dart:math' as math;
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

class UserTile extends StatelessWidget{
  final String email;
  final int isPos;
  UserTile({this.email, this.isPos});

  List<Color> tileTheme(){
    if(isPos == -1){
      return GradientColors.white;
    }else if(isPos == 1){
      return GradientColors.dustyGrass;
    }else{
      return GradientColors.radish;
    }
  }
  Color iconAndTextTheme(){
    if(isPos == -1){
      return Colors.black;
    }else if(isPos == 1){
      return Colors.black;
    }else{
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:5,bottom: 5,right: 10, left: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: tileTheme(),
        ),),
        child: ListTile(
          onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>ChatScreen(email: email)
              ),
            );
          },
          leading: CircleAvatar(
            child: Text(
              email[0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
          ),
          title: Text(
            email,
            style: TextStyle(
              color: iconAndTextTheme(),
            ),
          ),
          trailing: Icon(
            Icons.send,
            // color: Color.fromRGBO(186, 111, 215, 1),
            color: iconAndTextTheme(),
          ),
        ),
      ),
    );
  }
}
