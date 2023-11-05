import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class PhoneVerification extends StatefulWidget {
  static String verificationcode='';
  static String phone='';

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();

}

class _PhoneVerificationState extends State<PhoneVerification> {
  bool showspinner=false;
  final controller=TextEditingController();
  String phonenumber='';
  alertmethod() {
    Alert(
        context:context,
        title: 'Code has been sent',
      image: Image(image: AssetImage('assets/caution.jpg'),),
      buttons:
      [
        DialogButton(child: Text('Ok'), onPressed: (){Navigator.pop(context);})
      ]
    ).show();

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text='+91';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(color: Colors.blue,),
          inAsyncCall: showspinner,
          child: SingleChildScrollView(
            child: Center(
              child: Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height /5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6.0, left: 6.0),
                    child: Column(
                      children: [
                        Text(
                          'You\'ll receive an automated SMS',
                          style: TextStyle(
                              fontSize: 35.0, fontFamily: 'SourceSansPro'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'We\'ll send you an automated message containing your OTP. Dont\'t worry you don\'t need to reply back.',
                                style: TextStyle(fontSize: 15.0),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200.0,
                      child: Image(
                        image: AssetImage('assets/phone1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5,right: 5),
                      decoration: BoxDecoration
                        (border: Border.all(color: Colors.grey,width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width:40.0,
                            child: TextField
                              (
                              controller: controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(border: InputBorder.none),
                            ),
                          ),
                         Padding(
                           padding: const EdgeInsets.only(right: 5.0,left: 2.0),
                           child: Text('|',style: TextStyle(fontSize: 30),),
                         ),

                          Expanded(
                            child: SizedBox(
                              child: TextField
                                (
                                onChanged: (value)
                                {
                                  phonenumber=value;
                                  PhoneVerification.phone=value;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(border: InputBorder.none,hintText: 'Enter your 10-digit phone number'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                        onTap: () async
                        {
                          setState(() {
                            showspinner=true;
                          });
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '${controller.text+phonenumber}',
                            verificationCompleted: (PhoneAuthCredential credential)
                            {
                              // setState(() {
                              //   showspinner=true;
                              // });
                            },
                            verificationFailed: (FirebaseAuthException e) {print(e);},
                            codeSent: (String verificationId, int resendToken)
                            {
                              PhoneVerification.verificationcode=verificationId;
                              alertmethod();
                              Navigator.pushNamed(context, '/otp');
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {},
                          );
                          setState(() {
                            showspinner=false;
                          });
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 300,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Send OTP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
