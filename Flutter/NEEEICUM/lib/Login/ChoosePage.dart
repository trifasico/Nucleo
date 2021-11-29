import 'LoginPage.dart';
import 'SignUpPage.dart';
import 'package:flutter/material.dart';

class ChoosePage extends StatefulWidget {
  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  void navigationSignUp() async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SignUpPage()));
  }

  void navigationLogIn() async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/Base.png"),
        fit: BoxFit.cover,
      )),
      //color: Color.fromRGBO(255, 102, 51, 1),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text(" ")),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton.extended(
                  backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                  heroTag: null,
                  onPressed: navigationSignUp,
                  label: Text(
                    "Signup",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  icon: Icon(
                    Icons.create,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                FloatingActionButton.extended(
                  backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                  heroTag: null,
                  onPressed: navigationLogIn,
                  label: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  icon: Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                ),
              ]),
          SizedBox(height: 50),
        ],
      )),
    ));
  }
}
