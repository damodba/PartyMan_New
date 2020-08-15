import 'package:flutter/cupertino.dart';

class ParticipantM {
  String _partyId;
  String _hostGkey;
  String _guestGkey;
  int _memberCount;
  String _timeSlab;
  int _guestStatus;
  String _createdDate;
  //$colGuestName TEXT,$colGuestMobile TEXT,$colGuestEmail TEXT, $colGuestWhats TEXT
  String _guestName;
  String _guestMobile;
  String _guestEmail;
  String _guestWhats;
  int _gkey; //autoincrement generated key

  static var _statusList = ['Registered', 'Confirmed', 'Not Attending'];

  ParticipantM(this._partyId, this._hostGkey, this._guestGkey,
      this._memberCount, this._timeSlab, this._guestStatus,this._guestName,this._guestMobile,this._guestEmail,this._guestWhats);

  String get partyId => _partyId;

  set partyId(String new_partyId) {
    this._partyId = new_partyId;
  }

  String get hostGkey => _hostGkey;

  set hostGkey(String new_hostGkey) {
    this._hostGkey = new_hostGkey;
  }

  String get guestGkey => _guestGkey;

  set guestGkey(String new_guestGkey) {
    this._guestGkey = new_guestGkey;
  }

  int get memberCount => _memberCount;

  set memberCount(int new_memberCount) {
    this._memberCount = new_memberCount;
  }

  String get timeSlab => _timeSlab;

  set timeSlab(String new_timeSlab) {
    this._timeSlab = new_timeSlab;
  }

  int get guestStatus => _guestStatus;

  set guestStatus(int new_guestStatus) {
    this._guestStatus = new_guestStatus;
  }

  String get createdDate => _createdDate;

  set createdDate(String new_createdDate) {
    this._createdDate = new_createdDate;
  }

  int get gkey => _gkey;

  set gkey(int newGkey) {
    this._gkey = newGkey;
  }

  String get guestName => _guestName;

  set guestName(String name) {
    this._guestName = name;
  }

  String get guestMobile => _guestMobile;
  set guestMobile(String num) {
    this._guestMobile = num;
  }
  String get guestEmail => _guestEmail;
  set guestEmail(String num) {
    this._guestEmail = num;
  }
  String get guestWhats => _guestWhats;
  set guestWhats(String num) {
    this._guestWhats = num;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_gkey != null) {
      map['gkey'] = _gkey;
    }
    map['partyId'] = _partyId;
    map['hostgkey'] = _hostGkey;
    map['guestgkey'] = _guestGkey;
    map['membercount'] = _memberCount;
    map['timeslab'] = _timeSlab;
    map['gueststatus'] = _guestStatus;
    map['createddate'] = _createdDate;
    map['guestname']=_guestName;
    map['guestmobile']=_guestMobile;
    map['guestemail']=_guestEmail;
    map['guestwhats']=_guestWhats;
    return map;
  }

  ParticipantM.fromMapObject(Map<String, dynamic> map) {
    _partyId = map['partyid'];
    _hostGkey = map['hostgkey'];
    _guestGkey = map['guestgkey'];
    _memberCount = map['membercount'];
    _timeSlab = map['timeslab'];
    _guestStatus = map['gueststatus'];
    _createdDate = map['createddate'];
    _gkey = map['gkey'];
    _guestName=map['guestname'];
    _guestMobile=map['guestmobile'];
    _guestEmail=map['guestemail'];
    _guestWhats=map['guestwhats'];
  }

  static getStatusAsString(int value) {
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

  //['Registered','Confirmed','Not Attending'];
  static int getStatusasint(String val) {
    int status;
    switch (val) {
      case 'Registered':
        status = 0;
        break;
      case 'Confirmed':
        status = 1;
        break;
      case 'Not Attending':
        status = 2;
        break;
      default:
        status = 0;
        break;
    }
    return status;
  }

  static String getstatusasString(int st) {
    String status;
    switch (st) {
      case 0:
        status = 'Registered';
        break;
      case 1:
        status = 'Confirmed';
        break;
      case 2:
        status = 'Not Attending';
        break;
      default:
        status = 'Registered';
        break;
    }
    return status;
  }
}