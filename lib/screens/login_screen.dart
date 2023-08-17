import 'package:flashchat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/RoundedButton.dart';
import 'package:flashchat/constants.dart';
import 'package:flashchat/Firebase Operation.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';


class LoginScreen extends StatefulWidget {
  static String id='login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  FirebaseOperation auth=FirebaseOperation();
  bool obsecuretexthandle=true;
  IconData icon=Icons.visibility_off;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                email=value;
                //Do something with the user input.
              },
              decoration:ktextfielddecoration.copyWith(hintText:'enter your email' )
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              style:const TextStyle(color: Colors.black),
              //textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              obscureText: obsecuretexthandle,
              onChanged: (value) {
                password=value;
                //Do something with the user input.
              },
              decoration: ktextfielddecoration.copyWith(hintText:'enter password',suffixIcon:GestureDetector(
                onTap: (){
                  setState(() {
                    if(obsecuretexthandle==false){
                      icon=Icons.visibility_off;
                      obsecuretexthandle=true;
                    }
                    else if(obsecuretexthandle==true){
                      icon=Icons.visibility;
                      obsecuretexthandle=false;
                    }
                  });
                },
                child:  Icon(
                  icon,
                ),
              ) ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            RoundedButton(buttontext: 'Log in',onpressed: ()async{
              try {
                OverlayLoadingProgress.start(context);
                await auth.usersignin(email, password);
                OverlayLoadingProgress.stop();
                Navigator.pushNamed(context, ChatScreen.id);
              }
              catch(e){
                String errormessage=e.toString();
                List<String> parts = errormessage.split(']');
                errormessage = parts.last.trim();
                OverlayLoadingProgress.stop();
                setState(() {
                  showDialog(context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context){
                        return  AlertDialog(
                          title:const Text('Could Not Register'),
                          content: Text(errormessage),
                          actions: [TextButton(onPressed: (){
                            Navigator.pop(context);

                          },
                              child: const Text('OK'))],
                        );
                      }
                  );
                });

                print('could not signin $e');

              }
            },),
          ],
        ),
      ),
    );
  }
}