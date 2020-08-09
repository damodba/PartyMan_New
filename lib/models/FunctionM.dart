import 'package:flutter/cupertino.dart';

class FunctionM {

  int _partyId;
  String _title;
  String _partyDesc;
  int   _status;
  String _hostedBy;
  String _venue;
  String _createdDate;
  String _partyDate;
  String _gmapDtls;
  String _imageUrl;
  int    _trackReg;
  String _hostName;
  String  _liveAvl;
  String _liveUrl ;
  String _partyGkey;

  String _date;
  int _priority;

  static var _statusList = ['Planned', 'Active','Cancelled'];


  FunctionM.withourId(this._date,this._partyDesc,this._status,this._title);
  FunctionM(this._partyId,this._title,this._partyDesc,this._status,this._hostedBy,this._venue,this._createdDate,this._partyDate,this._gmapDtls,
      this._imageUrl,this._trackReg,this._hostName,this._liveAvl,this._liveUrl,this._partyGkey); //bala
  //FunctionM.withId(this._id,this._date,this._description,this._priority,this._title);

  int get partyid  => _partyId;

  set partyid(int newid){
    this._partyId = newid;
  }
  String get title => _title;

  set title(String newTitle){
    this._title = newTitle;
  }

  String get partyDesc =>_partyDesc;

  set partyDesc(String newDesc){
    this._partyDesc = newDesc;
  }

  int get status =>_status;

  set status(int newStatus){
    this._status = newStatus;
  }

  String get hostedBy =>_hostedBy;

  set hostedBy(String newHostedBy){
    this._hostedBy = newHostedBy;
  }
  String get venue =>_venue;

  set venue(String newVenue){
    this._venue= newVenue;
  }

  String get createdDate =>_createdDate;

  set createdDate(String newCreatedDate){
    this._createdDate = newCreatedDate;
  }

  String get partyDate =>_partyDate;

  set partyDate(String newPartyDate){
    this._partyDate = newPartyDate;
  }

  String get gmapDtls =>_gmapDtls;

  set gmapDtls(String newGmapDtls){
    this._gmapDtls = newGmapDtls;
  }

  String get imageUrl =>_imageUrl;

  set imageUrl(String newImageUrl){
    this._imageUrl = newImageUrl;
  }

  int get trackReg =>_trackReg;

  set trackReg(int newTrackReg){
    this._trackReg = newTrackReg;
  }

  String get hostName =>_hostName;

  set hostName (String newhostName){
    this._hostName = newhostName;
  }

  String get liveAvl =>_liveAvl;

  set liveAvl(String newliveAvl){
    this._liveAvl = newliveAvl;
  }

  String get liveUrl =>_liveUrl;

  set liveUrl(String newliveUrl){
    this._liveUrl = newliveUrl;
  }

  String get partyGkey => _partyGkey;

  set partyGkey(String key){
    this._partyGkey = key;
  }

  //convert to map object
  Map<String,dynamic>toMap() {
    var map= Map<String,dynamic>();
    if (_partyId != null) {
      map['partyId']=_partyId;
    }

    map['title']=_title;
    map['partydesc']= _partyDesc;
    map['status']= _status;
    map['venue']= _venue;
    map['createddate']= _createdDate;
    map['partydate']= _partyDate;
    map['gmapdtls']= _gmapDtls;
    map['imageurl']= _imageUrl;
    map['trackreg']= _trackReg;
    map['hostname']= _hostName;
    map['liveavl']= _liveAvl;
    map['liveurl']= _liveUrl;
    map['hostedby']=_hostedBy;//indira
    map['partygkey']=_partyGkey;
    return map;
  }

  FunctionM.fromMapObject(Map<String,dynamic> map)
  {
    this._partyId   = map['partyid'];
    this._title     = map['title'];
    this._partyDesc = map['partydesc'];
    this._status    = map['status'];
    this._venue     = map['venue'];
    this._createdDate = map['createddate'];
    this._partyDate   = map['partydate'];
    this._gmapDtls    = map['gmapdtls'];
    this._imageUrl    = map['imageurl'];
    this._trackReg    = map['trackreg'];
    this.hostName     = map['hostname'];
    this.liveAvl      = map['liveavl'];
    this.liveUrl      = map['liveurl'];
    this.hostedBy     =map['hostedby'];
    this.partyGkey     =map['partygkey'];
  }

  static getStatusAsString (int value) {
    String status;
    switch (value) {
      case 1:
        status = _statusList[0]; // 'High'
        break;
      case 2:
        status = _statusList[1]; // 'Low'
        break;
      case 3:
        status = _statusList[2]; // 'Low'
        break;
    }
    return status;
  }



}