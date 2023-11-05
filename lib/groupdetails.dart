import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hashchat/Firebase_Service.dart';

class GroupDetails extends StatefulWidget {
  final groupid;
  GroupDetails(this.groupid);

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: showgroupdetails(widget.groupid));
  }
}

class showgroupdetails extends StatefulWidget {
  final groupid;
  showgroupdetails(this.groupid);

  @override
  State<showgroupdetails> createState() => _showgroupdetailsState();
}

class _showgroupdetailsState extends State<showgroupdetails> {
  String message = '';
  TextEditingController messagecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String getmembername(String res) {
      return res.substring(res.indexOf('_') + 1, res.indexOf('@'));
    }

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: ()async {
      //   },
      //   child: Icon(Icons.add),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(widget.groupid)
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return MessageText(
                            snapshot.data.docs[index]['sender'],
                            snapshot.data.docs[index]['text'],
                            FirebaseAuth.instance.currentUser.email);
                      });
                } else if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }
              }),
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: messagecontroller,
                onChanged: (value) {
                  setState(() {
                    message = value;
                  });
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(width: 2, color: Colors.transparent),
                  ),
                  focusedBorder: (OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(width: 2, color: Colors.transparent),
                  )),
                  hintText: 'Type a message...',
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: message.trim().isEmpty
                    ? null
                    : () {
                        messagecontroller.clear();
                        FirebaseFirestore.instance
                            .collection('groups')
                            .doc(widget.groupid)
                            .collection('messages')
                            .add({
                          'text': message,
                          'sender': FirebaseAuth.instance.currentUser.email,
                          'createdAt': Timestamp.now(),
                        });
                        //getMessages();
                        setState(() {
                          message = '';
                        });
                      },
                icon: Icon(Icons.telegram),
                iconSize: 40.0,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class Addmembers extends StatefulWidget {
  @override
  State<Addmembers> createState() => _AddmembersState();
}

class _AddmembersState extends State<Addmembers> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      child: Text('Add members'),
    )));
  }
}

class MessageText extends StatelessWidget {
  MessageText(this.sender, this.text, this.currentuser);
  final String sender;
  final String text;
  final String currentuser;
  @override
  Widget build(BuildContext context) {
    if (sender == currentuser) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(sender),
            Material(
              elevation: 15.0,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: Colors.lightBlue,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender),
            Material(
              elevation: 15.0,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
