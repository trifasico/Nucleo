import 'package:NEEEICUM/JEE21/InfoIndividual.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Informacoes {
  String title;
  String imagem;
  String icon;
  String text;
  String url;

  Informacoes({this.title, this.imagem, this.icon, this.text, this.url});
}

class InformacoesMain extends StatefulWidget {
  @override
  _InformacoesMainState createState() => _InformacoesMainState();
}

class _InformacoesMainState extends State<InformacoesMain> {
  List<Widget> _widgetOptions = <Widget>[];
  List<Informacoes> infos = <Informacoes>[];
  int jee21Info = 0;

  void _goToInfo(int index) {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  InfoIndividual(infos.elementAt(index))));
    });
  }

  Future<dynamic> _test() async {
    await FirebaseFirestore.instance
        .collection("JEE21")
        .doc("Info")
        .get()
        .then((value) {
      jee21Info = value["infos"];
    });
    for (int i = 0; i < jee21Info; i++) {
      String text, title, icon, imagem, url;
      await FirebaseFirestore.instance
          .collection("JEE21")
          .doc("Dados")
          .collection("Informacoes")
          .doc(i.toString())
          .get()
          .then((value) {
        title = value.data()["title"];
        text = value.data()["text"];
        icon = value.data()["icon"];
        imagem = value.data()["imagem"];
        url = value.data()["urlvideo"];
      });
      text = text.replaceAll("|", "\n");
      infos.add(Informacoes(
        text: text,
        title: title,
        icon: icon,
        imagem: imagem,
        url: url,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    buildBottomNavigationBar();
    setState(() {});
  }

  Future buildBottomNavigationBar() async {
    _widgetOptions.clear();
    _widgetOptions.add(FutureBuilder(
        future: _test(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return (jee21Info != 0)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        /*Padding(
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Image.asset("assets/images/JEE21.png"),
                        ),*/
                        Expanded(
                            child: ListView.builder(
                                itemCount: jee21Info, //anuncios.length,
                                itemBuilder: (context, index) {
                                  return FlatButton(
                                    onPressed: () => _goToInfo(index),
                                    child: Card(
                                      elevation: 2,
                                      color: Colors.grey[10],
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text(
                                              infos.elementAt(index).title,
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Row(children: <Widget>[
                                              SizedBox(height: 10),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      15, 10, 15, 10),
                                                  child: Text(
                                                    infos.elementAt(index).text,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Colors.grey[800]),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            5, 10, 5, 10),
                                                    child: (infos
                                                                .elementAt(
                                                                    index)
                                                                .imagem !=
                                                            "a")
                                                        ? Image.network(infos
                                                            .elementAt(index)
                                                            .imagem)
                                                        : SizedBox()),
                                              ),
                                            ]),
                                            SizedBox(height: 8),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //onPressed: more,
                                  );
                                })),
                      ])
                : Center(
                    child: Card(
                        elevation: 0,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Brevemente Disponível...",
                                style: TextStyle(fontSize: 20)))),
                  );
          }
        }));
    setState(() {
      rebuildAllChildren(context);
    });
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Informações",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Color.fromRGBO(148, 212, 72, 1),
      ),
      body: _widgetOptions.elementAt(0),
    );
  }
}
