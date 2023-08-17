import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseOperation{
  FirebaseAuth _auth= FirebaseAuth.instance;
  Future usersignup(String Email,String Password)async{

      await _auth.createUserWithEmailAndPassword(
          email: Email, password: Password);

  }
Future usersignin(String Email,String Password)async{
      await _auth.signInWithEmailAndPassword(email: Email, password: Password);
}

}