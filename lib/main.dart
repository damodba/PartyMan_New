import 'package:flutter/material.dart';
import 'package:party_man/Screens/FunctionList.dart';
import 'package:party_man/Screens/GenerateQRcode.dart';
import 'package:party_man/Screens/LoginScreen.dart';
import 'package:party_man/Screens/RegistrationForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:party_man/models/UserM.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseUser check() {
    FirebaseAuth.instance.currentUser().then(
            (FirebaseUser) => FirebaseUser);
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Party Man',
      theme: ThemeData(primarySwatch: Colors.brown),

      //this property we can use it in any part of program
      debugShowCheckedModeBanner: false,
      //home:check()!= null?FunctionList():LoginScreen()
      //home:RegistrationForm(UserM('','','','','','','','',''))
      home:FunctionList()
    );
  }
}
