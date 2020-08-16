import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:party_man/Screens/GenerateQRcode.dart';
import 'package:party_man/models/UserM.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:party_man/Utils/DatabaseHelper.dart';
import 'package:party_man/models/FunctionM.dart';
import 'package:party_man/models/FireBaseDB.dart';
import 'dart:async';
import 'TrackRegistration.dart';
import 'package:path_provider/path_provider.dart';

class FunctionDetail extends StatefulWidget {
  @override
  final FunctionM functionM;
  final String appBarTitle;

  FunctionDetail(this.functionM, this.appBarTitle);

  State<StatefulWidget> createState() {
    return FunctionDetailState(this.functionM, this.appBarTitle);
  }
}

class FunctionDetailState extends State<FunctionDetail> {
  int count = 1;
  DatabaseHelper databaseHelper = DatabaseHelper();
  FireBaseDB fbObj=FireBaseDB();

  static var _status = ['Planned', 'Active', 'Cancelled'];
  DatabaseHelper helper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController partydateController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController gmapDtlsController = TextEditingController();
  TextEditingController imageContoller = TextEditingController();

  FunctionM functionM;
  String appBarTitle;

  FunctionDetailState(FunctionM functionM, String appBarTitle) {
    this.functionM = functionM;
    this.appBarTitle = appBarTitle;
  }

  bool checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle_H6 = Theme.of(context).textTheme.bodyText1;
    TextStyle textStyle_title = Theme.of(context).textTheme.title;
    EdgeInsets TextEdgeInsets = EdgeInsets.only(top: 5.0, bottom: 5.0);

     titleController.text = functionM.title;
    descriptionController.text = functionM.partyDesc;
    partydateController.text = functionM.partyDate;
    venueController.text = functionM.venue;
    gmapDtlsController.text = functionM.gmapDtls;
    imageContoller.text = functionM.imageUrl;
    checkBoxValue = checkbox_value(functionM.trackReg);
    //debugPrint(functionM.partyGkey);

    DateTime _partyDateTime;

