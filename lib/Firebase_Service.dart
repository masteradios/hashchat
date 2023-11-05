import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'grouplist.dart';
CollectionReference groupRef=FirebaseFirestore.instance.collection('groups');
class Auth
{

  Future<User> getcurrrentUser ()async
  {
    var logggeduser=await _auth.currentUser;
    return logggeduser;
  }
  final _auth=FirebaseAuth.instance;
  Future createuser(String fullName,String email,String password)async
  {
    try {
      final User newUser = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
      if(newUser!=null)
      {
        await Database().storeuserdata(newUser.email,fullName,newUser.uid);
        return true;


      }
    }
    on FirebaseAuthException catch(e)
    {
      print(e);
      return e.message;

    }
  }


}

class Database
{
  Future creategroup(String groupname,String adminname,String adminid,String email,String  useruid)async
  {
    DocumentReference groupDocumentReference=await groupRef.add(
        {
          'groupid':"",
          'groupname':groupname,
          'admin':'${adminname}',
          'members':[],
          'recentMessage':"",
        });

    await groupDocumentReference.update(
        {
          'groupid':groupDocumentReference.id,
          'members':FieldValue.arrayUnion(["${useruid}_${adminname}"])


        });
    DocumentReference userReference=FirebaseFirestore.instance.collection('users').doc(email);
    return userReference.update(
        {
          'groups':FieldValue.arrayUnion(['${groupDocumentReference.id}_${groupname}']),
        });

  }


  void storeuserdata(String email,String fullName,String useruid) async {
    final _firebasefirestore=FirebaseFirestore.instance;
    try {

        _firebasefirestore.collection('users').doc(email).set(
            {'uid':useruid,
          'email':email,
           'createdAt': Timestamp.now(),
          'Name':fullName,
              'groups':[]
        });
      }
      on FirebaseAuthException catch (e)
    {
      print(e);
    }
    }

void updateUserinfo(String email,String field,String newdata)async
{
  await userRef.doc(email).update(
      {
        field:newdata,
      });
}

  Future getuserNamebyid(String uid) async {
    DocumentSnapshot doc=await userRef.doc(uid).get();
    print('hiiiiiiiiiiiiiiiiiiiiii+no'+doc.data().toString());
    print('heloooooooooooooo'+doc['Name']);
    return doc['Name'];

  }




  }



