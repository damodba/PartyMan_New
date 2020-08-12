import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:party_man/models/FunctionM.dart';
import 'package:party_man/models/ParticipationM.dart';
import 'package:party_man/models/UserM.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:party_man/models/FunctionM.dart';
import'package:party_man/models/FireBaseDB.dart';


class DatabaseHelper {

  FireBaseDB fbObj=FireBaseDB();

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database
  int _dbversion = 0;

  String function_detail = 'function_details'; //table name
  String colId          = 'partyid';
  String colTitle       = 'title';
  String colDescription = 'partydesc';
  String colStatus      = 'status'; // lov field
  String colHostedby    = 'hostedby'; //gkey of host
  String colVenue       = 'venue';
  String colCreatedDate = 'createddate'; //existing date
  String colPartyDate   = 'partydate';
  String colGmapvalue   = 'gmapdtls';
  String colImageurl    = 'imageurl';
  String colTrackReg    = 'trackreg';
  String colHostName    = 'hostname'; //host name
  String  colLiveAvl   =  'liveavl';
  String colLiveUrl     = 'liveurl';
  String colPartyGkey    ='partygkey';

//ParticipantM module
  String function_participants = 'function_participants';
  String colPartyId   = 'partyid';
  String colHostGkey  = 'hostgkey';
  String colGuestGkey = 'guestgkey';
  String colMemberCount ='membercount';
  String colTimeSlab    = 'timeslab';
  String colGuestStatus ='gueststatus';
  String colCreatedDateP = 'createddate';
  String colGkey = 'gkey';
  String colGuestName = 'guestname';
  String colGuestMobile = 'guestmobile';
  String colGuestEmail ='guestemail';
  String colGuestWhats ='guestwhatsapp';

  //UserM Module
  String  tuserM  = 'user_dtls';
  String colUserId  = 'userid';
  String colEmailId ='emailid';
  String colName    = 'name';
  String colAddress1 = 'address1';
  String colAddress2 = 'address2';
  String colCity = 'city';
  String colCountry = 'country';
  String colPincode = 'pincode';
  String colCreatedUser = 'createddate';
  String colMPhone = 'mphone';



  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var partyDatbase;
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    // print(directory.path);
    String path = directory.path + 'partys.db';

    // Open/create the database at a given path
    var partyDatabase;

    partyDatabase= await openDatabase(path, version: 7, onCreate: _createDb, onUpgrade:_upgradeDb);

