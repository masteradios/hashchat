import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hashchat/grouplist.dart';
import 'package:hashchat/login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Firebase_Service.dart';

final CollectionReference _userRef =
    FirebaseFirestore.instance.collection('users');

class UserProfile extends StatefulWidget {
  final String email;
  UserProfile(this.email);
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserNamebyid();
  }
  String newName = GroupList.name;
  final loggeduser = FirebaseAuth.instance.currentUser;
  bool isNameempty = false;
  TextEditingController _controller = TextEditingController();
  String _username='';
  void getuserNamebyid() async {
    DocumentSnapshot doc=await FirebaseFirestore.instance.collection('users').doc(loggeduser.email).get();
    print('heloooooooooooooo'+doc['Name']);

    setState(() {
      _username=  doc['Name'];
    });

  }

  alertmethod(String title) {
    Alert(
        onWillPopActive: true,
        context: context,
        title: title,
        content: TextField(
          onChanged: (value) {
            newName = value;
            GroupList.name = value;
          },
        ),
        buttons: [
          DialogButton(
            child: Text('Done', style: TextStyle(color: Colors.blueAccent)),
            color: Colors.white,
            onPressed: () {
              setState(() {
               //database.updateUserinfo(loggeduser.email, 'Name', newName);
              });

              Navigator.pop(context);
            },
          ),
          DialogButton(
              color: Colors.white,
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.blueAccent),
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    // IconButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   icon: Icon(
                    //     Icons.arrow_back,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return GroupList(widget.email);
                          }));
                        },
                        icon: Icon(
                          Icons.check,
                          color: Colors.blue,
                        )),
                  ],
                ),
                Center(
                  child: Stack(children: [
                    Material(
                      color: Colors.transparent,
                      child: ClipOval(
                        child: InkWell(
                          onTap: () {},
                          child: Image(
                            width: 150,
                            height: 150,
                            fit: BoxFit.fill,
                            image: AssetImage('assets/nature.jpg'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Icon(Icons.edit),
                                )),
                          ),
                        ))
                  ]),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    TextButton(
                        child: UserInfo(
                            'email-id', loggeduser.email, Icons.email)),
                    TextButton(
                        onPressed: () {
                          alertmethod('Edit your Name');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 20.0),
                                child: Icon(
                                  Icons.account_circle,
                                  size: 30,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      _username,
                                      style: TextStyle(
                                          fontFamily: 'SourceSansPro',
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  UserInfo(this.title, this.content, this.icon);
  final String title;
  final String content;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 20.0),
            child: Icon(
              icon,
              size: 30,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  content,
                  style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: 20,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
