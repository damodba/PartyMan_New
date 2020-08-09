import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'UserM.dart';

class FireBaseDB{
  QuerySnapshot function;
  UserM userm;
  Future<void> addData(String Collection_name,functionDtls,String partyID) async{
    Firestore.instance.collection(Collection_name).document(partyID).setData(functionDtls).catchError((e){
      print(e);
    });
  }
  Future<void> addUser(String Collection_name,UserDtls,String UserId) async{
    Firestore.instance.collection(Collection_name).document(UserId).setData(UserDtls).catchError((e){
      print(e);
    });
  }

  Future<void> UpdateUser(String Collection_name,UserDtls,String UserId) async{
     //Firestore.instance.collection(Collection_name).add(UserDtls).
    Firestore.instance.collection(Collection_name).document(UserId).updateData(UserDtls).catchError((e){
      print(e);
    });
  }

  Future<void> updateData(String Collection_name,String docId,functionDtls) async{
    Firestore.instance.collection(Collection_name).document(docId).updateData(functionDtls).catchError((e){
      print(e);
    });
  }

  Future<void> deleteData(String Collection_name,String docId) async{
    Firestore.instance.collection(Collection_name).document(docId).delete().catchError((e){
      print(e);
    });
  }

   Future<DocumentSnapshot> getData(String Collection_name,String docId) async {
   //Firestore.instance.collection(Collection_name).document(docId).get().then((value) {  debugPrint(value.data.toString()); return value;});
   DocumentSnapshot func=await Firestore.instance.collection(Collection_name).document(docId).get();
   return func;

  }

  Future<void> addParticipant(String Collection_name,paticipantm) async{
    Firestore.instance.collection(Collection_name).add(paticipantm).catchError((e){
      print(e);
    });
  }

  Future<void> UpdateParticipant(String Collection_name,participantM,String PARTYID,String HOSTGKEY) async {
    QuerySnapshot func=await Firestore.instance.collection(Collection_name)
                         .where('partyId', isEqualTo:PARTYID)
                         .where('hostgkey', isEqualTo: HOSTGKEY).getDocuments();
    Firestore.instance.collection(Collection_name).document(func.documents[0].documentID).updateData(participantM).catchError((e){
    print(e);
    });


  }

}