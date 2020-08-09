import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:party_man/models/FunctionM.dart';
import'package:party_man/models/FireBaseDB.dart';
import 'package:flutter/cupertino.dart';
class ScanHelper{
   //String partyid='9090909030072020';
  String partyiD;
  ScanHelper(String partyid){
    this.partyiD=partyid;
  }

   Future<FunctionM> PartyIdtoFunction(String PartyId) async{
     FireBaseDB fbObj=FireBaseDB();
    DocumentSnapshot FunctionfromFs = await fbObj.getData('FunctionList',PartyId);
    //debugPrint(FunctionfromFs.data.toString()); working
    final Map<String, dynamic> map = FunctionfromFs.data;
     //debugPrint(map.toString()); working
     //debugPrint(map['partyId'].toString());
    FunctionM fun=FunctionM(map['partyId'],map['title'],map['partydesc'],map['status'],map['hostedby'],map['venue'],map['createddate'],map['partydate'],map['gmapdtls'],
    map['imageurl'],map['trackreg'],map['hostname'],map['liveavl'],map['liveurl'],PartyId);
    //debugPrint(fun.toString());
    //FunctionM function=FunctionM.fromMapObject(map);
    //debugPrint(function.partyDate);
    return fun;
  debugPrint(fun.toString());
  }


}
