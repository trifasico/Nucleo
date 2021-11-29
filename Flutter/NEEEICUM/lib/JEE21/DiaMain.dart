import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DiaIndividual.dart';

class Dia {
  String title;
  String imagem;
  String icon;
  String text;
  String hora;
  String id;

  Dia({this.title, this.imagem, this.icon, this.text, this.hora, this.id});
}

class DiaMain extends StatefulWidget {
  final String diaNome;

  DiaMain(this.diaNome);

  @override
  _DiaMainState createState() => _DiaMainState();
}

class _DiaMainState extends State<DiaMain> {
  List<Widget> _widgetOptions = <Widget>[];
  List<Dia> dias = <Dia>[];
  int jee21Dia = 0;
  int jee21DiaAtivo = 0;

  void _goToInfo(int index) {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DiaIndividual(dias.elementAt(index), jee21DiaAtivo)));
    });
  }

  Future<dynamic> _test() async {
    await FirebaseFirestore.instance
        .collection("JEE21")
        .doc("Info")
        .get()
        .then((value) {
      jee21DiaAtivo = value["dia"];
    });

    await FirebaseFirestore.instance
        .collection("JEE21")
        .doc("Info")
        .get()
        .then((value) {
      print("dia" + jee21DiaAtivo.toString());
      jee21Dia = value["dia" + jee21DiaAtivo.toString()];
      print(jee21Dia.toString());
    });

    for (int i = 0; i < jee21Dia; i++) {
      String text, title, icon, imagem, hora;
      await FirebaseFirestore.instance
          .collection("JEE21")
          .doc("Dados")
          .collection((jee21DiaAtivo).toString())
          .doc(i.toString())
          .get()
          .then((value) {
        title = value.data()["title"];
        text = value.data()["text"];
        icon = value.data()["icon"];
        imagem = value.data()["imagem"];
        hora = value.data()["horas"];
      });
      text = text.replaceAll("|", "\n");
      dias.add(Dia(
        text: text,
        title: title,
        icon: icon,
        imagem: imagem,
        hora: hora,
        id: i.toString(),
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
            return (jee21Dia != 0)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        //  Row(children: [
                        //     Expanded(
                        //         child: Padding(
                        //             padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        //             child: Card(
                        //                 elevation: 0.6,
                        //                 child: Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.center,
                        //                     children: [
                        //                       Padding(
                        //                           padding: EdgeInsets.fromLTRB(
                        //                               10, 10, 10, 0),
                        //                           child: Text(
                        //                               "Dia " +
                        //                                   (jee21DiaAtivo + 1)
                        //                                       .toString(),
                        //                               style: TextStyle(
                        //                                 fontSize: 20,
                        //                                 fontWeight: FontWeight.bold,
                        //                               ))),
                        //                       Padding(
                        //                           padding: EdgeInsets.fromLTRB(
                        //                               10, 10, 10, 0),
                        //                           child: Text(diaNome,
                        //                               style: TextStyle(
                        //                                 fontSize: 20,
                        //                                 fontWeight: FontWeight.bold,
                        //                               ))),
                        //                     ]))))
                        //   ]),
                        Expanded(
                            child: ListView.builder(
                                itemCount: jee21Dia, //anuncios.length,
                                itemBuilder: (context, index) {
                                  return FlatButton(
                                      onPressed: () => _goToInfo(index),
                                      child: Card(
                                          elevation: 0.8,
                                          child: Row(children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 15, 10, 15),
                                              child: Text(
                                                  dias.elementAt(index).hora,
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ),
                                            Expanded(
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 15, 10, 15),
                                                    child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                        color: Color.fromRGBO(
                                                            148, 212, 72, 1),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(10, 15,
                                                                  10, 15),
                                                          child: Text(
                                                            dias
                                                                .elementAt(
                                                                    index)
                                                                .title,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ))))
                                          ])));
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
            this.widget.diaNome,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          backgroundColor: Color.fromRGBO(148, 212, 72, 1),
        ),
        body: _widgetOptions.elementAt(0));
  }
}
