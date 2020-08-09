import 'package:flutter_share_file/flutter_share_file.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';

class GenerateQRcode extends StatefulWidget {
  String partyId;
  GenerateQRcode(this.partyId);
  @override
  _GenerateQRcodeState createState() => _GenerateQRcodeState(this.partyId);
}

class _GenerateQRcodeState extends State<GenerateQRcode> {
  //String qrdata="hellojdhfjwbss";
  GlobalKey globalKey = new GlobalKey();
  String partyId;
  _GenerateQRcodeState(this.partyId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Your QR code")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: Container(
                width: 300.0,
                height: 300.0,
                child: RepaintBoundary(
                    key: globalKey,
                    child: QrImage(data:partyId)),  //error can also be checked
              ),//parameterized constructor
            ),
            SizedBox(
              height: 50.0,
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text("Save",style: TextStyle(color:Colors.white),),
              onPressed: ()async {
                _captureAndSharePng();
                //var _image = MemoryImage(img);//Decodes the given Uint8List buffer as an image, associating it with the given scale.
                  //Directory dir = await getApplicationDocumentsDirectory();
                  //File testFile = new File("${dir.path}/image.png");
                  //FlutterShareFile.share('testFile','img.png', ShareFileType.image);
                //final tempDir = await getTemporaryDirectory();
                //debugPrint(tempDir.toString());
                //final file = await new File('${tempDir.path}/image.png').create();
                //await file.writeAsBytes(img);
                //final channel = const MethodChannel('channel:me.alfian.share/share');
                //channel.invokeMethod('shareFile', 'image.png');
                //debugPrint(img.toString());
              }
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _captureAndSharePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
      globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      //print(pngBytes);
      //print(bs64);
      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);
      final channel = const MethodChannel('channel:insaan/share');
      channel.invokeMethod('shareFile', 'image.png');

    } catch (e) {
      print(e);
    }
  }



}
