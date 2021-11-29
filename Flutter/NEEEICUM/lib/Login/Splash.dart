import '../HomePage.dart';
import 'SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String imagePath = "assets/images/Icon.jpg";
  String number;
  String socio;
  int version = 0;
  int localVersion = 4;
  bool cotas;

  void delay() {}

  void navigationPageHome() async {
    print("version: " + version.toString());
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => HomePage(number, socio)));
  }

  void navigationPageWel() async {
    print("version: " + version.toString());
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SignUpPage()));
  }

  endTime() async {
    if (localVersion >= version) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      bool firstTime = prefs.getBool('first_time');
      String name = prefs.getString('name');
      number = prefs.getString('number');
      socio = prefs.getString('socio');
      if (name == null) firstTime = true;

      var _duration = new Duration(seconds: 1);

      if (firstTime != null && !firstTime) {
        // Not first time
        return new Timer(_duration, navigationPageHome);
      } else {
        // First time
        prefs.setBool('first_time', false);
        return new Timer(_duration, navigationPageWel);
      }
    }
  }

  Future startTime() async {
    var firestore = FirebaseFirestore.instance;
    var docRef = firestore.collection('Info').doc("Version");
    var querySnap = await docRef.get().then((value) => {
          version = value["version"],
          print("VersionServidor: " + version.toString()),
          endTime(),
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: startTime(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      imagePath,
                      //height: 300,
                    ),
                    //Text("OLA"),
                  ],
                ),
              ),
            );
          } else {
            //startTime();
            //endTime();
            return Scaffold(
              backgroundColor: Colors.white,
              body: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      imagePath,
                      //height: 300,
                    ),
                    SizedBox(height: 50),
                    (localVersion >= version)
                        ? Text("")
                        : Text("Por Favor Atualize a app"),
                    //Text("OLA"),
                  ],
                ),
              ),
            );
          }
        });
  }
}
