import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../Extras/TextInputWidget.dart';
import 'AvisosCard.dart';
import '../Extras/coments.dart';

class AvisoPage extends StatefulWidget {
  final Aviso kit;

  AvisoPage(this.kit);

  @override
  _AvisoPageState createState() => _AvisoPageState();
}

class _AvisoPageState extends State<AvisoPage> {
  List<Coments> comments = [];
  List<dynamic> quemvai = [];
  List<dynamic> entrou = [];
  int quantosComments = 0;
  bool inscrito = false;

  Future getInfo() async {
    await FirebaseFirestore.instance
        .collection("Avisos")
        .doc(this.widget.kit.number.toString())
        .get()
        .then((value) {
      quantosComments = value.data()["comments"];
      quemvai = value.data()["quemquer"];
      entrou = value.data()["levou"];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString('number');

    for (int i = 0; i < quantosComments; i++) {
      String text, author;
      List<dynamic> likesP = [];
      int likes;
      await FirebaseFirestore.instance
          .collection("Avisos")
          .doc(this.widget.kit.number.toString())
          .collection("Comments")
          .doc(i.toString())
          .get()
          .then((value) {
        likes = value.data()["likes"];
        text = value.data()["text"];
        author = value.data()["author"];
        likesP = value.data()["quemgostou"];
      });
      if (likesP == null) {
        likesP = [];
        await FirebaseFirestore.instance
            .collection("Avisos")
            .doc(this.widget.kit.number.toString())
            .collection("Comments")
            .doc(i.toString())
            .update({"quemgostou": []});
      }
      comments.add(Coments(
        text,
        author,
        likes,
        i,
        this.widget.kit.number,
        "Avisos",
        likesP.contains(number),
      ));
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

/*Future _going() async {
    await getInfo();
    setState(() {
      rebuildAllChildren(context);
    });
  }*/

  void newComment(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String name = prefs.getString('name');
    await FirebaseFirestore.instance
        .collection("Avisos")
        .doc(this.widget.kit.number.toString())
        .update({"comments": quantosComments + 1});
    await FirebaseFirestore.instance
        .collection("Avisos")
        .doc(this.widget.kit.number.toString())
        .collection("Comments")
        .doc(quantosComments.toString())
        .set({"author": name, "text": text, "likes": 0, "quemgostou": []});

    comments.add(new Coments(text, name, 0, quantosComments,
        this.widget.kit.number, "Avisos", false));

    quantosComments += 1;

    this.setState(() {});
  }
/*
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
        prefs.setInt("Quer_" + this.widget.kit.number.toString(), 1);
        quemvai.add(number);
        await Firestore.instance
            .collection("Kits")
            .document(this.widget.kit.number.toString())
            .updateData({"quemquer": quemvai});
        List<dynamic> kitsQUER = [];
        await Firestore.instance
            .collection("Logins")
            .document(number)
            .get()
            .then((value) => kitsQUER = value.data["Kits"]);
        if (kitsQUER == null) kitsQUER = [];
        kitsQUER.add(this.widget.kit.number);
        await Firestore.instance
            .collection("Logins")
            .document(number)
            .updateData({"Kits": kitsQUER});
        _going();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Confirmação"),
      content: Text("Tens a certeza que queres este kit?"),
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 102, 51, 1),
        centerTitle: true,
        title: Text(
          this.widget.kit.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
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
                        child: (this.widget.kit.imagem != "a")
                            ? Image.network(
                                this.widget.kit.imagem,
                                width: (kIsWeb) ? 500 : 200,
                              )
                            : SizedBox()))),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, (kIsWeb) ? 20 : 5),
                child:
                    Text(this.widget.kit.text, style: TextStyle(fontSize: 15))),
            /*Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                                inscrito
                                    ? "Já adquiriste este kit"
                                    : "Queres este kit ?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                )),
                            inscrito
                                ? Text(" ")
                                : IconButton(
                                    icon: Icon(Icons.check,
                                        size: inscrito ? 0 : 25,
                                        color: inscrito
                                            ? Colors.white
                                            : Colors.black),
                                    onPressed: () {
                                      if (!inscrito) showAlertDialog(context);
                                    },
                                  ),
                          ]))),
            ),*/
            ComentsList(this.comments),
          ],
        )),
        TextInputWidget(this.newComment),
      ]),
    );
  }
}
