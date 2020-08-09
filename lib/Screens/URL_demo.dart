import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class URL_demo extends StatefulWidget {
  @override
  _URL_demoState createState() => _URL_demoState();
}

class _URL_demoState extends State<URL_demo> {

  void _launchURL(String Url) async {
    if (await canLaunch(Url)) {
      await launch(Url);
    }
    else {
      throw 'Could not open $Url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Launch Url'),
          onPressed:(){_launchURL('https://www.google.com/maps/place/Phoenix+Marketcity+-+Viman+Nagar/@18.5624101,73.9149511,17z/data=!4m8!1m2!2m1!1sphoenix+market+city!3m4!1s0x3bc2c147b8b3a3bf:0x6f7fdcc8e4d6c77e!8m2!3d18.5620613!4d73.9167451');}
        ),
      ),
    );
  }
}