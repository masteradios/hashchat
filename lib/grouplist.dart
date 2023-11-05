import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hashchat/Firebase_Service.dart';
import 'package:hashchat/chats.dart';
import 'package:hashchat/groups.dart';
import 'package:hashchat/home.dart';
import 'package:hashchat/search.dart';
import 'package:hashchat/userprofile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
final CollectionReference userRef=FirebaseFirestore.instance.collection('users');

class GroupList extends StatefulWidget {
  GroupList(this.email);
  final String email;

  static String name='';
  String Name;
  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  void logout ()async {
    _auth.signOut();
    Navigator.popUntil(context, ModalRoute.withName('/'));
    Navigator.pushNamed(context, '/');
  }
  alertmethod() {
    Alert(
      onWillPopActive: true,
        context:context,
        title: 'Are you sure you want to logout ??',

        buttons: [
          DialogButton(child: Text('Yes'), onPressed:(){logout();}),
          DialogButton(child: Text('No'), onPressed:(){Navigator.pop(context);})

        ]
    ).show();

  }
  final _auth=FirebaseAuth.instance;
  String _username='';
  void getuserNamebyid() async {
    DocumentSnapshot doc=await FirebaseFirestore.instance.collection('users').doc(loggeduser.email).get();
    print('heloooooooooooooo'+doc['Name']);

    setState(() {
      _username=  doc['Name'];
    });

  }
  User loggeduser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
    getuserNamebyid();
  }
  void getcurrentuser() async {
    try {
      final user = _auth.currentUser;
      if (user != null)
      {
        loggeduser = user;
        print('hiiiiiiiiiiiiiiiiiiiiiiiiiiii'+loggeduser.email);

      }
    } catch (e) {}
  }
  void getuserdata() async {
    await for(var snapshot in userRef.snapshots())
    {
      for(var doc in snapshot.docs)
      {
        print('hiiiiiiiiiiiiiiiiiiiiii'+doc.data().toString());
        print('hiiiiiiiiiiiiiiiiiiiiii'+doc.id.toString());
      }
    }

  }
int _index=0;
List<Widget> tabitems=
[
  Groups(),
  Search()

];
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      drawer: Drawer
        (
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Container(
            child: Column
              (
              children:
              [

                Icon(Icons.account_circle,size: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: Text(_username.toString(),style: TextStyle(fontSize: 20),),),
                ),
                SizedBox(height: 20,),
                // TextButton(
                //   onPressed: ()
                //   {
                //     Navigator.pushNamed(context, '/chats');
                //   },
                //   child:DrawerContent(Icons.group,'Groups') ,
                // ),
                TextButton(
                  onPressed: ()
                  {
                    Navigator.push(context,MaterialPageRoute(builder: (context){return UserProfile(widget.email);}));
                  },
                  child:DrawerContent(Icons.person,'Profile') ,
                ),
                TextButton(
                  onPressed: (){alertmethod();},
                  child:DrawerContent(Icons.logout,'Logout') ,
                ),
              ],
            ),
          ),
        ),

      ),
bottomNavigationBar: BottomNavigationBar
  (iconSize: 30,
  selectedItemColor: Colors.blueAccent,
  unselectedItemColor: Colors.grey,
  selectedFontSize: 10,
  unselectedFontSize: 10,
  currentIndex: _index,
  onTap: (index)
  {
    setState(()
    {
      _index=index;
    });

  },
  items:
  [
    BottomNavigationBarItem(icon: Icon(Icons.home_filled),label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.search_rounded),label: ''),
  ],
),
      appBar: AppBar(
        iconTheme: IconThemeData(color:Colors.white),
        leading: null,
        backgroundColor: Colors.blue,
        toolbarHeight: 60,
        centerTitle: true,
        title: Image
          (
          height: 40.0,
          fit: BoxFit.contain,
          image:
          AssetImage('assets/hash.png'),
        ),
      ),
      body: tabitems[_index],
    );
  }
}

class DrawerContent extends StatelessWidget {
  DrawerContent(this.icon,this.title);
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ListTile(iconColor: Colors.blueAccent,
      leading: Icon(icon,size: 30,),
      title: Text(title,style: TextStyle(fontSize: 25),),
    );
  }
}
