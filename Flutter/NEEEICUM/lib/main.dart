import 'Login/Splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Extras/PushNotificationsManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //add this
  await Firebase.initializeApp();
  runApp(MainCodePage());
}

class MainCodePage extends StatefulWidget {
  @override
  _MainCodePageState createState() => _MainCodePageState();
}

class _MainCodePageState extends State<MainCodePage> {
  @override
  void initState() {
    super.initState();
    PushNotificationsManager().init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEEEICUM',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(), //Scaffold(body: Text("SUPER OLAOLAOALALAOA")), //
      debugShowCheckedModeBanner: false, //false, //MyHomePage(),
    );
  }
}