    return WillPopScope(
      onWillPop: () {
        moveToPreviousScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.appBarTitle),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToPreviousScreen();
              }),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: Scrollbar(
            child: ListView(
              children: <Widget>[
                //first element
                ListTile(
                    title: DropdownButton(
                        items: _status.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        style: textStyle_H6,
                        value: FunctionM.getStatusAsString(functionM.status),
                        onChanged: (valueSelectedByUser) {
                          setState(() {
                            debugPrint('User selected $valueSelectedByUser');
                            updateStatusAsInt(valueSelectedByUser);
                          });
                        })),
                //Second Element Title
                Padding(
                  padding: TextEdgeInsets,
                  child: TextField(
                    controller: titleController,
                    style: textStyle_H6,
                    onChanged: (value) {
                      debugPrint("Something Changed in Text field");
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle_H6,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),
                //Text(functionM.partyGkey),
                //Third Element partydesc
                Padding(
                  padding: TextEdgeInsets,
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle_H6,
                    maxLines: null,
                    onChanged: (value) {
                      debugPrint("Something Changed in desc  field");
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle_H6,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),

                //Fourth Element
                Padding(
                    padding:TextEdgeInsets,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: partydateController,
                            style: textStyle_H6,
                            decoration: InputDecoration(
                                labelText: 'Party Date',
                                labelStyle: textStyle_H6,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.calendar_today),
                            //label:Text('Pick a date'),
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: _partyDateTime == null
                                    ? DateTime.now()
                                    : _partyDateTime,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 2),
                              ).then((date) {
                                setState(() {
                                  _partyDateTime = (date);
                                  updatePartyDate((_partyDateTime).toString());
                                });
                              });
                            }),
                      ],
                    )),
                //fifth element
                Padding(
                  padding: TextEdgeInsets,
                  child: TextField(
                    controller: venueController,
                    style: textStyle_H6,
                    onChanged: (value) {
                      debugPrint("Something Changed in venue  field");
                      updateVenue();
                    },
                    decoration: InputDecoration(
                        labelText: 'Venue',
                        labelStyle: textStyle_H6,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),
                //sixth element
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: TextEdgeInsets,
                        child: TextField(
                          controller: gmapDtlsController,
                          style: textStyle_H6,
                          onChanged: (value) {
                            debugPrint("Something Changed in gmapdtls  field");
                            updateGmap();
                          },
                          decoration: InputDecoration(
                              labelText: 'Gmap dtls',
                              labelStyle: textStyle_H6,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 30.0,
                      icon: Icon(Icons.location_on),
                      onPressed: () {
                        _launchURL('https://google.com/maps');
                      },
                    )
                  ],
                ),
                //sixth element
                Padding(
                  padding: TextEdgeInsets,
                  child: TextField(
                    controller: imageContoller,
                    style: textStyle_H6,
                    onChanged: (value) {
                      debugPrint("Something Changed in image url  field");
                      updateImagedtls();
                    },
                    decoration: InputDecoration(
                        labelText: 'Image URL',
                        labelStyle: textStyle_H6,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),
                ListTile(
                  title: Text('Track Registration', style: textStyle_H6),
                  leading: Checkbox(
                    value: checkBoxValue,
                    onChanged: (bool value) {
                      setState(() {
                        checkBoxValue = value;
                        debugPrint('$value');
                        updateTrackField(value);
                      });
                    },
                  ),
                ),
                //7th
                checkBoxValue == true
                    ? GestureDetector(
                      onTap: (){
                        debugPrint('tapped');
                        navigatetotrack(context);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          width: 20.0,
                          height: 40.0,
                          child: Center(
                              child: Text(
                            "Track Now",
                            style: TextStyle(fontSize: 20.0,color: Colors.black),
                          ))),
                    )
                    : Text(''),
                //8th element save delete button
                Padding(
                  padding: TextEdgeInsets,
                  child: Row(
                    children: <Widget>[
                  SizedBox(
                    width: 80.0,
                    height: 40.0,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            "Save",
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () => setState(() {
                            debugPrint("save button clicked");
                            _save();
                            moveToLastScreen();
                          }),
                        ),
                      ),
                      Container(
                        width: 3.0,
                      ),
                      SizedBox(
                        width: 100.0,
                        height: 40.0,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,

                          child: Text(
                            "Delete",
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () => setState(() {
                            debugPrint("Delete button clicked");
                            _delete();
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                //seventh element ends
              ],
            ),
          ),
        ),
      ),
    );
  }

  //convert the int to string in checkbox field
  bool checkbox_value(int value) {
    if (value == 1) {
      return true;
    } else
      return false;
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updateStatusAsInt(String value) {
    switch (value) {
      case 'Planned':
        functionM.status = 1;
        break;
      case 'Active':
        functionM.status = 2;
        break;
      case 'Cancelled':
        functionM.status = 3;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown

  // Update the title of Note object
  void updateTitle() {
    functionM.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    functionM.partyDesc = descriptionController.text;
  }

  void updatePartyDate(String partyDateTime) {
    functionM.partyDate = partyDateTime;
  }

  void updateVenue() {
    functionM.venue = venueController.text;
  }

  void updateGmap() {
    functionM.gmapDtls = gmapDtlsController.text;
  }

  void updateImagedtls() {
    functionM.imageUrl = imageContoller.text;
  }

  void updateTrackField(bool value) {
    //debugPrint('$value');
    if (value == true) {
      functionM.trackReg = 1;
    } else
      functionM.trackReg = 0;
    //debugPrint('${functionM.trackReg}');
  }

// Save data to database

  void _save() async {
    //UserM user;
    int result = 0;
    UserM userM = await getUserValue();
    //debugPrint(userM.name);
    //debugPrint(userM.toString());
    functionM.createdDate = DateFormat.yMMMd().format(DateTime.now());
    if (functionM.partyid != null) {
      // Case 1: Update operation
      debugPrint('INSIDE Update OPERATION');
      result = await helper.updateFunction(functionM);
    } else {
      // Case 2: Insert Operation
      functionM.hostedBy = userM.userId;
      debugPrint('INSIDE INSERT OPERATION');
      result = await helper.insertFunction(functionM);
      String paryId = functionM.hostedBy + result.toString();
      navigateToGenerateQr(paryId);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  UserM getUser() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<UserM> userM = databaseHelper.getUserList();
      userM.then((userM) {
        //debugPrint(userM.toString());
        //debugPrint(userM.userId);
        return userM;
      });
    });
  }

  Future<UserM> getUserValue() async {
    //final Database dbFuture = await databaseHelper.initializeDatabase();
    UserM userM = await databaseHelper.getUserList();
    return userM;
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (functionM.partyid == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteFunction(functionM.partyid);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void moveToPreviousScreen() {
    Navigator.pop(context);
  }

  void _launchURL(String Url) async {
    if (await canLaunch(Url)) {
      await launch(Url);
    } else {
      throw 'Could not open $Url';
    }
  }

  void navigateToGenerateQr(String PartyId) async {
    debugPrint('generate qr');
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return GenerateQRcode(PartyId);
    }));
  }


void navigatetotrack(context) async {
  String id=functionM.hostedBy+functionM.partyid.toString();
  bool result =
  await Navigator.push(context, MaterialPageRoute(builder: (context) {
    return TrackRegistration(id);
  }));
}
}