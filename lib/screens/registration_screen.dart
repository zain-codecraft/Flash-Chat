import 'package:flashchat/Firebase Operation.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/RoundedButton.dart';
import 'package:flashchat/constants.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';


class RegistrationScreen extends StatefulWidget {
  static const id='registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                style:const TextStyle(color: Colors.black),
              keyboardType: TextInputType.emailAddress,
              //textAlign: TextAlign.center,
              onChanged: (value) {
                email=value;
              },
              decoration: ktextfielddecoration.copyWith(hintText:'Enter your Email' )
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              //textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
              obscureText: obsecuretexthandle,
              onChanged: (value) {
                password=value;
              },
              decoration:ktextfielddecoration.copyWith(hintText:'Enter Your Password' ,suffixIcon:GestureDetector(
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
              ),) ,
            ),
            const SizedBox(
              height: 24.0,
            ),
             RoundedButton(buttontext: 'Register',onpressed: ()async{
                 print(email);
                 print(password);
                 try {
                   OverlayLoadingProgress.start(context);
                   await auth.usersignup(email, password);
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

                   print('could not signup here $e');
                 }
               },),

          ],
        ),
      ),
    );
  }
}
