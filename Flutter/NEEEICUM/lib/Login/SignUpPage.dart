import '../HomePage.dart';
import 'LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp", style: TextStyle(color: Colors.white)),
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
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  TextEditingController controller5 = new TextEditingController();
  TextEditingController controller6 = new TextEditingController();
  String name;
  String number;
  String password;
  String telemovel;
  String mail;
  String socio = "000";
  String textinho = " ";
  bool cotas = false;

  void click() async {
    this.name = controller.text;
    this.number = controller1.text;
    this.password = controller2.text;
    this.mail = controller3.text;
    this.telemovel = controller4.text;
    this.socio = controller5.text;

    print(this.name.length.toString() +
        " | " +
        this.number.length.toString() +
        " | " +
        this.socio.length.toString() +
        " | " +
        this.mail.length.toString() +
        " | " +
        this.telemovel.length.toString() +
        " | |" +
        this.password.length.toString() +
        "|");

    if (this.name.length <= 0 ||
        this.number.length <= 0 ||
        this.password.length <= 0 ||
        this.mail.length <= 0 ||
        this.telemovel.length <= 0) {
      textinho = "Ups... Deixou algum dos campos vazio";
      setState(() {});
    } else if (this.password != this.controller6.text) {
      textinho = "Ups... As palavras pass não coincidem";
      setState(() {});
    } else {
      await FirebaseFirestore.instance
          .collection('Logins')
          .doc(this.number)
          .get()
          .then((value) => {
                if (value.exists == true)
                  {
                    textinho = "Ups... Essa conta já existe",
                    setState(() {}),
                  }
                else
                  {
                    novaConta(),
                  }
              });
    }
  }

  void novaConta() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    this.name = controller.text;
    this.number = controller1.text;
    this.password = controller2.text;
    this.mail = controller3.text;
    this.telemovel = controller4.text;
    this.socio = controller5.text;

    prefs.setString('name', this.name);
    prefs.setString('number', this.number);
    prefs.setString('password', this.password);
    prefs.setString('telemovel', this.telemovel);
    prefs.setString('mail', this.mail);
    prefs.setString('socio', this.socio);

    await FirebaseFirestore.instance.collection('Logins').doc(this.number).set({
      'Username': this.name,
      'Password': this.password,
      'telemovel': this.telemovel,
      'mail': this.mail,
      'socio': this.socio,
      'cotas': this.cotas,
      'Kits': {},
      'Posts': <dynamic>[],
      'visitas': <dynamic>[],
      'visitasConf': <dynamic>[]
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                HomePage(this.number, this.socio)));
  }

  void existingAccount() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
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
                        controller: this.controller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Nome de Aluno",
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
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: this.controller1,
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
                  Align(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: this.controller5,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.confirmation_number),
                          labelText: "Número Socio",
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
                      child: TextField(
                        controller: this.controller3,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "Email",
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
                      child: TextField(
                        controller: this.controller4,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone_iphone),
                          labelText: "Número de Telemóvel",
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
                      child: TextField(
                        controller: this.controller2,
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
                      child: TextField(
                        controller: this.controller6,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.star),
                          labelText: "Repeat Password",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  Text(textinho),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: FloatingActionButton.extended(
                            backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                            onPressed: existingAccount,
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
                      Align(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: FloatingActionButton.extended(
                            backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                            onPressed: click,
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
                    ],
                  ),
                ],
              ))),
    );
  }
}
