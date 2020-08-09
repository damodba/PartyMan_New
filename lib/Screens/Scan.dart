import 'package:flutter/material.dart';
import 'package:party_man/Screens/FunctionDetail.dart';
import 'package:party_man/Screens/FuntionListView.dart';
import 'package:party_man/Utils/ScanHelper.dart';
import 'package:party_man/models/FunctionM.dart';
import 'package:party_man/models/ParticipationM.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  GlobalKey qrkey=GlobalKey();
  String qrtext="";
  QRViewController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("QR code scanner"))
        ,
        body:Column(
          children: <Widget>[
            Expanded(
              flex:5,
              child:QRView(key:qrkey,onQRViewCreated:_onQRViewCreate),

            ),
            Expanded(
                child: Text("Scan result :$qrtext")
            ),

          ],
        )
    );
  }

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreate(QRViewController controller){
    this.controller=controller;
    controller.scannedDataStream.listen((ScanDate) {
      setState(() {
        qrtext=ScanDate;
        //debugPrint(qrtext);
        func(qrtext);
      });
    });
  }

  void func(String qrtext)async{
    var scan=ScanHelper(qrtext);
    FunctionM functioM=await scan.PartyIdtoFunction(scan.partyiD);
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:(BuildContext context)=>FunctionListView(functioM,'Party Details',ParticipantM('','','',0,'',0))
      )
    );
    //debugPrint(functioM.hostedBy);
  }
}