import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hashchat/phoneverification.dart';

class OTP extends StatefulWidget {
  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  String smscode = '';
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                TextField(
                  decoration: InputDecoration(hintText: 'Enter your otp'),
                  onChanged: (value) {
                    smscode = value;
                  },
                ),
                Container(
                    decoration: BoxDecoration(color: Colors.lightBlue),
                    child: TextButton(
                      onPressed: ()async
                      {
                        try
                        {
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: PhoneVerification.verificationcode, smsCode: smscode);

                          // Sign the user in (or link) with the credential
                          await _auth.signInWithCredential(credential);
                          Navigator.pushReplacementNamed(context, '/grouplist');
                        } on FirebaseAuthException catch(e)
                        {
                          print(e);
                        }

                      },
                      child: Text(
                        'Verify OTP',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
