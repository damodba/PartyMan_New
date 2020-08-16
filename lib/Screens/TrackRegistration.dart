import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:party_man/models/FireBaseDB.dart';
import 'package:party_man/models/ParticipationM.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
class TrackRegistration extends StatefulWidget {
  String id;
  TrackRegistration(this.id);
  @override
  _TrackRegistrationState createState() => _TrackRegistrationState(this.id);
}

class _TrackRegistrationState extends State<TrackRegistration> {
  String id;
  static const platform = const MethodChannel('sendSms');
  List<ParticipantM> partiR=[];
  List<ParticipantM> partiC=[];
  List<ParticipantM> partiNA=[];
  List<ParticipantM> choosed=[];

  _TrackRegistrationState(this.id);
 Widget res;
  FireBaseDB fbObj = FireBaseDB();
  int status=0;
  TextEditingController smscontroller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    // int number= 9090909030072032;
    ParticipantM partiregister;
    return Scaffold(
        appBar: AppBar(title: Text('Your Party Registration Details')),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('ParticipantList')
                .where('partyId', isEqualTo: id)
                .snapshots(),
            builder: (context, snapshot) {
                partiR=[];
                partiC=[];
                partiNA=[];
                if(!snapshot.hasData){ return Center(
                  child: SpinKitRotatingCircle(
                    color: Theme.of(context).primaryColorLight,
                    size: 50.0,
                  ),
                );}
                int len=snapshot.data.documents.length;
                int confirmed = 0, notattending = 0, registered = 0;
                for(int position=0;position<len;position++) {
                  if (snapshot.data.documents[position]['gueststatus'] == 0)
                    {registered =registered+
                    snapshot.data.documents[position]['membercount'];

                    partiR.add(ParticipantM.withcheckbox(snapshot.data.documents[position]['partyid'],snapshot.data.documents[position]['hostgkey'],snapshot.data.documents[position]['guestgkey'],
                                          snapshot.data.documents[position]['membercount'],snapshot.data.documents[position]['timeslab'],snapshot.data.documents[position]['gueststatus'],
                                          snapshot.data.documents[position]['guestname'],snapshot.data.documents[position]['guestmobile'],snapshot.data.documents[position]['guestemail'],
                                          snapshot.data.documents[position]['guestwhats'],false));


                    }
                  if (snapshot.data.documents[position]['gueststatus'] == 1) {
                    confirmed = confirmed +
                        snapshot.data.documents[position]['membercount'];

                    partiC.add(ParticipantM.withcheckbox(snapshot.data.documents[position]['partyid'],snapshot.data.documents[position]['hostgkey'],snapshot.data.documents[position]['guestgkey'],
                        snapshot.data.documents[position]['membercount'],snapshot.data.documents[position]['timeslab'],snapshot.data.documents[position]['gueststatus'],
                        snapshot.data.documents[position]['guestname'],snapshot.data.documents[position]['guestmobile'],snapshot.data.documents[position]['guestemail'],
                        snapshot.data.documents[position]['guestwhats'],false));

                  }
                   if (snapshot.data.documents[position]['gueststatus'] == 2) {
                     notattending = notattending +
                         snapshot.data.documents[position]['membercount'];

                     partiNA.add(ParticipantM.withcheckbox(
                         snapshot.data.documents[position]['partyid'],
                         snapshot.data.documents[position]['hostgkey'],
                         snapshot.data.documents[position]['guestgkey'],
                         snapshot.data.documents[position]['membercount'],
                         snapshot.data.documents[position]['timeslab'],
                         snapshot.data.documents[position]['gueststatus'],
                         snapshot.data.documents[position]['guestname'],
                         snapshot.data.documents[position]['guestmobile'],
                         snapshot.data.documents[position]['guestemail'],
                         snapshot.data.documents[position]['guestwhats'],false));
                   }
                }

                //debugPrint(snapshot.data.documents.length.toString()); //working
                return Column(
                    //textDirection: TextDirection.ltr,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            debugPrint('tapped');
                           setState(() {
                           choosed=partiR;
                           });
                            //debugPrint(partiR[0].memberCount.toString());
                           // status=0;
                            //printNames(snapshot, context, 0);
                          },
                          child: CircleAvatar(child: Text('$registered \n rcount'),
                            backgroundColor: Theme
                                .of(context)
                                .primaryColorLight,
                            radius: 50.0,),
                        ),

                        GestureDetector(
                          onTap: (){
                            debugPrint('tapped');
                            //status=1;
                            setState(() {
                              choosed=partiC;
                            });
                            //printNames(snapshot, context, 1);
                          },
                          child: CircleAvatar(child: Text('$confirmed \n ccount'),
                            backgroundColor: Theme
                                .of(context)
                                .primaryColorLight,
                            radius: 50.0,),
                        ),

                        GestureDetector(
                          onTap: (){
                            debugPrint('tapped');
                            //status=2;
                            setState(() {
                              choosed=partiNA;
                            });
                              //printNames(snapshot, context, 2);
                          },
                          child: CircleAvatar(child: Text('$notattending \n nacount'),
                            backgroundColor: Theme
                                .of(context)
                                .primaryColorLight,
                            radius: 50.0,),
                        ),
                      ],
                    ),
                    sizedBox(),
                   PrintList(choosed),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextField(
                        controller: smscontroller,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.message),
                            labelText: 'SMS text/Email msg',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      ),
                    ),
                   Row(
                     children: <Widget>[
                       FlatButton(
                           color: Theme.of(context).primaryColorLight,
                           onPressed: (){
                             sendsms(smscontroller.text);
                           },
                           child:Text("send SMS")
                       ),
                       Container(
                         width: 10.0,
                       ),
                       FlatButton(
                           color: Theme.of(context).primaryColorLight,
                           onPressed: (){
                             sendemail(smscontroller.text);
                           },
                           child:Text("send Email")
                       )
                     ],
                   )


                   //printNames(snapshot, context, status),
                    //Text(snapshot.data.documents[postion]['gueststatus'].toString()),
                  ],
                );
            },
          ),
        ),
      );
  }

  void sendsms(String smscontroller){
      String sms1='sms:6369288457,9840349055?body=$smscontroller';
      launch(sms1);
  }
  void sendemail(String emailcontroller){
    var email="mailto:dharshinibalamurugan31@gmail.com,lalithbalamurugan@gmail.com?body=$emailcontroller";//subject can be there
    launch(email);
  }
  Widget sizedBox(){
    return SizedBox(height: 5.0);
  }

  Widget PrintList(List<ParticipantM> partiR){
    int i;
    int len=partiR.length;

    return Expanded(
      child: ListView.builder(
        itemCount: len,
        itemBuilder: (context,int pos){
          bool checkboxvalue=partiR[pos].checkboxVal;
          return Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
              Expanded(
              flex:2,
              child: Text(
                partiR[pos].guestName,style: TextStyle(fontSize: 20.0),
              ),
            ),
              Expanded(
                flex:2,
                child: Text(
                    partiR[pos].guestMobile,style: TextStyle(fontSize: 15.0,fontStyle: FontStyle.italic),
                ),
              ),
              Expanded(
                flex:1,
                child: Checkbox(
                  value: checkboxvalue,
                  onChanged: (bool value) {
                    setState(() {
                      partiR[pos].checkboxVal=value;
                    });
                  },
                ),
              )
          ])
          );
        },
      ),
    );

  }
  //partiR[pos].memberCount.toString()

}

//if (Platform.isAndroid) {
//
//} else if (Platform.isIOS) {
//
//}