import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {

  static String name;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firebasefirestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggeduser;
  String message='';
  final messagecontroller=TextEditingController();
  @override


  @override


  void getMessages() async {
    await for(var snapshot in _firebasefirestore.collection('messages').snapshots())
    {
      for(var messages in snapshot.docs.reversed)
      {
        print(messages.data());
      }

    }

  }
  void getcurrentuser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggeduser = user;
        print(loggeduser.email+loggeduser.uid);
      }
    } catch (e) {}
  }
  void redirectToURL()async {
    var url = Uri.parse("https://youtu.be/xvFZjo5PgG0");
    try
    {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
    catch(e)
    {
      print(e);
    }
  }

  void initState() {
    super.initState();
    getcurrentuser();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        leading: null,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        actions:
        <Widget>[
          IconButton(onPressed: ()
          {

             redirectToURL();

          }, icon: Icon(Icons.workspace_premium_outlined)),
        ],
        centerTitle: true,
        title: Image
          (
          height: 40.0,
          fit: BoxFit.contain,
          image:
          AssetImage('assets/hash.png'),
        ),
      ),
      body:
          Container(
            child: Column(
              children:<Widget> [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(stream: _firebasefirestore.collection('messages').orderBy('createdAt',descending: true).snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot)
                  {

                    if(!snapshot.hasData)
                    {
                      return Center(
                        child: CircularProgressIndicator(
                          semanticsLabel: 'Please wait',
                          color: Colors.black,

                        ),
                      );
                    }
                    else if(snapshot.hasData)
                    {
                      return ListView.builder
                        (shrinkWrap: true,
                          reverse: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context,int index)
                      {
                        return MessageText(snapshot.data.docs[index]['sender'],snapshot.data.docs[index]['text'],loggeduser.email.toString());
                      });

                    }


                  },


                  ),
                ),
                Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          controller: messagecontroller,
                          onChanged: (value)
                          {
                            setState((){message=value;});

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
                        child: IconButton(
                          onPressed: message.trim().isEmpty?null:() {
                             messagecontroller.clear();
                            _firebasefirestore.collection('messages').add(
                                {'text':message,
                                  'sender':loggeduser.email,
                                  'createdAt': Timestamp.now(),
                                }
                                );
                            getMessages();
                            setState(() {
                              message='';
                            });


                          },
                          icon: Icon(Icons.telegram),
                          iconSize: 40.0,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),



    );
  }
}
class MessageText extends StatelessWidget {
MessageText(this.sender,this.text,this.currentuser);
final String sender;
final String text;
final String currentuser;
  @override
  Widget build(BuildContext context) {
    if(sender==currentuser)
    {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(sender),
            Material
              (
              elevation: 15.0,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: Colors.lightBlue,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20.0),
                child: Text(text,style: TextStyle(color: Colors.black,fontSize: 15.0),),
              ),

            ),
          ],
        ),
      );
    }else
    {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender),
            Material
              (
              elevation: 15.0,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20.0),
                child: Text(text,style: TextStyle(color: Colors.black,fontSize: 15.0),),
              ),

            ),
          ],
        ),
      );


    }



  }
}
