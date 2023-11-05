import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hashchat/chats.dart';
import 'package:hashchat/forgot_password.dart';
import 'package:hashchat/grouplist.dart';
import 'package:hashchat/login.dart';
import 'package:hashchat/otpverify.dart';
import 'package:hashchat/phoneverification.dart';
import 'package:hashchat/register.dart';
import 'package:hashchat/sample.dart';
import 'package:hashchat/search.dart';
import 'package:hashchat/searchpage.dart';
import 'package:hashchat/userprofile.dart';
import 'package:hashchat/welcome.dart';
import 'home.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {

        '/':(context)=>Home(),
        '/search':(context)=>SearchPage(),
        '/searcher':(context)=>Search(),
        '/welcome':(context)=>Welcome(),
        '/reset':(context)=>ForgotPassword(),
        '/phone':(context)=>PhoneVerification(),
        '/register':(context)=>Register(),
        '/login':(context)=>Login(),
        '/chats':(context)=>ChatScreen(),
        '/otp':(context)=>OTP(),
        '/sample':(context)=>Sample(),
      },
    );
  }
}

