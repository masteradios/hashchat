import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference userRef =
    FirebaseFirestore.instance.collection('users');

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchname;
  String searchedemail;
  String searchResult = 'searchresult';
  bool showspinner = false;
  TextEditingController _controller = TextEditingController();
  Future getuserdata_witha_request() async {
    final QuerySnapshot snapshot =
        await userRef.where('Name', isEqualTo: searchname).get();
    for (var doc in snapshot.docs) {
      setState(() {
        searchedemail = doc['email'];
      });
      print('bruh name is' + doc['Name']);
      return doc['Name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _controller,
                    onChanged: (value) {
                      searchname = value;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        focusColor: Colors.blue,
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            showspinner = true;
                          });
                        },
                        icon: Icon(Icons.search_rounded),
                      ),
                      fillColor: Colors.white70,
                      filled: true,
                      labelStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      hintText: 'Search by username',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide:
                            BorderSide(width: 2, color: Color(0x40524f4f)),
                      ),
                      focusedBorder: (OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(width: 2, color: Colors.lightBlue),
                      )),
                    ),
                  ),
                  searchname == null
                      ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Image.asset('assets/search.png',height: 200,),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text('Search for users',style: TextStyle(fontSize: 25)),
                            ),
                          ],
                        ),
                      )
                      : Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text('Search Results for usernames having " $searchname " :'),
                              ),
                              Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .where('Name',
                                          isGreaterThanOrEqualTo: searchname)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          semanticsLabel: 'Please wait',
                                          color: Colors.black,
                                        ),
                                      );
                                    }
                                    if(snapshot.data.docs.length==0)
                                    {
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Container(
                                                child: Image.asset('assets/notfound.png'),height: MediaQuery.of(context).size.height/5,),
                                          ),
                                          Text('User Not Found !',style: TextStyle(fontSize: 25),),
                                        ],
                                      );
                                    }
                                 return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {

                                          return ListTile(
                                            leading:     Material(
                                              color: Colors.transparent,
                                              child: ClipOval(
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Image(
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.fill,
                                                    image: AssetImage('assets/nature.jpg'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Text(snapshot.data.docs[index]
                                                ['Name']),
                                            subtitle: Text(snapshot
                                                .data.docs[index]['email']),
                                          );
                                        });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Expanded(
// child: StreamBuilder<QuerySnapshot>(stream: _firebasefirestore.collection('messages').where('Name',isGreaterThanOrEqualTo: 'Aditya').snapshots(),
// builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot)
// {
//
//
//
//
// if(!snapshot.hasData)
// {
// return Center(
// child: CircularProgressIndicator(
// semanticsLabel: 'Please wait',
// color: Colors.black,
//
// ),
// );
// }
// else if(snapshot.hasData)
// {
// return ListView.builder
// (shrinkWrap: true,
// reverse: true,
// itemCount: snapshot.data.docs.length,
// itemBuilder: (BuildContext context,int index)
// {
// return MessageText(snapshot.data.docs[index]['sender'],snapshot.data.docs[index]['text'],loggeduser.email.toString());
// });
//
// }
//
//
// },
//
//
// ),
// ),
