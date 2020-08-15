import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:party_man/models/FireBaseDB.dart';
import 'package:party_man/models/ParticipationM.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  
  bool checkboxvalue=false;
  _TrackRegistrationState(this.id);
 Widget res;
  FireBaseDB fbObj = FireBaseDB();
  int status=0;



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

                    partiR.add(ParticipantM(snapshot.data.documents[position]['partyid'],snapshot.data.documents[position]['hostgkey'],snapshot.data.documents[position]['guestgkey'],
                                          snapshot.data.documents[position]['membercount'],snapshot.data.documents[position]['timeslab'],snapshot.data.documents[position]['gueststatus'],
                                          snapshot.data.documents[position]['guestname'],snapshot.data.documents[position]['guestmobile'],snapshot.data.documents[position]['guestemail'],
                                          snapshot.data.documents[position]['guestwhats']));
                  }
                  if (snapshot.data.documents[position]['gueststatus'] == 1) {
                    confirmed = confirmed +
                        snapshot.data.documents[position]['membercount'];

                    partiC.add(ParticipantM(snapshot.data.documents[position]['partyid'],snapshot.data.documents[position]['hostgkey'],snapshot.data.documents[position]['guestgkey'],
                        snapshot.data.documents[position]['membercount'],snapshot.data.documents[position]['timeslab'],snapshot.data.documents[position]['gueststatus'],
                        snapshot.data.documents[position]['guestname'],snapshot.data.documents[position]['guestmobile'],snapshot.data.documents[position]['guestemail'],
                        snapshot.data.documents[position]['guestwhats']));

                  }
                   if (snapshot.data.documents[position]['gueststatus'] == 2)
                    notattending =notattending+
                    snapshot.data.documents[position]['membercount'];

                  partiNA.add(ParticipantM(snapshot.data.documents[position]['partyid'],snapshot.data.documents[position]['hostgkey'],snapshot.data.documents[position]['guestgkey'],
                      snapshot.data.documents[position]['membercount'],snapshot.data.documents[position]['timeslab'],snapshot.data.documents[position]['gueststatus'],
                      snapshot.data.documents[position]['guestname'],snapshot.data.documents[position]['guestmobile'],snapshot.data.documents[position]['guestemail'],
                      snapshot.data.documents[position]['guestwhats']));

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
                   PrintList(partiR),
                   //printNames(snapshot, context, status),
                    //Text(snapshot.data.documents[postion]['gueststatus'].toString()),
                  ],
                );
            },
          ),
        ),
      );
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
                      checkboxvalue = value;
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
  Widget printNames(snapshot,BuildContext context,int status){
    debugPrint('inside printnames' + status.toString());
    return Expanded(
      child: ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder:(context,int position){
           debugPrint(snapshot.data.documents[position]['gueststatus'].toString());
           debugPrint(snapshot.data.documents[position]['membercount'].toString());
           debugPrint(snapshot.data.documents.length.toString());
          if(snapshot.data.documents[position]['gueststatus']==status) {////snapshot.data.documents[position]['membercount'].toString()),
            return Card(
              //color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
              ),
              //elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    flex:2,
                    child: Text(
                                 "Indira Priyadharshini",style: TextStyle(fontSize: 20.0),
                 ),
                  ),
                  Expanded(
                    flex:2,
                    child: Text(
                      "dharshinibalamurugan31@gmail.com \n 9898989898",style: TextStyle(fontSize: 15.0,fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    flex:1,
                    child: Checkbox(
                      value: checkboxvalue,
                      onChanged: (bool value) {
                        setState(() {
                          checkboxvalue = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

