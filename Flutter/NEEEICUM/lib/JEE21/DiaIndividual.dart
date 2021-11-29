import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'DiaMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DiaIndividual extends StatefulWidget {
  final Dia dia;
  final int diaAtivo;

  DiaIndividual(this.dia, this.diaAtivo);

  @override
  _DiaIndividualState createState() => _DiaIndividualState();
}

class _DiaIndividualState extends State<DiaIndividual> {
  List<dynamic> quemvai = [];
  List<dynamic> entrou = [];
  int quantosComments = 0;
  bool inscrito = false;
  bool fechou = false;
  bool tipo = false;
  String url = "";

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  Future getInfo() async {
    await FirebaseFirestore.instance
        .collection("JEE21")
        .doc("Dados")
        .collection(this.widget.diaAtivo.toString())
        .doc(this.widget.dia.id.toString())
        .get()
        .then((value) {
      quemvai = value.data()["quemvai"];
      entrou = value.data()["entrou"];
      fechou = value.data()["fechou"];
      if (value.data().containsKey("tipo")) {
        this.tipo = value.data()["tipo"];
        this.url = value.data()["url"];
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString('number');
    if (quemvai.contains(number) == true || entrou.contains(number)) {
      prefs.setInt("Vai_" + this.widget.dia.id, 1);
      inscrito = true;
    }

    setState(() {});
  }

  Future _going() async {
    await getInfo();
    setState(() {
      rebuildAllChildren(context);
    });
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () async {
        Navigator.of(context).pop();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String number = prefs.getString('number');
        //prefs.setInt("Vai_" + this.widget.post.number.toString(), 1);

        quemvai.add(number);
        await FirebaseFirestore.instance
            .collection("JEE21")
            .doc("Dados")
            .collection(this.widget.diaAtivo.toString())
            .doc(this.widget.dia.id.toString())
            .update({"quemvai": quemvai});

        List<dynamic> postsQUER = [];
        await FirebaseFirestore.instance
            .collection("Logins")
            .doc(number)
            .get()
            .then((value) =>
                postsQUER = value.data()["JEE21_${this.widget.diaAtivo}"]);
        if (postsQUER == null) postsQUER = [];
        postsQUER.add(this.widget.dia.id);
        await FirebaseFirestore.instance
            .collection("Logins")
            .doc(number)
            .update({"JEE21_${this.widget.diaAtivo}": postsQUER});
        _going();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Confirmação"),
      content: Text("Tens a certeza que queres ir a palestra?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          this.widget.dia.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Color.fromRGBO(148, 212, 72, 1),
      ),
      body: Column(children: <Widget>[
        SizedBox(height: 10),
        Expanded(
            child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: (this.widget.dia.imagem != "a")
                            ? Image.network(
                                this.widget.dia.imagem,
                                height: 300,
                              )
                            : SizedBox()))),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Text(this.widget.dia.text,
                    style: TextStyle(fontSize: 15, color: Colors.black))),
            Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          !fechou
                              ? (tipo)
                                  ? FloatingActionButton.extended(
                                      backgroundColor:
                                          Color.fromRGBO(148, 212, 72, 1),
                                      label: Text(
                                          "Confirma aqui a tua participação",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          )),
                                      icon: Icon(Icons.check,
                                          size: inscrito ? 0 : 25,
                                          color: Colors.white),
                                      onPressed: () {
                                        _launchInBrowser(this.url);
                                      },
                                    )
                                  : FloatingActionButton.extended(
                                      backgroundColor:
                                          Color.fromRGBO(148, 212, 72, 1),
                                      label: Text(
                                          inscrito
                                              ? "Já te encontras inscrito"
                                              : "Confirma aqui a tua participação",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          )),
                                      icon: Icon(Icons.check,
                                          size: inscrito ? 0 : 25,
                                          color: Colors.white),
                                      onPressed: () {
                                        if (!inscrito) showAlertDialog(context);
                                      },
                                    )
                              : FloatingActionButton.extended(
                                  backgroundColor:
                                      Color.fromRGBO(148, 212, 72, 1),
                                  label: Text("Inscrições fechadas",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      )),
                                  onPressed: () {},
                                ),
                        ]))),
          ],
        )),
      ]),
    );
  }
}
