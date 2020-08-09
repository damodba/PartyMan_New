//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:party_man/Screens/RegistrationForm.dart';
import 'package:party_man/Utils/DatabaseHelper.dart';
import 'package:party_man/models/FunctionM.dart';
import 'package:party_man/Screens/FunctionDetail.dart';
import 'package:party_man/models/UserM.dart';
import 'package:sqflite/sqflite.dart';
class MainDrawer extends StatefulWidget {

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

  DatabaseHelper databaseHelper = DatabaseHelper();

  void getUser() async{
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    //debugPrint('#1');
    dbFuture.then((database) {
      Future<UserM> user = databaseHelper.getUserList();
      //debugPrint('#2');
      user.then((user) {
        setState(() async {
          await Navigator.push(context,MaterialPageRoute(builder:(context){
            return RegistrationForm(user,'Update your Information');
          }));
        });
      });
      }); }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children:<Widget>[
          Container(
              width: double.infinity,
              height:150.0,
              color: Theme.of(context).primaryColor,
              child:Center(
                child: Text("Username",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0
                  ),),
              )
          ),
          Card(
            child: ListTile(
                leading: Icon(Icons.account_circle),
                title:Text("My Account",
                  style: TextStyle(
                      fontSize: 15.0
                  ),),
                onTap:(){
                  getUser();
                }
            ),
          ),
          Card(
            child: ListTile(
                leading: Icon(Icons.add),
                title:Text("Add New Party",
                  style: TextStyle(
                      fontSize: 15.0
                  ),),
                onTap:(){
                  navigateToFunctionReg( FunctionM.withourId('', '', 1, 'Addnote'), 'Add Party');
                }
            ),
          )
        ],
      ),
    );



  }
  //UserM user=UserM('indira@gmail.com090',null,'add1','add2','chennai','india','22222','2323','232323');


  void navigateToFunctionReg(functionList, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FunctionDetail(functionList, title);
    }));

  }

  //void navigateToUser(user) async{
    //debugPrint('phone->$user.mPhone');
    //await Navigator.push(context,MaterialPageRoute(builder:(context){
      //return RegistrationForm(user);
    //})
    //);
  //}
}

