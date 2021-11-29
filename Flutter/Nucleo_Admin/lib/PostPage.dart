import 'package:flutter/material.dart';
import 'PostCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostPage extends StatefulWidget {
  final Post post;

  PostPage(this.post);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<dynamic> quemvai = [];
  List<dynamic> entrou = [];
  int quantosComments = 0;
  bool inscrito = false;

  Future getInfo() async {
    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(this.widget.post.number.toString())
        .get()
        .then((value) {
      quemvai = value.data()["quemvai"];
      entrou = value.data()["entrou"];
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
          this.widget.post.title,
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
                          this.widget.post.imagem,
                        )))),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Text(this.widget.post.text,
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
