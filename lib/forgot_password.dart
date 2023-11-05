import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hashchat/reusable.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final controller=TextEditingController();
   String errormessage='';
  bool showspinner=false;
  void resetpassword() async{

    setState(() {
      showspinner=true;
    });
    final _auth=FirebaseAuth.instance;
    try
    {
      await _auth.sendPasswordResetEmail(email: email.trim());
      showDialog(context: context, builder: (context)
      {
        return AlertDialog
          (
          content: Text('We have sent you a password reset link on your provided email.Check your email.',style: TextStyle(fontSize: 20.0,fontFamily: 'SourceSansPro'),),
          actions:
          [
            DialogButton(child: Text('Ok',style: TextStyle(fontWeight: FontWeight.bold),), onPressed: (){Navigator.pushReplacementNamed(context, '/login');})
          ],
        );
      });
    }
    on FirebaseAuthException catch(e)
    {
      print(e);
      errormessage=e.message;
    }
    setState(() {
      showspinner=false;
    });


  }
  String email = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(color: Colors.blue,),
          inAsyncCall: showspinner,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0,),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Colors.lightBlue[50],Colors.lightBlue[100],Colors.lightBlue[200]])
                  ),
                  child: Icon(
                    Icons.key,
                    size: MediaQuery.of(context).size.width/3,
                    color: Colors.lightBlue,
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.all(10.0),
                  child: Text('Forgot Password ?',textAlign: TextAlign.center,style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,fontFamily: 'SourceSansPro'),),
                ),
                Padding(
                  padding:  EdgeInsets.all(10.0),
                  child: Text('No worries. We\'ll send you reset instructions.',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 15.0),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white70,
                      filled: true,
                      labelStyle: TextStyle(
                          fontSize: 10.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      hintText: 'Enter Your Email-ID',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(width: 2, color: Color(0x40524f4f)),
                      ),
                      focusedBorder: (OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(width: 2, color: Colors.lightBlue),
                      )),
                    ),
                  ),
                ),
                Text('${errormessage}',style: TextStyle(fontSize: 15.0,color: Colors.red),),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: GestureDetector
                    (
                    child: Container(
                      decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(30.0)),
                      child: Button('Reset Password', Colors.blue),),
                    onTap: ()
                    {
                      resetpassword();
                      controller.clear();
                    },
                  ) ,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