    return partyDatabase;
  }
  void _upgradeDb(Database db, int oldVersion, int newVersion) async {
    debugPrint('inside upgradedb');
    List<dynamic> arguments;
    debugPrint('in new version 6 old version $oldVersion');
   //return;

    if (oldVersion < 2) {
      debugPrint('inside upgradedb less than 2');
      await db.execute(
          'CREATE TABLE $function_participants($colPartyId TEXT, $colHostGkey TEXT, '
              '$colGuestGkey TEXT, $colMemberCount INTEGER, $colTimeSlab TEXT,$colGuestStatus INTEGER,$colCreatedDateP TEXT)');

      await db.execute(
          'ALTER TABLE $function_detail ADD COLUMN [$colHostName TEXT, $colLiveAvl TEXT, $colLiveUrl TEXT]');

      debugPrint('inside upgradedb less than 3');

      await db.execute(
          'CREATE TABLE $tuserM($colUserId TEXT, $colName TEXT, $colAddress1 TEXT, $colAddress2 TEXT, $colCity TEXT,$colCountry TEXT,'
              '$colPincode TEXT, $colEmailId TEXT,$colMPhone TEXT,createddate TEXT)');
    }
      if (oldVersion < 3) {
        debugPrint('before droptable $oldVersion');
        await db.execute(
            'DROP TABLE $function_participants ');

        await db.execute(
            'CREATE TABLE $function_participants($colPartyId TEXT, $colHostGkey TEXT, '
                '$colGuestGkey TEXT, $colMemberCount INTEGER, $colTimeSlab TEXT,$colGuestStatus INTEGER,$colCreatedDateP TEXT)');
      }

      if (oldVersion < 4 ){
        debugPrint('before droptable $oldVersion');
        await db.execute(
            'ALTER TABLE $function_participants ADD COLUMN [$colGkey INTEGER PRIMARY KEY AUTOINCREMENT] ');

      }//now we are in version 4 indira


    if (oldVersion < 5 ){
      debugPrint('in version 5 old version $oldVersion');
      await db.execute(
          'ALTER TABLE $function_detail ADD COLUMN [$colPartyGkey TEXT] ');
    }//we are in version 5

    if (oldVersion < 7 ){
      debugPrint('in new version 6 old version $oldVersion');
      await db.execute(
          'ALTER TABLE $function_participants ADD COLUMN [$colGuestName TEXT,$colGuestMobile TEXT,$colGuestEmail TEXT, $colGuestWhats TEXT] ');
        }
  }

  void _createDb(Database db, int newVersion) async {
    debugPrint('inside createdb');
    await db.execute('CREATE TABLE $function_detail($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colStatus INTEGER, $colHostedby TEXT,$colVenue TEXT,$colCreatedDate TEXT,$colPartyDate TEXT,'
        '$colGmapvalue TEXT,$colImageurl TEXT,$colTrackReg INTEGER,$colHostName TEXT, $colLiveAvl TEXT, $colLiveUrl TEXT,$colPartyGkey TEXT)');

    await db.execute(
        'CREATE TABLE $function_participants($colPartyId TEXT, $colHostGkey TEXT, $colGkey INTEGER PRIMARY KEY AUTOINCREMENT,'
            '$colGuestGkey TEXT, $colMemberCount INTEGER, $colTimeSlab TEXT,$colGuestStatus INTEGER,$colCreatedDateP TEXT,'
            '$colGuestName TEXT,$colGuestMobile TEXT,$colGuestEmail TEXT, $colGuestWhats TEXT)');

    await db.execute(
        'CREATE TABLE $tuserM($colUserId TEXT, $colName TEXT, $colAddress1 TEXT, $colAddress2 TEXT, $colCity TEXT,$colCountry TEXT,'
            '$colPincode TEXT, $colEmailId TEXT,$colMPhone TEXT,createddate TEXT)');

  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getFunctionMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(function_detail, orderBy: '$colPartyDate ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertFunction(FunctionM functionM) async {
    Database db = await this.database;
    var result = await db.insert(function_detail, functionM.toMap());
        //functionM.partyGkey=functionM.hostedBy+result.toString();//not the best way
        //UpdateFunctioninLocal(functionM);
    String docId=functionM.hostedBy+result.toString();//or functionM.partygkey
   // functionM.partyGkey=functionM.hostedBy+result.toString();
    fbObj.addData('FunctionList',functionM.toMap(),docId);
    return result;
  }

  Future<int> insertFunctioninLocal(FunctionM functionM) async {
    Database db = await this.database;
    var result = await db.insert(function_detail, functionM.toMap());
    //String docId=functionM.hostedBy+result.toString();//functionM.partyid
    return result;
  }
  Future<int> UpdateFunctioninLocal(FunctionM functionM) async {
    Database db = await this.database;
    var result = await db.update(function_detail, functionM.toMap(), where: '$colId = ?', whereArgs: [functionM.partyid]);
    //String docId=functionM.hostedBy+result.toString();//functionM.partyid
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateFunction(FunctionM functionM) async {
    var db = await this.database;
    var result = await db.update(function_detail, functionM.toMap(), where: '$colId = ?', whereArgs: [functionM.partyid]);
    String docId=functionM.hostedBy+functionM.partyid.toString();
    debugPrint(docId);
    fbObj.updateData('FunctionList',docId,functionM.toMap());
    //String partyid='9090909030072020';
    //DocumentSnapshot FunctionfromFs = await fbObj.getData('FunctionList',partyid);
    //final Map<String, dynamic> doc = FunctionfromFs.data;
     //final Map<String, dynamic> map = FunctionfromFs.data;
     //FunctionM fun=FunctionM(map['partyid'],map['title'],map['partydesc'],map['status'],map['hostedby'],map['venue'],map['createddate'],map['partydate'],map['gmapdtls'],
       // map['imageurl'],map['trackreg'],map['hostname'],map['liveavl'],map['liveurl']);
    //FunctionM function=FunctionM.fromMapObject(map);
    //debugPrint(fun.toString());
    return result;
    //fbObj.getData('FunctionList',partyid);
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteFunction(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $function_detail WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getFunctionCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $function_detail');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<FunctionM>> getFunctionList() async {

    var FunctionMapList = await getFunctionMapList(); // Get 'Map List' from database
    int count = FunctionMapList.length;         // Count the number of map entries in db table

    List<FunctionM> FunctionList = List<FunctionM>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      FunctionList.add(FunctionM.fromMapObject(FunctionMapList[i]));
    }
    return FunctionList;
  }

  Future<UserM> getUserList() async{
    var UserMapList = await getUserMapList();
    return UserM.fromMapObject(UserMapList[0]);

  }

  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database db = await this.database;
    var result = await db.query(tuserM);
    return result;
  }
  Future<int> insertUser(UserM userM) async {
    Database db = await this.database;
    var result = await db.insert(tuserM, userM.toMap());
    fbObj.addUser('UserList',userM.toMap(),userM.userId);//.then can be used ,this is inserting in firestore db
    return result;
  }
  // Update Operation: Update a Note object and save it to database
  Future<int> updateUser(UserM userM) async {
    var db = await this.database;
    var result = await db.update(tuserM, userM.toMap(), where: '$colUserId = ?', whereArgs: [userM.userId]);
    fbObj.UpdateUser('UserList',userM.toMap(),userM.userId);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteUser(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $tuserM WHERE $colUserId = $id');
    return result;
  }

  Future<int> insertParticipant(ParticipantM participantM) async {
    Database db = await this.database;
    var result = await db.insert(function_participants, participantM.toMap());
    fbObj.addParticipant('ParticipantList',participantM.toMap());
    //fbObj.addUser('UserList',userM.toMap(),userM.userId);//.then can be used ,this is inserting in firestore db
    return result;
  }
  // Update Operation: Update a Note object and save it to database
  Future<int> updateParticipant(ParticipantM participantM) async {
    var db = await this.database;
    var result = await db.update(function_participants, participantM.toMap(), where: '$colGuestGkey = ? and $colPartyId = ?', whereArgs: [participantM.guestGkey,participantM.partyId]);
    debugPrint('updating in dbhelper');
    fbObj.UpdateParticipant('ParticipantList', participantM.toMap(),participantM.partyId, participantM.hostGkey);
    debugPrint('updating in firestore');
    //debugPrint(participantM.memberCount.toString());
    //fbObj.UpdateUser('UserList',userM.toMap(),userM.userId);
    return result;
  }
  Future<ParticipantM> Query(String partyid) async {
    var db = await this.database;
    List<Map<String, dynamic>> res= await db.rawQuery('SELECT * from function_participants where $colPartyId=$partyid ');
    debugPrint('inside query  $res.toString()');
    debugPrint('testing query bala');
    ParticipantM participantM= ParticipantM.fromMapObject(res[0]);
    return participantM;
  }




}