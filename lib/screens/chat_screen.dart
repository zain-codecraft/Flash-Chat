import 'package:flutter/material.dart';
import 'package:flashchat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedinuser;
ScrollController _scrollController =ScrollController();
class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textcontroller=TextEditingController();
  late String message = '';
  Color buttoncolor = Colors.grey;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() async {
    final user = await _auth.currentUser;
    try {
      if (user != null) {
        loggedinuser = user;
        print(loggedinuser.email);
      }
    } catch (e) {
      print('user is null');
    }
  }

  // void getmessages()async{
  //   final messages= await _firestore.collection('messages').get();
  //   for(var a  in messages.docs){
  //         print(a.data());
  //   }
  // }

  void messagestream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var messages in snapshot.docs) {
        print(messages.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                  Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
             const  mymessagestream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        style: const TextStyle(
                          color:Colors.black,
                        ),
                        controller:textcontroller,
                        onChanged: (value) {
                          message = value;
                          //Do something with the user input.
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        textcontroller.clear();
                        if(message!=''){
                        buttoncolor = Colors.lightBlue;
                        _firestore.collection('messages').add(
                            {"sender": loggedinuser.email, "text": message,'timestamp':FieldValue.serverTimestamp()});
                            message='';
                        _scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                     }


                        },

                      child:const Icon(
                        Icons.send,
                        color: Colors.lightBlue,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class mymessagestream extends StatelessWidget {
  const mymessagestream({super.key});


  @override
  Widget build(BuildContext context) {
      late String formattedtime;
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('timestamp',descending: false).snapshots(),
      builder: (BuildContext context, snapshot) {
        List<Widget> textbubbles = [];
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(
            backgroundColor: Colors.lightBlue,
          );
        }
        final messages = snapshot.data?.docs.reversed;
        for (var snapshot in messages!) {
          String messagetext = snapshot['text'];
          String sender = snapshot['sender'];
          if(snapshot['timestamp']!=null) {
            Timestamp firestoreTimestamp = snapshot['timestamp'];
            DateTime dateTime = firestoreTimestamp.toDate();
             formattedtime = "${dateTime.hour}:${dateTime.minute}";
          }
          final useremail=sender;
          textbubbles.add(messagebubble(sender: sender, text: messagetext,isme:loggedinuser.email==useremail,time: formattedtime,));
        }

        return Expanded(
          child: ListView(
            controller: _scrollController,
            reverse: true,
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            children: textbubbles,
          ),
        );
      },
    );

  }

}

class messagebubble extends StatelessWidget {
  final String text;
  final sender;
  final bool isme;
  final String time;
  const messagebubble({required this.sender, required this.text,required this.isme,required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:isme? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: const  TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius: isme?
            const BorderRadius.only(topLeft:Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight:Radius.circular(30.0)):
            const BorderRadius.only(topRight:Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight:Radius.circular(30.0))  ,
            elevation: 5.0,
            color: isme?Colors.lightBlue:Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text('$text',style: TextStyle(color: isme?Colors.white:Colors.grey[700]),),
                ),
                 Padding(
                  padding: const EdgeInsets.only(right: 10.0,bottom: 7.0),
                  child:  Text(time,style: TextStyle(
                      color: isme? Colors.white70:Colors.black45,
                      fontSize: 10.0

                  ),),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
