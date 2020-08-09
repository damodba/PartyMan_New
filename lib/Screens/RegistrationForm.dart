import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:party_man/Screens/FunctionList.dart';
import 'package:party_man/models/UserM.dart';
import'package:party_man/Utils/DatabaseHelper.dart';


class RegistrationForm extends StatefulWidget {
  UserM userM;
  String appBarTitle;
  //contructor
  RegistrationForm(this.userM,this.appBarTitle);

  State<StatefulWidget> createState() {
    return RegistrationFormState(this.userM,this.appBarTitle);
  }
}

class RegistrationFormState extends State<RegistrationForm> {
  final UserM userM;
  final String appBarTitle;
  RegistrationFormState(this.userM,this.appBarTitle);

  DatabaseHelper helper = DatabaseHelper();

  var _formKey = GlobalKey<FormState>();

  TextEditingController emailcontroller = TextEditingController();

  TextEditingController namecontroller = TextEditingController();

  TextEditingController phonenocontroller = TextEditingController();

  TextEditingController address1controller = TextEditingController();

  TextEditingController address2controller = TextEditingController();

  TextEditingController citycontroller = TextEditingController();

  TextEditingController countrycontroller = TextEditingController();

  TextEditingController pincodecontroller = TextEditingController();


  //final AuthService _auth=AuthService();
  @override
  Widget build(BuildContext context) {
    debugPrint('before asssigning');


    namecontroller.text=userM.name;
    phonenocontroller.text=userM.mPhone;
    address1controller.text=userM.address1;
    address2controller.text=userM.address2;
    citycontroller.text=userM.city;
    countrycontroller.text=userM.country;
    pincodecontroller.text=userM.pinCode;
    emailcontroller.text=userM.emailId;

   // debugPrint('after asssigning');
    TextStyle textStyle_subtitle2 = Theme.of(context).textTheme.subtitle1;
    return Scaffold(
      appBar: AppBar(title: Text(this.appBarTitle)),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(top:20.0,bottom: 20.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      //keyboardType: TextInputType.number,
                      style: textStyle_subtitle2,
                      controller: namecontroller,
                      //validator: (String value) {
                        //if (value.isEmpty) return 'Please enter Your Name';
                      //},
                      onChanged: (value){
                      //  debugPrint('on name cahnge');
                        updateName();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_pin, size: 30.0),
                        //labelText: 'Name',
                        hintText: 'Name',
                        labelStyle: textStyle_subtitle2,
                        errorStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: TextFormField(
                      //keyboardType: TextInputType.number,
                      style: textStyle_subtitle2,
                      controller: emailcontroller,
                      validator: (String value) {
                        if (value.isEmpty) return 'Please enter Your Email Id';
                      },
                      onChanged: (value){
                        updateEmail();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, size: 30.0),
                        hintText: 'Email Id',
                        labelStyle: textStyle_subtitle2,
                        errorStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: TextFormField(
                      //enabled: false,
                      keyboardType: TextInputType.number,
                      style: textStyle_subtitle2,
                      controller: phonenocontroller,
                      validator: (String value) {
                        if (value.length!=10)
                          return 'Please check you have entered valid phone number';
                      },
                      onChanged: (value){
                        updatePhoneno();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone, size: 30.0),
                        hintText: 'Phone number',
                        labelStyle: textStyle_subtitle2,
                        errorStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: TextFormField(
                      style: textStyle_subtitle2,
                      controller: address1controller,
                      validator: (String value) {
                        if (value.isEmpty) return 'Please enter Address';
                      },
                      onChanged: (value){
                        updateAdd1();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.menu, size: 30.0),
                        hintText: 'Address',
                        labelStyle: textStyle_subtitle2,
                        errorStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: TextFormField(
                      style: textStyle_subtitle2,
                      controller: address2controller,
                      validator: (String value) {
                        if (value.isEmpty) return 'Please enter Address';
                      },
                      onChanged: (value){
                        updateAdd2();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.menu, size: 30.0),
                        hintText: 'Address',
                        labelStyle: textStyle_subtitle2,
                        errorStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle_subtitle2,
                      controller: pincodecontroller,
                      validator: (String value) {
                        if (value.length!=6) return 'Please check you have entered a valid pin code';
                      },
                      onChanged: (value){
                        updatePin();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.add_location, size: 30.0),
                        hintText: 'Pin Code',
                        labelStyle: textStyle_subtitle2,
                        errorStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: TextFormField(

                      style: textStyle_subtitle2,
                      controller: citycontroller,
                      validator: (String value) {
                        if (value.isEmpty) return 'Please enter a city';
                      },
                      onChanged: (value){
                        updateCity();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.add_location, size: 30.0),
                        hintText: 'City',
                        labelStyle: textStyle_subtitle2,
                        errorStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                    child: TextFormField(
                      style: textStyle_subtitle2,
                      controller: countrycontroller,
                      validator: (String value) {
                        if (value.isEmpty) return 'Please enter country name';
                      },
                      onChanged: (value){
                        updateCountry();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.add_location, size: 30.0),
                        hintText: 'Country',
                        labelStyle: textStyle_subtitle2,
                        errorStyle: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  Center(
                    child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        child:userM.userId==null?Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.5,
                        ):Text(
                            "Update",
                            style: TextStyle(color: Colors.white),
                            textScaleFactor: 1.5,),
                        onPressed: ()  {
                            debugPrint("validation successfull");
                            _save();
                            NavigatorPop(context);
                            NavigatorPush(context);
                            //dynamic result= await _auth.registerWithEmailAndPassword(emailcontroller.text,passwordcontroller.text);
                           // print(result);

                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  updateName(){
    userM.name=namecontroller.text;
  }
  updateEmail(){
    userM.emailId=emailcontroller.text;
  }
  updatePhoneno(){
    userM.mPhone=phonenocontroller.text;
  }
  updateAdd1(){
    userM.address1=address1controller.text;
  }
  updateAdd2(){
    userM.address2=address2controller.text;
  }
  updatePin(){
    userM.pinCode=pincodecontroller.text;
  }
  updateCity(){
    userM.city=citycontroller.text;
  }
  updateCountry(){
    userM.country=countrycontroller.text;
  }

  void _save() async {
    debugPrint('Saving Your Changed');
    //userM.createdDate = DateFormat("yy-MM-dd").format(DateTime.now());
    String date=DateFormat("ddMMyy").format(DateTime.now());
    userM.createdDate = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(userM.userId != null){
      // Case 1: Update operation
      result = await helper.updateUser(userM);
      debugPrint('updating user in the database');
    }
    else if(userM.userId==null){
      // Case 2: Insert Operation
      debugPrint('inserting user in the database');
      userM.userId=userM.mPhone+date;
      result = await helper.insertUser(userM);
     // debugPrint(userM.userId);
    }
  }

  void NavigatorPush(context){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => FunctionList()
    ));
  }
  void NavigatorPop(context){
    Navigator.pop(context);
  }
}


