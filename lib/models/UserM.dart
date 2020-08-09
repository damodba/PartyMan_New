import 'dart:core';

import 'package:flutter/cupertino.dart';

class UserM {
  String _userId;
  String _emailId;
  String _name;
  String _address1;
  String _address2;
  String _city;
  String _country;
  String _pincode;
  String _createdDate;
  String _mPhone;


  UserM(this._emailId, this._name, this._address1,
      this._address2,this._city,this._country, this._pincode, this._createdDate,this._mPhone);//this works correctly
  //UserM(this._userId, this._emailId, this._name, this._address1,
    //  this._address2,this._city,this._country, this._pincode, this._createdDate,this._mPhone);

  String get userId =>_userId;

  set userId(String newUserId) {
    this._userId = newUserId;
  }

  String get emailId =>_emailId;

  set emailId (String newEmailId) {
    this._emailId = newEmailId;
  }

  String get name =>_name;

  set name(String newName) {
    this._name =  newName;
  }

  String get address1 =>_address1;

  set address1 (String newAddress1) {
    this._address1 = newAddress1;
  }

  String get address2 =>_address2;

  set address2 (String newAddress2) {
    this._address2 = newAddress2;
  }

  String get pinCode =>_pincode;

  set pinCode (String newPincode) {
    this._pincode = newPincode;
  }

  String get createdDate =>_createdDate;

  set createdDate (String newcreatedDate) {
    this._createdDate = newcreatedDate;
  }

  String get mPhone =>_mPhone;

  set mPhone (String newmPhone) {
    this._mPhone = newmPhone;
  }

  String get city =>_city;

  set city (String newcity) {
    this._city = newcity;
  }


  String get country =>_country;

  set country (String newcountry) {
    this._country = newcountry;
  }


  Map<String,dynamic>toMap() {
    var map= Map<String,dynamic>();
    map['userid']=_userId;
    map['emailid']=_emailId;
    map['name']=_name;
    map['address1']=_address1;
    map['address2']= _address2;
    map['city']= _city;
    map['country']= _country;
    map['pincode']=_pincode;
    map['createddate']=_createdDate;
    map['mphone']=_mPhone;
    return map;
  }

  UserM.fromMapObject(Map<String,dynamic> map)
  {
    this._userId =map['userid'];
    this._emailId =map['emailid'];
    this._name =map['name'];
    this._address1 =map['address1'];
    this._address2 =map['address2'];
    this._city =map['city'];
    this._country =map['country'];
    this._pincode =map['pincode'];
    this._createdDate =map['createddate'];
    this._mPhone =map['mphone'];
debugPrint( 'mphone $this._mPhone');
  }


}