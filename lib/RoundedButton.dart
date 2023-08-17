import 'package:flutter/material.dart';
import 'package:flashchat/screens/login_screen.dart';



class RoundedButton extends StatelessWidget {
  final String buttontext;
  final Function onpressed;
  const RoundedButton({required this.buttontext,required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            onpressed();
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttontext,
          ),
        ),
      ),
    );
  }
}