import 'package:flutter/material.dart';
import 'AvisosCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvisoPage extends StatefulWidget {
  final Aviso aviso;

  AvisoPage(this.aviso);

  @override
  _AvisoPageState createState() => _AvisoPageState();
}

class _AvisoPageState extends State<AvisoPage> {
  List<dynamic> quemvai = [];
  List<dynamic> entrou = [];

  Future getInfo() async {
    await Firestore.instance
        .collection("Avisos")
        .document(this.widget.aviso.number.toString())
        .get()
        .then((value) {
      quemvai = value.data["quemquer"];
      entrou = value.data["levou"];
    });
    if (quemvai == null) {
      quemvai = [];
    }
    if (entrou == null) {
      entrou = [];
    }
    quemvai.insert(0, "Quem Quer : " + quemvai.length.toString());
    entrou.insert(0, "Quem levou : " + entrou.length.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          this.widget.aviso.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: Column(children: <Widget>[
        Expanded(
            child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Image.network(
                          this.widget.aviso.imagem,
                        )))),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Text(this.widget.aviso.text,
                    style: TextStyle(fontSize: 15))),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    child: ListView.builder(
                      itemCount: quemvai.length,
                      shrinkWrap: true,
                      itemBuilder: (_, i) => ListTile(title: Text(quemvai[i])),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    child: ListView.builder(
                      itemCount: entrou.length,
                      shrinkWrap: true,
                      itemBuilder: (_, i) => ListTile(title: Text(entrou[i])),
                    ),
                  ),
                ),
              ],
            )
          ],
        )),
      ]),
    );
  }
}
