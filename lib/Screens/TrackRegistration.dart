import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  _TrackRegistrationState(this.id);

  FireBaseDB fbObj = FireBaseDB();

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
              if(!snapshot.hasData){ return Center(
                child: SpinKitRotatingCircle(
                  color: Colors.lightBlue,
                  size: 50.0,
                ),
              );}
              int len=snapshot.data.documents.length;
              int confirmed = 0, notattending = 0, registered = 0;
              for(int position=0;position<len;position++) {
                if (snapshot.data.documents[position]['gueststatus'] == 0)
                  {registered =registered+
                  snapshot.data.documents[position]['membercount'];
                }
                if (snapshot.data.documents[position]['gueststatus'] == 1) {
                  confirmed = confirmed +
                      snapshot.data.documents[position]['membercount'];
                }
                 if (snapshot.data.documents[position]['gueststatus'] == 2)
                  notattending =notattending+
                  snapshot.data.documents[position]['membercount'];
              }
              //debugPrint(snapshot.data.documents.length.toString()); //working
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(child: Text('$registered \n rcount'),
                    backgroundColor: Theme
                        .of(context)
                        .primaryColorLight,
                    radius: 50.0,),

                  CircleAvatar(child: Text('$confirmed \n ccount'),
                    backgroundColor: Theme
                        .of(context)
                        .primaryColorLight,
                    radius: 50.0,),


                  CircleAvatar(child: Text('$notattending \n nacount'),
                    backgroundColor: Theme
                        .of(context)
                        .primaryColorLight,
                    radius: 50.0,),
                  //Text(snapshot.data.documents[postion]['gueststatus'].toString()),
                ],
              );
          },
        ),
      ),
    );
  }
}
