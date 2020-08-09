import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:party_man/Utils/FormRow.dart';
import 'package:party_man/models/UserM.dart';
import 'FunctionDetail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:party_man/Utils/DatabaseHelper.dart';
import 'package:party_man/models/FunctionM.dart';
import 'package:party_man/models/ParticipationM.dart';
import 'package:url_launcher/url_launcher.dart';



class FunctionListView extends StatefulWidget {
  @override

  FunctionM functionM;
  String title;

  FunctionListView(this.functionM, this.title);

  State<StatefulWidget> createState() {
    return FunctionListStateView(this.functionM, this.title);
  }
}

class FunctionListStateView extends State<FunctionListView> {

  DatabaseHelper helper = DatabaseHelper();
  List<FunctionM> functionList;

  int count = 0;
  TextEditingController count_Controller = TextEditingController();
  int no_of_people = 0;
  FunctionM functionM;
  String title;
  List<String> List_Status = ['Registered','Confirmed','Not Attending'];
  String Status_of_user = 'Registered';

  FunctionListStateView(this.functionM, this.title);

  void _launchURL(String Url) async {
    if (await canLaunch(Url)) {
      await launch(Url);
    }
    else {
      throw 'Could not open $Url';
    }
  }


  @override
  Widget build(BuildContext context) {
    TextStyle textStyle_H6 = Theme
        .of(context)
        .textTheme
        .headline6;

    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Party Details Full '),
      ),
      body: Scrollbar(
        child: Container(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                FormRow('Party Title:', functionM.title),
                FormRow('Party Desc:', functionM.partyDesc),
                FormRow('Venue:', functionM.venue),
                //FormRow('Gmap:', functionM.gmapDtls),


                Container(
                  //color: Colors.white,
                  padding: EdgeInsets.all(10.00),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child:
                          Text('Gmap Link:', style: textStyle_H6,)),
                      Expanded(
                        flex: 3,
                        child: RaisedButton.icon(
                            icon:Icon(Icons.location_on),
                            label:Text("Google Map Link"),
                            onPressed: () {
                              _launchURL(functionM.gmapDtls);
                            }
                        ),
                      ),

                    ],
                  ),
                ),

                Container(
                  //color: Colors.white,
                  padding: EdgeInsets.all(10.00),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child:
                          Text('Card Url:', style: textStyle_H6,)),
                      Expanded(
                        flex: 3,
                        child: RaisedButton.icon(
                            icon:Icon(Icons.image),
                            label:Text("Image Url"),
                            onPressed: () {
                              _launchURL(functionM.imageUrl);
                            }
                        ),
                      ),

                    ],
                  ),
                ),


                FormRow('Status: ', FunctionM.getStatusAsString(functionM.status)),
                FormRow('Party Date:', functionM.partyDate),

                Text("No of People attending:", style: textStyle_H6),
                ListTile(
                    dense: true,

                    leading: GestureDetector(
                        child: Icon(Icons.add, size: 30.0, color: Colors.black),
                        onTap: () {
                          setState(() {
                            no_of_people += 1;
                          });
                        }),
                    trailing:
                    GestureDetector(child: Icon(
                        Icons.minimize, size: 30.0, color: Colors.black),
                        onTap: () {
                          setState(() {
                            if (no_of_people > 0) {
                              no_of_people = no_of_people - 1;
                            }
                          });
                        }),
                    title: Text('$no_of_people', style: textStyle_H6,)
                ),
                ListTile(
                    title: DropdownButton(
                        items: List_Status.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        style: textStyle_H6,
                        value: Status_of_user,
                        onChanged: (valueSelectedByUser) {
                          setState(() {
                            Status_of_user = valueSelectedByUser;
                          });
                        })),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
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
                          }),
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            "Close",

                            textScaleFactor: 1.5,
                          ),
                          onPressed: () => setState(() {
                            debugPrint("Close button clicked");
                            moveToLastScreen();
                          }),
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
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _save()async{
    int result;
    int result1;
    //String partid=functionM.hostedBy+functionM.partyid.toString();
    //int status=ParticipantM.getStatusasint(Status_of_user);
   // var paticipationM=ParticipantM(partid,functionM.hostedBy,'sds',no_of_people,'0',status);
    int status=ParticipantM.getStatusasint(Status_of_user);
    UserM userM = await getUserValue();
    var participantM=ParticipantM(functionM.partyGkey,functionM.hostedBy,userM.userId,no_of_people,'0',status);
    if(participantM.gkey==null){
     result1=await helper.insertParticipant(participantM);
     debugPrint("added a row in participant table");
     functionM.partyid=null;
     result = await helper.insertFunctioninLocal(functionM);
     debugPrint("added funtion in the databasre");
    }

    //adds only in the local database not in firebase db
    //result_2= await helper.i
    //debugPrint(result.toString());
  }


  Future<UserM> getUserValue() async{
    //final Database dbFuture = await databaseHelper.initializeDatabase();
    UserM  userM = await helper.getUserList();
    return userM;
  }


}
