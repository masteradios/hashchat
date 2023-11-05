import 'package:flutter/material.dart';
import 'package:hashchat/login.dart';
import 'package:hashchat/register.dart';
import 'reusable.dart';
import 'register.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:SafeArea(
          child: Center(
            child: Column
              (
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(width: 10.0,),
                    Hero(
                      tag: 'logo',
                      child: Container(
                        height: 120,
                        child: Image(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/hash.png')),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text('HashChat',style: TextStyle(fontSize: 45.0,fontFamily: 'KdamThmorPro'),),
                        Text('group chat app',style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextButton(onPressed: ()
                {
                  setState(() {


                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Login();
                    }));

                  });
                },
                  child:Button('Login',Colors.lightBlue),
                ),//loginpage
                SizedBox(
                  height: 15.0,
                ),
                TextButton(onPressed: ()
                {
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Register();
                    }));

                  });
                },
                  child:Button('Register',Colors.blueAccent),
                ),//reigsterpage

              ],

            ),
          ),
        )

    );
  }
}



