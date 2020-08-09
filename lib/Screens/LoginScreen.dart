import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:party_man/Screens/FunctionList.dart';
import 'package:party_man/Screens/RegistrationForm.dart';
import 'package:party_man/Screens/UserDetails.dart';
import 'package:party_man/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:party_man/Screens/home.dart';
import 'package:party_man/models/UserM.dart';
class LoginScreen extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  // ignore: missing_return
  Future<bool> loginUser(String phone, BuildContext context) async{
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async{
          Navigator.of(context).pop();//this pops out the alert dialog

          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;
          print(user.phoneNumber);
          if(user != null){
            NavigatorPop(context);
            NavigatorPush(context);
          }else{
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception){
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Give the code?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async{
                        final code = _codeController.text.trim();
                        AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);

                        AuthResult result = await _auth.signInWithCredential(credential);

                        FirebaseUser user = result.user;

                        if(user != null){
                          NavigatorPop(context);
                          NavigatorPush(context);
                        }else{
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              }
          );
        },
        codeAutoRetrievalTimeout: null
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle_subtitle1 = Theme.of(context).textTheme.subtitle1;
    return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(20.0),
              //padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Register Your Mobile Number", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30.0, fontWeight: FontWeight.w500),),

                    SizedBox(height: 16,),

                    Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: TextFormField(
                        //keyboardType: TextInputType.number,
                        style: textStyle_subtitle1,
                        controller: _phoneController,
                        validator: (String value) {
                          if (value.length!=10)
                            return 'Please check you have entered valid phone number';
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone, size: 30.0),
                          hintText: 'Phone number',
                          labelStyle: textStyle_subtitle1,
                          errorStyle: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ),

                    SizedBox(height: 16,),
                    Center(child: Text("An OTP will be sent to the above phone number")),
                    Center(
                      child: RaisedButton(
                        child:Text('PUSHME'),
                         onPressed:(){
                          NavigatorPush(context);
                        }
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top:25.0),
                        width: 140.0,
                       // height:double.infinity,
                        child: FlatButton(
                          //child: Text("LOGIN",style: TextStyle(fontSize: 15.0,fontWeight:FontWeight.bold),),
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white),
                            textScaleFactor: 1.5,
                          ),
                          textColor: Theme.of(context).primaryColorLight,
                          padding: EdgeInsets.all(16),
                          onPressed: () {
                            final phone = '+91'+_phoneController.text.trim();
                            loginUser(phone, context);
                          },
                          color:Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
  // ignore: non_constant_identifier_names
  void NavigatorPush(context){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => RegistrationForm(UserM('','','','','','','','',''),'Your Information')
    ));
  }
  void NavigatorPop(context){
    Navigator.pop(context);
  }
}