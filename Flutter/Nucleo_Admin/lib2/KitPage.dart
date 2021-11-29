import 'package:flutter/material.dart';
import 'KitCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KitPage extends StatefulWidget {
  final Kit kit;

  KitPage(this.kit);

  @override
  _KitPageState createState() => _KitPageState();
}

class _KitPageState extends State<KitPage> {
  List<dynamic> quemvai = [];
  List<dynamic> entrou = [];
  List<dynamic> pagou = [];

  Future getInfo() async {
    await Firestore.instance
        .collection("Kits")
        .document(this.widget.kit.number.toString())
        .get()
        .then((value) {
      quemvai = value.data["quemquer"];
      entrou = value.data["levou"];
      pagou = value.data["pagou"];
    });
    if (quemvai == null) {
      quemvai = [];
    }
    if (entrou == null) {
      entrou = [];
    }
    if (pagou == null) {
      pagou = [];
    }
    quemvai.insert(0, "Quer : " + quemvai.length.toString());
    entrou.insert(0, "Levou : " + entrou.length.toString());
    pagou.insert(0, "Pagou : " + entrou.length.toString());
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
          this.widget.kit.title,
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
                          this.widget.kit.imagem,
                        )))),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child:
                    Text(this.widget.kit.text, style: TextStyle(fontSize: 15))),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Container(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: quemvai.length,
                      shrinkWrap: true,
                      itemBuilder: (_, i) => ListTile(title: Text(quemvai[i])),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: pagou.length,
                      shrinkWrap: true,
                      itemBuilder: (_, i) => ListTile(title: Text(pagou[i])),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
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
