import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:party_man/models/ParticipationM.dart';
import 'package:party_man/models/UserM.dart';
import 'FunctionDetail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:party_man/Utils/DatabaseHelper.dart';
import 'package:party_man/models/FunctionM.dart';
import 'dart:developer' as dev;
import 'package:party_man/Screens/Drawer.dart';
import 'package:party_man/Screens/Scan.dart';
import 'FuntionListView.dart';

class FunctionList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FunctionListState();
  }
}

class FunctionListState extends State<FunctionList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<FunctionM> functionList;
  int count = 0;
  int sta;
  bool no_list=true;
  @override
  Widget build(BuildContext context) {
    if (functionList == null) {
      functionList = List<FunctionM>();
      updateFunctionList();
    }
    else {
      updateFunctionList(); //this is done because the list is not getting refreshed indira
    }
    //debugPrint(no_list.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Party Details .....'),
      ),
      body:getFunctionDetailsView(),
      drawer: MainDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Scan();
          }));
          debugPrint('FAB clicked');

        },
        tooltip: 'Scan QR code',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
  Widget Addparty(){
    return Column(
      children: <Widget>[
        SizedBox(height: 40.0),
        Center(child: Text("No Parties Scheduled Yet",style:TextStyle(fontSize: 30.0),)),
        GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: Text("Add a new One",style:TextStyle(fontSize: 20.0),)),
              Icon(Icons.add,
                  color: Theme.of(context).primaryColor,
                  size:20.0
              ),
            ],

          ),
          onTap: (){
            debugPrint("tapped ");
            navigateToFunctionReg(FunctionM.withourId('', '', 1, 'Addnote'), 'Add Party');
          },
        ),
        SizedBox(height: 40.0),
        CircleAvatar(
          radius: 110.0,
          backgroundImage: AssetImage('images/party_img.png')
        )
      ],
    );

  }
  Stack getFunctionDetailsView() {
    TextStyle titlestyle = Theme.of(context).textTheme.subtitle1;//checks the theme in the parent widgets
    return Stack(
      children: <Widget>[
        Image(
         image:AssetImage('images/party_notify.png'),
          width: double.maxFinite,
          height:400.0
        ),
        DraggableScrollableSheet(
          builder: (BuildContext context,ScrollController scrollcontroller) {
            return Container(
              //margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(15.0),
              //color: Colors.deepOrange.shade300,
            child:ListView.builder(
              controller: scrollcontroller,
              itemCount: count,
              itemBuilder: (BuildContext context, int position) {
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: getColor(
                          this.functionList[position].status),
                      child: Icon(Icons.keyboard_arrow_right,
                          size: 25.0,
                          color: Colors.white),
                    ),
                    title: Text(
                      (this.functionList[position].partyDate != null ? this
                          .functionList[position].partyDate : ''),
                      style: titlestyle,
                    ),
                    subtitle: Text(
                      this.functionList[position].partyDesc,
                      style: titlestyle,
                    ),
                    trailing: GestureDetector(
                      child: Icon(
                        Icons.delete,
                        color: Colors.blue,
                      ),
                      onTap: () {
                        _delete(context, functionList[position]);
                      },
                    ),
                    onTap: () async {
                      debugPrint("List Tile tabbed");
                      bool res = await ChangeAccordingly(
                          functionList[position].hostedBy);
                      res == true
                          ? navigateToFunctionReg(
                          this.functionList[position], 'Edit Note')
                          : //here comes change
                      navigateToDetail(this.functionList[position],
                          'Edit Note'); //here comes details of party

                    },
                  ),
                );
              },
            ),);
          },
        ),
      ],
    );
  }
  Future<bool> ChangeAccordingly(String hostedby)async {
    bool res;
    final Database dbFuture = await databaseHelper.initializeDatabase();
    UserM user = await databaseHelper.getUserList();
    if(user!=null)
    {
      user.userId==hostedby?res=true:res=false ;
      return res;//changed indira
    }
  }
  Color getColor(int status_id){
  if(status_id==1)
    return Colors.yellow;
  else if(status_id==2)
     return Colors.green;
  else if(status_id==3)
     return Colors.red;
  }
  void _delete(BuildContext context, FunctionM functionM) async {
    int result = await databaseHelper.deleteFunction(functionM.partyid);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted succcesfully');
      updateFunctionList();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);//we are finding the scafold in the widget tree
  }


  void navigateToDetail(FunctionM functionList, String title) async {
    String partykey=functionList.partyGkey;
    ParticipantM parti = await databaseHelper.Query(partykey);
    //debugPrint("must print after");
    if(parti!=null){
      debugPrint('the party exists and is queryed from participat table');
      debugPrint(parti.toString());
    }
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FunctionListView(functionList, title,parti);
    }));

    if (result = true) {
      updateFunctionList();
    }//wht is this for??
  }
  void navigateToFunctionReg(functionList, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FunctionDetail(functionList, title);
    }));

    if (result = true) {
      updateFunctionList();
    }
  }



  void updateFunctionList() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<FunctionM>> functionListFuture = databaseHelper.getFunctionList();
      functionListFuture.then((functionList) {
        setState(() {
          this.functionList = functionList;
          this.count = functionList.length;
        });
      });
    });
  }
}