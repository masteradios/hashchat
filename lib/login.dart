import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hashchat/Firebase_Service.dart';
import 'grouplist.dart';
import 'reusable.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference userRef=FirebaseFirestore.instance.collection('users');
class Login extends StatefulWidget {

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void getuserbyid(String uid) async {
    DocumentSnapshot doc=await userRef.doc(uid).get();
    setState(() {
      GroupList.name=doc['Name'];
    });
    print('hiiiiiiiiiiiiiiiiiiiiii+no'+doc.data().toString());
    print('heloooooooooooooo'+doc['Name']);

  }
  String errormessage='';
  bool spinnershow=false;
  final _auth=FirebaseAuth.instance;
  String email='';
  String password='';
  bool hidetext=true;
  @override

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: spinnershow,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Column
                    (
                    children:
                    [
                      Container(
                        height: MediaQuery.of(context).size.height/4,
                        child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/lock.jpg')),
                      ),//hashimage
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0),
                        child: TextField(

                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          onChanged: (value) {
                            email=value;


                          },
                          decoration: InputDecoration(
                            fillColor: Colors.white70,
                            filled: true,
                            labelStyle: TextStyle(fontSize: 10.0,color: Colors.black,fontWeight: FontWeight.bold),
                            hintText: 'Enter Your Email-ID',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(width: 2, color: Color(0x40524f4f)),
                            ),
                            focusedBorder: (OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(width: 2, color: Colors.lightBlue),
                            )
                            ),
                          ),
                        ),
                      ),//emailfield
                      SizedBox(
                        height: 26.0,
                        child: Center(child: Text(errormessage,style: TextStyle(color: Colors.red,fontSize: 12.0),)),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(

                          keyboardType: TextInputType.visiblePassword,
                          obscureText: hidetext,
                          onChanged: (value) {
                            password=value;

                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              focusColor: Colors.black,
                              onPressed: (){
                                setState(() {
                                  hidetext=!hidetext;

                                });
                              },
                              icon: Icon(hidetext?Icons.visibility_off:Icons.visibility),

                            ),
                            fillColor: Colors.white70,
                            filled: true,
                            labelStyle: TextStyle(fontSize: 15.0,color: Colors.black,fontWeight: FontWeight.bold),
                            hintText: 'Enter Your Password',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(width: 2, color: Color(0x40524f4f)),
                            ),
                            focusedBorder: (OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(width: 2, color: Colors.lightBlue),
                            )),
                          ),
                        ),
                      ),//passwordfield
                      SizedBox(
                        height: 30.0,
                        child: GestureDetector(
                          onTap: ()
                          {
                            Navigator.pushNamed(context, '/reset');
                          },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text('Forgot Password?',style: TextStyle(color: Colors.blue),),
                            ),
                          ],
                        ),
                      ),),
                      TextButton(onPressed: () async
                      {

                        setState(() {
                          errormessage='';


                            spinnershow=true;
                        });

                        try
                        {
                          final user=await _auth.signInWithEmailAndPassword(email: email, password: password);
                          if(user!=null)
                          {
                            print('widgetName'+email);

                            //Navigator.popUntil(context, ModalRoute.withName('/'));
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){return GroupList(email);}));
                           // Navigator.pushReplacementNamed(context,'/chats');

                          }
                          errormessage='';
                        }

                        on FirebaseAuthException catch(error)
                        {
                          errormessage=error.message;
                        }
                        setState(() {


                          spinnershow=false;
                        });
                        // Navigator.of(context).pop();

                      },
                        child:Button('Login',Colors.lightBlue),
                      ),
                     Container(
                  child: GestureDetector(
                    onTap: ()
                    {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text('Don\'t have an Account? Click here to register',style: TextStyle(color: Colors.lightBlueAccent,fontSize: 16.0),),
                  ),
                ),



                    ],
                  ),
                  // Column(children:
                  // [
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: Container
                  //       (
                  //       width: MediaQuery.of(context).size.width,
                  //       child: Align(alignment: Alignment.center,child: Text('******Or continue with******',style: TextStyle(color: Colors.grey,fontSize: 15),)),
                  //     ),
                  //   ),
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Flexible(
                  //       child: Container
                  //         (
                  //         width:120,
                  //         height: 120.0,
                  //         decoration: BoxDecoration(
                  //             image:DecorationImage(image:AssetImage('assets/phone.jpg'),fit: BoxFit.fill ) ,
                  //             borderRadius: BorderRadius.circular(10),color: Colors.grey),
                  //         child: GestureDetector
                  //           (
                  //           onTap: ()
                  //           {
                  //             Navigator.pushNamed(context, '/phone');
                  //           },
                  //
                  //         ),
                  //       ),
                  //     ),
                  //   ), //registerbutton
                  //
                  // ],),








                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
