import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashchat/RoundedButton.dart';

class WelcomeScreen extends StatefulWidget {
  static String id='welcome_Screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;


  @override
  void initState() {

    super.initState();
    controller=AnimationController(vsync: this,
    duration: const Duration(seconds: 1),
    );
    animation=CurvedAnimation(parent: controller, curve: Curves.easeIn);
    //animation=ColorTween(begin:Colors.blueGrey,end:Colors.white).animate(controller) ;
    controller.forward();


    controller.addListener(() {

      setState(() {
      });
      
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
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
            Row(
              children: <Widget>[
                 Hero(
                   tag: 'logo',
                   child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value*70,
                ),
                 ),
               DefaultTextStyle(
                style:const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,


                ),
                child: FutureBuilder<void>(
                    future: Future.delayed(const Duration(seconds: 1)),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.done){
                      return AnimatedTextKit(
                        animatedTexts: [TypewriterAnimatedText('FLASH CHAT',speed: const Duration(milliseconds: 200),textStyle:const TextStyle(color: Colors.black),),
                        ],
                      );
                    }
                    else{
                      return Text('');
                    }
                  },

                )
              )
              ],
            ),
           const  SizedBox(
              height: 48.0,
            ),
             RoundedButton(buttontext: 'Log in',onpressed: (){Navigator.pushNamed(context, LoginScreen.id);},),
             RoundedButton(buttontext: 'Register',onpressed:(){Navigator.pushNamed(context, RegistrationScreen.id);},),
          ],
        ),
      ),
    );
  }
}




// AnimatedTextKit(
// animatedTexts: [TyperAnimatedText('FLASH CHAT',speed: const Duration(milliseconds: 110),textStyle:const TextStyle(color: Colors.black),),
// ],
// ),