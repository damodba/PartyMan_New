import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AuthService{

  FirebaseAuth _auth = FirebaseAuth.instance;

     Future verifyPhoneNumber(String phone) async {
       var phoneNumber = phone;
       var timeout = Duration(seconds: 60);
     }

 }