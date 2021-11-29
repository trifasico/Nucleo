import 'package:NEEEICUM/JEE21/DiaMain.dart';
import 'package:NEEEICUM/JEE21/InformacoesMain.dart';
import 'package:NEEEICUM/JEE21/SponsorsMain.dart';
import 'package:NEEEICUM/Personal/Personal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:internet_speed_test/internet_speed_test.dart';
//import 'package:internet_speed_test/callbacks_enum.dart';
import 'Workshops/PostCard.dart';
import 'Workshops/PostPage.dart';
import 'Kits/KitCard.dart';
import 'Kits/KitPage.dart';
import 'Avisos/AvisosPage.dart';
import 'Avisos/AvisosCard.dart';
import 'Extras/Parcerias.dart';

void main() => runApp(MaterialApp(
    home: HomePage("aluno", "socio"), debugShowCheckedModeBanner: false));

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  String number = "ola";
  String socio = "ola1";
  bool cotas = false;
  @override
  HomePage(this.number, this.socio);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //var internetSpeedTest = InternetSpeedTest();
  double netSpeed = 0.2;

  String textNet = " ainda a verificar";
  int _selectedIndex = 0;
  List<Post> anuncios = [];
  int quantosPosts = 0;
  List<Kit> kits = [];
  int quantosKits = 0;
  List<Aviso> avisos = [];
  int quantosAvisos = 0;
  List<Parceria> parcerias = [];
  int quantosParcerias = 0;

  int jee21Info = 0;
  int jee21Dias = 0;
  int jee21Spon = 0;
  String diaNome = "t";

  List<Widget> _widgetOptions = <Widget>[];

  Future getValues() async {
    await FirebaseFirestore.instance
        .collection("Info")
        .doc("Posts")
        .get()
        .then((value) {
      quantosPosts = value["quantos"];
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int quantosCahced = prefs.getInt("PostsCached");

    if (quantosCahced == null) quantosCahced = 0;
    prefs.setInt("PostsCached", quantosPosts);

    for (int i = quantosPosts - 1; i >= 0; i--) {
      String text, title, hora, data, imagem;
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(i.toString())
          .get() //source: a
          .then((value) {
        text = value.data()["text"];
        title = value.data()["title"]; // + " - " + a.toString()[7];
        data = value.data()["date"];
        hora = value.data()["hour"];
        imagem = value.data()["image"];
      });
      text = text.replaceAll("|", "\n");
      anuncios.add(Post(
        text: text,
        title: title,
        hora: hora,
        data: data,
        imagem: imagem,
        number: i,
      ));
    }
    return this.quantosPosts;
  }

  Future getValuesAvisos() async {
    await FirebaseFirestore.instance
        .collection("Info")
        .doc("Avisos")
        .get()
        .then((value) {
      quantosAvisos = value["quantos"];
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int quantosAvisosCahced = prefs.getInt("AvisosCached");

    if (quantosAvisosCahced == null) quantosAvisosCahced = 0;
    prefs.setInt("AvisosCached", quantosAvisos);

    for (int i = quantosAvisos - 1; i >= 0; i--) {
      String text, title, hora, data, imagem;
      await FirebaseFirestore.instance
          .collection("Avisos")
          .doc(i.toString())
          .get() //source: a
          .then((value) {
        text = value.data()["text"];
        title = value.data()["title"]; // + " - " + a.toString()[7];
        data = value.data()["date"];
        hora = value.data()["hour"];
        imagem = value.data()["image"];
      });
      text = text.replaceAll("|", "\n");
      avisos.add(Aviso(
        text: text,
        title: title,
        hora: hora,
        data: data,
        imagem: imagem,
        number: i,
      ));
    }
    return this.quantosAvisos;
  }

  Future getValuesKits() async {
    await FirebaseFirestore.instance
        .collection("Info")
        .doc("Kits")
        .get()
        .then((value) {
      quantosKits = value["quantos"];
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int quantosKitsCached = prefs.getInt("KitsCached");
    //int quantosKitsCached = 0;

    prefs.setInt("KitsCached", quantosKits);
    //prefs.setInt("KitsCached", 0);
    if (quantosKitsCached == null) quantosKitsCached = 0;

    for (int i = quantosKits - 1; i >= 0; i--) {
      String text, title, hora, data, imagem;
      await FirebaseFirestore.instance
          .collection("Kits")
          .doc(i.toString())
          .get() //source:a
          .then((value) {
        text = value.data()["text"];
        title = value.data()["title"]; // + " - " + a.toString()[7];
        data = value.data()["date"];
        hora = value.data()["hour"];
        imagem = value.data()["image"];
      });
      text = text.replaceAll("|", "\n");
      kits.add(Kit(
        text: text,
        title: title,
        hora: hora,
        data: data,
        imagem: imagem,
        number: i,
      ));
    }
    return this.quantosKits;
  }

  Future getValuesPersonal() async {
    await FirebaseFirestore.instance
        .collection("Logins")
        .doc(this.widget.number)
        .get()
        .then((value) {
      this.widget.cotas = value["cotas"];
      this.widget.socio = value["socio"];
    });
  }

  Future getValuesParcerias() async {
    parcerias.clear();
    await FirebaseFirestore.instance
        .collection("Info")
        .doc("Parcerias")
        .get()
        .then((value) {
      quantosParcerias = value["quantos"];
    });
    for (int i = 0; i < quantosParcerias; i++) {
      String text, title, icon, imagem;
      await FirebaseFirestore.instance
          .collection("Parcerias")
          .doc(i.toString())
          .get() //source:a
          .then((value) {
        title = value.data()["title"]; // + " - " + a.toString()[7];
        text = value.data()["text"];
        icon = value.data()["icon"];
        imagem = value.data()["imagem"];
      });
      text = text.replaceAll("|", "\n");
      parcerias.add(Parceria(
        text: text,
        title: title,
        icon: icon,
        imagem: imagem,
        //number: i,
      ));
    }
  }

  Future getValuesJEE21() async {
    await FirebaseFirestore.instance
        .collection("JEE21")
        .doc("Info")
        .get()
        .then((value) {
      jee21Info = value["infos"];
      jee21Dias = value["dia"];
      jee21Spon = value["sponsors"];
    });

    await FirebaseFirestore.instance
        .collection("JEE21")
        .doc("Info")
        .get()
        .then((value) {
      diaNome = value["dia" + jee21Dias.toString() + "Name"];
    });
    // for (int i = 0; i < quantosParcerias; i++) {
    //   String text, title, icon, imagem;
    //   await FirebaseFirestore.instance
    //       .collection("Parcerias")
    //       .doc(i.toString())
    //       .get() //source:a
    //       .then((value) {
    //     title = value.data()["title"]; // + " - " + a.toString()[7];
    //     text = value.data()["text"];
    //     icon = value.data()["icon"];
    //     imagem = value.data()["imagem"];
    //   });
    //   text = text.replaceAll("|", "\n");
    //   parcerias.add(Parceria(
    //     text: text,
    //     title: title,
    //     icon: icon,
    //     imagem: imagem,
    //     //number: i,
    //   ));
    // }
  }

  void buildBottomNavigationBar() {
    _widgetOptions.add(FutureBuilder(
        future: getValuesAvisos(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return (quantosAvisos != 0)
                ? ListView.builder(
                    itemCount: this.avisos.length, //anuncios.length,
                    itemBuilder: (context, index) {
                      var post = this.avisos[index];
                      return AvisoCard(
                          aviso: post,
                          more: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AvisoPage(post),
                                  ));
                            });
                          });
                    })
                : Center(child: Text("Ainda não existem Avisos"));
          }
        }));

    _widgetOptions.add(FutureBuilder(
        future: getValues(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return (quantosPosts != 0)
                ? ListView.builder(
                    itemCount: this.anuncios.length, //anuncios.length,
                    itemBuilder: (context, index) {
                      var post = this.anuncios[index];
                      return PostCard(
                          anuncio: post,
                          more: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PostPage(post),
                                  ));
                            });
                          });
                    })
                : Center(child: Text("Ainda não existem Workshops"));
          }
        }));

    _widgetOptions.add(FutureBuilder(
        future: getValuesKits(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return (quantosKits != 0)
                ? ListView.builder(
                    itemCount: this.kits.length, //anuncios.length,
                    itemBuilder: (context, index) {
                      var kit = this.kits[index];
                      return KitCard(
                          kit: kit,
                          more: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        KitPage(kit),
                                  ));
                            });
                          });
                    })
                : Center(child: Text("Ainda não existem kits"));
          }
        }));

    _widgetOptions.add(FutureBuilder(
        future: getValuesParcerias(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
                padding: EdgeInsets.all(5),
                child: new StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: parcerias.length,
                  itemBuilder: (BuildContext context, int index) => new Padding(
                      padding: EdgeInsets.all(5),
                      child: FlatButton(
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Parcerias(parcerias[index]),
                                  ));
                            });
                          },
                          padding: EdgeInsets.all(5),
                          child: Container(
                              color: Color.fromRGBO(255, 102, 51, 0),
                              child: new Center(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.all(2),
                                        child: (parcerias[index].icon != "a")
                                            ? Image.network(
                                                parcerias[index].icon,
                                                height: 100,
                                              )
                                            : SizedBox())
                                  ]))))),
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(2, index.isEven ? 2.01 : 2.01),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ));
          }
        }));

    _widgetOptions.add(FutureBuilder(
        future: getValuesJEE21(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
                child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(height: 1),
                  ),
                  Expanded(
                    child: Image.asset(
                      "assets/images/JEE21.png",
                    ),
                  ),
                  Expanded(
                    child: SizedBox(height: 1),
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color.fromRGBO(
                                      148, 212, 72, 1), //148, 212, 72, 1),
                                )),
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          InformacoesMain(),
                                    ));
                              });
                            },
                            color: Color.fromRGBO(
                                148, 212, 72, 1), //148, 212, 72, 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '   Informações  ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                                Icon(Icons.info, color: Colors.white, size: 25),
                              ],
                            ),
                          ))),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color.fromRGBO(
                                      148, 212, 72, 1), //148, 212, 72, 1),
                                )),
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DiaMain(diaNome),
                                    ));
                              });
                            },
                            color: Color.fromRGBO(
                                148, 212, 72, 1), //148, 212, 72, 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '       Agenda     ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                                Icon(Icons.calendar_today,
                                    color: Colors.white, size: 25),
                              ],
                            ),
                          ))),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color.fromRGBO(
                                      148, 212, 72, 1), //148, 212, 72, 1),
                                )),
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Sponsors(),
                                    ));
                              });
                            },
                            color: Color.fromRGBO(
                                148, 212, 72, 1), //148, 212, 72, 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '    Sponsors   ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                                Icon(Icons.supervisor_account_rounded,
                                    color: Colors.white, size: 25),
                              ],
                            ),
                          ))),
                ],
              ),
            ));
          }
        }));
    _widgetOptions.add(Center(child: Text("Ocorreu alguma asneira aqui")));
  }

  Future getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("number");
  }

  @override
  void initState() {
    super.initState();
    buildBottomNavigationBar();

    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //if (_selectedIndex == 4) rebuildAllChildren(context);
    });
  }

  Future _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("PostsCached", 0);
    prefs.setInt("KitsCached", 0);
    prefs.setInt("AvisosCached", 0);
    anuncios.clear();
    kits.clear();
    avisos.clear();
    //await getValues();
    //await getValuesKits();
    _widgetOptions.clear();
    buildBottomNavigationBar();
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

  showAlertDialog(BuildContext context, bool xx) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: xx ? Text("Informações de Net") : Text("Problemas de Net"),
      content: xx
          ? Text("Velocidade da net $textNet")
          : Text(
              "A net a ser usada não é muito boa\nA app pode ser mais lenta devido a isso\n\nVelocidade: $textNet \nA velocidade > 0.1 Mbps"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
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
      backgroundColor: Colors.white,
      //backgroundColor: Color(121212),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: (_selectedIndex == 4)
              ? Color.fromRGBO(148, 212, 72, 1)
              : Color.fromRGBO(255, 102, 51, 1),
          title: Row(children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: (_selectedIndex == 4)
                      ? Color.fromRGBO(148, 212, 72, 1)
                      : Color.fromRGBO(255, 102, 51, 1),
                ),
                onPressed: (() {})), //_getData),
            Expanded(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  onPressed: () => {}, //showAlertDialog(context, true)},
                  padding: EdgeInsets.all(0.1),
                  child: Row(
                    children: [
                      // Text(
                      //   'NEEEICUM ', // + textNet,
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      Image.asset(
                        "assets/images/Icon.png",
                        //fit: BoxFit.cover,
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            )),
            IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PersonalArea(this.widget.number, this.widget.socio)),
                );
              },
            ), //_getData),
          ])),
      body: RefreshIndicator(
          child: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          onRefresh: _getData),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        //backgroundColor: Color(121212),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        iconSize: 23,
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.warning,
              //color: Colors.grey,
            ),
            // ignore: deprecated_member_use
            title: Text("Avisos",
                style: TextStyle(
                    //  color: Colors.grey,
                    )),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event_note,
              //color: Colors.grey,
            ),
            // ignore: deprecated_member_use
            title: Text("WorkShops",
                style: TextStyle(
                    //  color: Colors.grey,
                    )),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shop_two_rounded,
              //color: Colors.grey,
            ),
            // ignore: deprecated_member_use
            title: Text("Kits",
                style: TextStyle(
                    //  color: Colors.grey,
                    )),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people_alt_outlined,
              //color: Colors.grey,
            ),
            // ignore: deprecated_member_use
            title: Text("Sponsors",
                style: TextStyle(
                    //color: Colors.grey,
                    )),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.lightbulb,
              //color: Colors.grey,
            ),
            // ignore: deprecated_member_use
            title: Text("Jornadas",
                style: TextStyle(
                    //color: Colors.grey,
                    )),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: (_selectedIndex == 4)
            ? Color.fromRGBO(148, 212, 72, 1)
            : Color.fromRGBO(255, 102, 51, 1),
        selectedIconTheme: IconThemeData(
          color: (_selectedIndex == 4)
              ? Color.fromRGBO(148, 212, 72, 1)
              : Color.fromRGBO(255, 102, 51, 1),
        ),
        onTap: _onItemTapped,
      ),
    );
  }
}
