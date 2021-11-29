import '../HomePage.dart';
import 'SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(255, 102, 51, 1),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController controller = new TextEditingController();
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controllersocio = new TextEditingController();
  String textWarning = "";

  String number;
  String password;
  String name;
  String telemovel;
  String mail;
  String socio;
  bool cotas;

  void click() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    this.number = controller.text;
    this.password = controller1.text;

    await FirebaseFirestore.instance
        .collection("Logins")
        .doc(this.number.toString())
        .get()
        .then((onValue) {
      if (onValue.exists) {
        FirebaseFirestore.instance
            .collection("Logins")
            .doc(this.number.toString())
            .get()
            .then((pass) {
          if (this.password == pass["Password"]) {
            this.name = pass["Username"];
            this.telemovel = pass["telemovel"];
            this.mail = pass["mail"];
            this.socio = pass["socio"];

            prefs.setString('name', this.name);
            prefs.setString('number', this.number);
            prefs.setString('password', this.password);
            prefs.setString('telemovel', this.telemovel);
            prefs.setString('mail', this.mail);
            prefs.setString('socio', this.socio);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        HomePage(this.number, this.socio)));
          } else {
            this.textWarning = "Password Incorreta";
            setState(() {});
          }
        });
      } else {
        this.textWarning = "Conta inexistente";
        setState(() {});
      }
    });
  }

  void newAccount() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SignUpPage()));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
          alignment: Alignment.center,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Align(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: this.controller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.confirmation_number),
                          labelText: "Número Aluno",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  /*Align(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: this.controllersocio,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.confirmation_number),
                          labelText: "Número Socio",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.black)),
                        ),
                      ),
                    ),
                  ),*/
                  Align(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: this.controller1,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.star),
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(textWarning),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: FloatingActionButton.extended(
                            backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                            onPressed: this.newAccount,
                            label: Text("SignUp",
                                style: TextStyle(color: Colors.white)),
                            icon: Icon(
                              Icons.create,
                              color: Colors.white,
                            ),
                            heroTag: null,
                          ),
                        ),
                      ),
                      Align(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: FloatingActionButton.extended(
                            backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                            onPressed: click,
                            label: Text("Login",
                                style: TextStyle(color: Colors.white)),
                            icon: Icon(
                              Icons.login,
                              color: Colors.white,
                            ),
                            heroTag: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ))),
    );
  }
}
