import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../Extras/ShowTeamPage.dart';
import '../Extras/DateTimePicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login/Splash.dart';
import '../Inscrito/Inscrito.dart';

class PersonalArea extends StatefulWidget {
  String number = "ola";
  String socio = "ola1";
  bool cotas = false;

  @override
  PersonalArea(this.number, this.socio);
  _PersonalAreaState createState() => _PersonalAreaState();
}

class _PersonalAreaState extends State<PersonalArea> {
  Future getValuesPersonal() async {
    await FirebaseFirestore.instance
        .collection("Logins")
        .doc(this.widget.number)
        .get()
        .then((value) {
      print(value.metadata.isFromCache ? "QQ Cache" : "QQ Network");
      this.widget.cotas = value["cotas"];
      this.widget.socio = value["socio"];
    });
  }

  void _goToInscritos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => InscritoWidget()),
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pop(context);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color(121212),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(255, 102, 51, 1),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'NEEEICUM ', // + textNet,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Image.asset(
                        "assets/images/Icon.png",
                        //fit: BoxFit.cover,
                        height: 45,
                      ),
                    ],
                  ),
                ),
              ]),
        ),
        body: FutureBuilder(
            future: getValuesPersonal(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return new Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    children: <Widget>[
                      SizedBox(height: 100),
                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Card(
                                  color: Color.fromRGBO(255, 102, 51, 1),
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text(
                                        "Número de aluno: " +
                                            this.widget.number,
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      )),
                                )
                              ])),
                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Card(
                                  color: Color.fromRGBO(255, 102, 51, 1),
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text(
                                        "Número de Sócio: " +
                                            this.widget.socio.toString(),
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      )),
                                )
                              ])),
                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                          child:
                              Text("Este QRCode é usado para te identificares",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ))),
                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Card(
                                    child: QrImage(
                                  data: this.widget.number.toString(),
                                  version: QrVersions.auto,
                                  size: 170.0,
                                ))
                              ])),
                      Container(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                              child: (this.widget.socio != "")
                                  ? Text(
                                      this.widget.cotas
                                          ? "As tuas cotas encontram-se em dia 😊"
                                          : "As tuas cotas não se encontram em dia. \nDirige-te a sala do Núcleo para as pagares",
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "Ainda não és sócio do Núcleo, marca uma visita e faz te sócio agora!",
                                      textAlign: TextAlign.center))),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Color.fromRGBO(255, 102, 51, 1),
                                  )),
                              onPressed: _goToInscritos,
                              color: Color.fromRGBO(255, 102, 51, 1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Tuas Inscrições',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Icon(Icons.assignment,
                                      color: Colors.white, size: 25),
                                ],
                              ),
                            )),
                            SizedBox(width: 20),
                            Expanded(
                                child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Color.fromRGBO(255, 102, 51, 1),
                                  )),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DateAndTimePicker()),
                                );
                              },
                              color: Color.fromRGBO(255, 102, 51, 1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    ' Tuas Visitas  ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Icon(Icons.calendar_today,
                                      color: Colors.white, size: 25),
                                ],
                              ),
                            )),
                          ]),
                      SizedBox(height: 15),
                      FloatingActionButton.extended(
                        backgroundColor: Color.fromRGBO(255, 105, 51, 1),
                        heroTag: null,
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ShowTeamPage()),
                          ),
                        },
                        label: Text("Conhece a nossa equipa!",
                            style: TextStyle(color: Colors.white)),
                        icon: Icon(Icons.people_alt, color: Colors.white),
                      ),
                      SizedBox(height: 15),
                      FloatingActionButton.extended(
                        backgroundColor: Color.fromRGBO(255, 105, 51, 1),
                        heroTag: null,
                        onPressed: _logout,
                        label: Text("Logout",
                            style: TextStyle(color: Colors.white)),
                        icon: Icon(Icons.logout, color: Colors.white),
                      )
                    ]);
              }
            }));
  }
}
