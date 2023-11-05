import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hashchat/Firebase_Service.dart';

import 'groupdetails.dart';

class Groups extends StatefulWidget {
  @override
  State<Groups> createState() => _GroupsState();
}

DocumentSnapshot groups;

class _GroupsState extends State<Groups> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
  }

  final _auth = FirebaseAuth.instance;
  User loggeduser;

  void getcurrentuser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggeduser = user;
      }
    } catch (e) {}
  }

  bool _isloading = false;
  String groupname;
  popUpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              _isloading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.lightBlueAccent,
                      ),
                    )
                  : TextField(
                      onChanged: (value) {
                        groupname = value;
                        print(groupname);
                      },
                    ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (groupname != "") {
                            setState(() {
                              _isloading = true;
                            });
                            final admin = FirebaseAuth.instance.currentUser;
                            Database database = Database();
                            database
                                .creategroup(groupname, admin.email, admin.uid,
                                    admin.email,admin.uid)
                                .whenComplete(() {
                              setState(() {
                                _isloading = false;
                              });
                            });
                            Navigator.of(context).pop();
                            final snackBar = SnackBar(
                              duration: Duration(seconds: 1),
                              backgroundColor: Colors.green,
                              content: Text('Group Created!!'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: Container(
                          height: 35,
                          child: Center(
                              child: Text(
                            'Okay',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 35,
                          child: Center(
                              child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
            title: Text("Create a group"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        showgroups(loggeduser.email),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              elevation: 5,
              child: Icon(Icons.add),
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                popUpDialog(context);
              },
            ),
          ),
        )
      ]),
    );
  }
}

StreamBuilder showgroups(String uid) {
  String takegroupid(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  String getgroupname(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final data = snapshot.data.data() as Map<String, dynamic>;
        if (data['groups'].length == 0) {
          return noGroup();
        } else {
          return ListView.builder(
            itemCount: data['groups'].length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GroupTile(
                    getgroupname(data['groups'].toList()[index].toString()),
                    takegroupid(data['groups'].toList()[index].toString()),
                    'assets/groupicon.jpg'),
              );
            },
          );
        }
      } else {
        return CircularProgressIndicator(
          color: Colors.blueAccent,
        );
      }
    },
  );
}

noGroup() {
  return Container(
    child: Center(
        child: Text(
      'You don\'t have any groups created.Create new groups',
      style: TextStyle(fontSize: 15, color: Colors.black),
    )),
  );
}

class GroupTile extends StatefulWidget {
  final groupname;
  final groupicon;
  final groupid;
  GroupTile(this.groupname, this.groupid, this.groupicon);
  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  void initState() {
    // TODO: implement initState
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context){return GroupDetails(widget.groupid);}));
        },
        child: ListTile(
          leading: ClipOval(
              child: Image.asset(
            widget.groupicon,
            fit: BoxFit.cover,
          )),
          title: Text(widget.groupname),
          subtitle: Text(widget.groupid),
        ));
  }
}


