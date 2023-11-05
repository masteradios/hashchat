import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference userRef=FirebaseFirestore.instance.collection('users');
class SearchPage extends StatefulWidget {

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchname;
  String searchedemail;
  String searchResult='searchresult';
  bool showspinner=false;
  TextEditingController _controller=TextEditingController();
  Future getuserdata_witha_request() async {
    final QuerySnapshot snapshot=await userRef.where('Name',isGreaterThanOrEqualTo: searchname).get();
    for(var doc in snapshot.docs)
    {
      setState(() {
        searchedemail=doc['email'];
      });
      print('bruh name is'+doc['Name']);
      return doc['Name'];
    }



  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Scaffold
          (
          body:showspinner?Center(child: Container(child: CircularProgressIndicator(color: Colors.blue,),),): Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column
                (
                children: [
                  TextField(

                    keyboardType: TextInputType.text,
                    controller: _controller,
                    onChanged: (value) {
                      searchname=value;

                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        focusColor: Colors.black,
                        onPressed: ()async{
                          _controller.clear();
                          setState(() {
                            showspinner=true;
                          });
                          await getuserdata_witha_request().then((value)
                          {
                            setState(() {
                              searchResult=value;
                              showspinner=false;
                            });
                          });
                        },
                        icon: Icon(Icons.search_rounded),

                      ),
                      fillColor: Colors.white70,
                      filled: true,
                      labelStyle: TextStyle(fontSize: 15.0,color: Colors.black,fontWeight: FontWeight.bold),
                      hintText: 'Search by username',
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
                  Padding(padding: EdgeInsets.all(20),child:searchname!=null?Text('Search Results for "$searchname"'):Container() ,),

                  searchResult!='searchresult'?ListTile(subtitle: searchResult==searchname?Text(searchedemail):null,leading:searchResult==searchname? Icon(Icons.account_circle):null,title: searchResult==searchname?Text(searchResult):Center(child: Text('Not found',style: TextStyle(fontSize: 25),))):Container
                    (),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
