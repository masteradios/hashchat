import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'grouplist.dart';
import 'login.dart';
//final CollectionReference userRef=FirebaseFirestore.instance.collection('users');
class Welcome extends StatefulWidget {
  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {


  @override
  void initState() {
    super.initState();

    final loggeduser=FirebaseAuth.instance.currentUser;
    final user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        {
          print('User is currently signed out!');
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }

      } else {
        print('User is signed in!');
        Navigator.popUntil(context, ModalRoute.withName('/'));
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){return GroupList(user.email);}));
      }
    });


  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image(
              image: AssetImage('assets/hash.png'),
            ),
          ),
          Text('App by : Aditya'),

        ],
      ),
    ));
  }
}
