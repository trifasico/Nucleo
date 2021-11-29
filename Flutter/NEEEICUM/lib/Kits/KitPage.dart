import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'KitItemsPicker.dart';
import '../Extras/TextInputWidget.dart';
import 'KitCard.dart';
import '../Extras/coments.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class KitPage extends StatefulWidget {
  final Kit kit;

  KitPage(this.kit);

  @override
  _KitPageState createState() => _KitPageState();
}

class _KitPageState extends State<KitPage> {
  List<Coments> comments = [];
  List<dynamic> quemvai = [];
  List<dynamic> entrou = [];
  List<dynamic> pagou = [];
  int quantosComments = 0;
  bool inscrito = false;
  bool fechou = false;

  Future getInfo() async {
    await FirebaseFirestore.instance
        .collection("Kits")
        .doc(this.widget.kit.number.toString())
        .get()
        .then((value) {
      quantosComments = value.data()["comments"];
      quemvai = value.data()["quemquer"];
      entrou = value.data()["levou"];
      pagou = value.data()["pagou"];
      fechou = value.data()["fechou"];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString('number');
    if (quemvai.contains(number) == true ||
        entrou.contains(number) ||
        pagou.contains(number)) {
      prefs.setInt("Quer_" + this.widget.kit.number.toString(), 1);
      inscrito = true;
    }

    for (int i = 0; i < quantosComments; i++) {
      String text, author;
      List<dynamic> likesP = [];
      int likes;
      await FirebaseFirestore.instance
          .collection("Kits")
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
            .collection("Kits")
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
        "Kits",
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

  // ignore: unused_element
  Future _going() async {
    await getInfo();
    setState(() {
      rebuildAllChildren(context);
    });
  }

  void newComment(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String name = prefs.getString('name');
    await FirebaseFirestore.instance
        .collection("Kits")
        .doc(this.widget.kit.number.toString())
        .update({"comments": quantosComments + 1});
    await FirebaseFirestore.instance
        .collection("Kits")
        .doc(this.widget.kit.number.toString())
        .collection("Comments")
        .doc(quantosComments.toString())
        .set({"author": name, "text": text, "likes": 0, "quemgostou": []});

    comments.add(new Coments(
        text, name, 0, quantosComments, this.widget.kit.number, "Kits", false));

    quantosComments += 1;

    this.setState(() {});
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
      onPressed: () async {},
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
  }

  void _kitItems() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                KitItemsPicker(this.widget.kit)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          this.widget.kit.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Color.fromRGBO(255, 102, 51, 1),
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
                                //height: (kIsWeb) ? 500 : 350,
                              )
                            : SizedBox()))),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, (kIsWeb) ? 20 : 5),
                child:
                    Text(this.widget.kit.text, style: TextStyle(fontSize: 15))),
            Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          !fechou
                              ? FloatingActionButton.extended(
                                  backgroundColor:
                                      Color.fromRGBO(255, 102, 51, 1),
                                  label: Text(
                                      inscrito
                                          ? "Já pediste este Kit"
                                          : "Queres este Kit?",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      )),
                                  icon: Icon(Icons.check,
                                      size: inscrito ? 0 : 25,
                                      color: inscrito
                                          ? Colors.black
                                          : Colors.white),
                                  onPressed: () {
                                    if (!inscrito) _kitItems();
                                  },
                                )
                              : FloatingActionButton.extended(
                                  backgroundColor:
                                      Color.fromRGBO(255, 102, 51, 1),
                                  label: Text("Inscrições fechadas",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      )),
                                  onPressed: () {},
                                ),
                        ]))),
            ComentsList(this.comments),
          ],
        )),
        TextInputWidget(this.newComment),
      ]),
    );
  }
}
