import 'package:flutter/material.dart';
import 'package:hashchat/Firebase_Service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'chats.dart';
import 'grouplist.dart';
import 'reusable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  alertmethod() {
    Alert(
        onWillPopActive: true,
        context: context,
        title:
            'Your account was created successfully!!!Please login to continue',
        buttons: [
          DialogButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              }),
        ]).show();
  }

  bool spinnershow = false;
  String fullName = '';
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String errormessage = '';
  bool hidetext = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: spinnershow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/hash.png')),
                  ),
                ),
              ), //hashimage
              SizedBox(
                height: 19.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  onChanged: (value) {
                    fullName = value;
                    ChatScreen.name = value;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white70,
                    filled: true,
                    labelStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    hintText: 'Enter Your Name',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          BorderSide(width: 2, color: Color(0x40524f4f)),
                    ),
                    focusedBorder: (OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(width: 2, color: Colors.lightBlue),
                    )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white70,
                    filled: true,
                    labelStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    hintText: 'Enter Your Email-ID',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          BorderSide(width: 2, color: Color(0x40524f4f)),
                    ),
                    focusedBorder: (OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(width: 2, color: Colors.lightBlue),
                    )),
                  ),
                ),
              ), //emailfield

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: hidetext,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    helperText: 'Minimum character length 6',
                    suffixIcon: IconButton(
                      focusColor: Colors.black,
                      onPressed: () {
                        setState(() {
                          hidetext = !hidetext;
                        });
                      },
                      icon: Icon(
                          hidetext ? Icons.visibility_off : Icons.visibility),
                    ),
                    fillColor: Colors.white70,
                    filled: true,
                    labelStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    hintText: 'Enter Your Password',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide:
                          BorderSide(width: 2, color: Color(0x40524f4f)),
                    ),
                    focusedBorder: (OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(width: 2, color: Colors.lightBlue),
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
                child: Text(
                  errormessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                  ),
                ),
              ), //passwordfield
              SizedBox(
                height: 5.0,
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    errormessage = '';
                    spinnershow = true;
                  });

                  final newuser = Auth();
                  await newuser
                      .createuser(fullName, email, password)
                      .then((value) {
                    if (value != true) {
                      errormessage = value;
                    } else
                    {
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){return GroupList(email);}));
                      // alertmethod();
                    }
                  });

                  setState(() {
                    spinnershow = false;
                  });
                },
                child: Button('Register', Colors.blueAccent),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    'Already have an Account? Click here to login',
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                ),
              ), //registerbutton
            ],
          ),
        ),
      ),
    );
  }
}
