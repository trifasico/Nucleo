import 'dart:async';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'KitCard.dart';
import 'PostCard.dart';
import 'KitPage.dart';
import 'PostPage.dart';
import 'AvisosPage.dart';
import 'AvisosCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:achievement_view/achievement_view.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  TextEditingController controller = new TextEditingController();
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  TextEditingController controller5 = new TextEditingController();
  TextEditingController controller6 = new TextEditingController();
  TextEditingController controller7 = new TextEditingController();
  TextEditingController controller8 = new TextEditingController();
  TextEditingController controller9 = new TextEditingController();
  TextEditingController controller10 = new TextEditingController();
  TextEditingController controller11 = new TextEditingController();
  TextEditingController controller12 = new TextEditingController();
  TextEditingController controller13 = new TextEditingController();
  TextEditingController controller14 = new TextEditingController();
  TextEditingController controller15 = new TextEditingController();
  TextEditingController controller16 = new TextEditingController();
  TextEditingController controller17 = new TextEditingController();
  TextEditingController controller18 = new TextEditingController();
  TextEditingController controller19 = new TextEditingController();
  TextEditingController controller20 = new TextEditingController();
  TextEditingController controller21 = new TextEditingController();
  TextEditingController controller22 = new TextEditingController();
  TextEditingController controller23 = new TextEditingController();
  TextEditingController controller24 = new TextEditingController();
  TextEditingController controller25 = new TextEditingController();
  TextEditingController controller26 = new TextEditingController();
  TextEditingController controller27 = new TextEditingController();
  TextEditingController controller28 = new TextEditingController();
  TextEditingController controllerSocio = new TextEditingController();
  String title;
  String text;
  String date;
  String hour;
  String image;
  String textKitsEntrega = "";

  DateTime selectedDate = DateTime.now();

  List<dynamic> visitas = [];

  String textinho = " ";
  int isSelectedIndex = 0;
  List<bool> isSelected = [false, true, false];
  List<String> select = ["Avisos", "Posts", "Kits", "error"];
  List<String> quem = ["quemviu", "quemvai", "quemquer", "error"];
  List<String> entra = ["viu", "entrou", "levou", "error"];
  String _textDia = " ";

  int _selectedIndex = 0;
  bool cotas = false;
  String result = "Faz Scan";
  String nome = "Nome", telemovel = "telemovel", mail = "mail", socio = "Socio";
  List<Widget> _widgetOptions = <Widget>[];
  List<Post> anuncios = [];
  int quantosPosts = 0;
  List<Kit> kits = [];
  int quantosKits = 0;
  List<Aviso> avisos = [];
  int quantosAvisos = 0;
  bool falta = true;

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  void click() async {
    this.title = controller.text;
    this.text = controller1.text;
    this.image = controller2.text;
    this.date = controller3.text;
    this.hour = controller4.text;

    if (this.title.length <= 0 ||
        this.text.length <= 0 ||
        this.image.length <= 0 ||
        this.date.length <= 0 ||
        this.hour.length <= 0) {
      textinho = "Ups... Deixou algum dos campos vazio";
      setState(() {
        _widgetOptions.removeLast();
        buildCreate();
      });
    } else {
      int quantos = 0;
      //var items = {};
      //List<dynamic> itemsQ = [];
      await FirebaseFirestore.instance
          .collection("Info")
          .doc(select[isSelectedIndex])
          .get()
          .then((value) => {
                quantos = value.data()["quantos"],
              });
      if (quantos == 0) {
        var items = {};
        List<dynamic> itemsQ = [];
        if (controller5.text != "" &&
            controller6.text != "" &&
            controller21.text != "") {
          itemsQ.add(0);
          items["0"] = [controller5.text, controller6.text, controller21.text];
        }
        if (controller7.text != "" &&
            controller8.text != "" &&
            controller22.text != "") {
          itemsQ.add(0);
          items["1"] = [controller7.text, controller8.text, controller22.text];
        }
        if (controller9.text != "" &&
            controller10.text != "" &&
            controller23.text != "") {
          itemsQ.add(0);
          items["2"] = [controller9.text, controller10.text, controller23.text];
        }
        if (controller11.text != "" &&
            controller12.text != "" &&
            controller24.text != "") {
          itemsQ.add(0);
          items["3"] = [
            controller11.text,
            controller12.text,
            controller24.text
          ];
        }
        if (controller13.text != "" &&
            controller14.text != "" &&
            controller25.text != "") {
          itemsQ.add(0);
          items["4"] = [
            controller13.text,
            controller14.text,
            controller25.text
          ];
        }
        if (controller15.text != "" &&
            controller16.text != "" &&
            controller26.text != "") {
          itemsQ.add(0);
          items["5"] = [
            controller15.text,
            controller16.text,
            controller26.text
          ];
        }
        if (controller17.text != "" &&
            controller18.text != "" &&
            controller27.text != "") {
          itemsQ.add(0);
          items["6"] = [
            controller17.text,
            controller18.text,
            controller27.text
          ];
        }
        if (controller19.text != "" &&
            controller20.text != "" &&
            controller28.text != "") {
          itemsQ.add(0);
          items["7"] = [
            controller19.text,
            controller20.text,
            controller28.text
          ];
        }
        if (select[isSelectedIndex] == "Kits") {
          await FirebaseFirestore.instance
              .collection(select[isSelectedIndex])
              .doc(quantos.toString())
              .set({
            "comments": 0,
            quem[isSelectedIndex]: [],
            entra[isSelectedIndex]: [],
            "fechou": false,
            "items": items,
            "itemsQ": itemsQ,
            "title": this.title,
            "text": this.text,
            "date": this.date,
            "hour": this.hour,
            "image": this.image,
          });
        } else if (select[isSelectedIndex] == "Posts") {
          await FirebaseFirestore.instance
              .collection(select[isSelectedIndex])
              .doc(quantos.toString())
              .set({
            "comments": 0,
            quem[isSelectedIndex]: [],
            entra[isSelectedIndex]: [],
            "fechou": false,
            "title": this.title,
            "text": this.text,
            "date": this.date,
            "hour": this.hour,
            "image": this.image,
          });
        } else {
          await FirebaseFirestore.instance
              .collection(select[isSelectedIndex])
              .doc(quantos.toString())
              .set({
            "comments": 0,
            "fechou": false,
            "title": this.title,
            "text": this.text,
            "date": this.date,
            "hour": this.hour,
            "image": this.image,
          });
        }
        await FirebaseFirestore.instance
            .collection("Info")
            .doc(select[isSelectedIndex])
            .update({"quantos": quantos + 1});
      } else {
        var items = {};
        List<dynamic> itemsQ = [];
        if (controller5.text != "" &&
            controller6.text != "" &&
            controller21.text != "") {
          itemsQ.add(0);
          items["0"] = [controller5.text, controller6.text, controller21.text];
        }
        if (controller7.text != "" &&
            controller8.text != "" &&
            controller22.text != "") {
          itemsQ.add(0);
          items["1"] = [controller7.text, controller8.text, controller22.text];
        }
        if (controller9.text != "" &&
            controller10.text != "" &&
            controller23.text != "") {
          itemsQ.add(0);
          items["2"] = [controller9.text, controller10.text, controller23.text];
        }
        if (controller11.text != "" &&
            controller12.text != "" &&
            controller24.text != "") {
          itemsQ.add(0);
          items["3"] = [
            controller11.text,
            controller12.text,
            controller24.text
          ];
        }
        if (controller13.text != "" &&
            controller14.text != "" &&
            controller25.text != "") {
          itemsQ.add(0);
          items["4"] = [
            controller13.text,
            controller14.text,
            controller25.text
          ];
        }
        if (controller15.text != "" &&
            controller16.text != "" &&
            controller26.text != "") {
          itemsQ.add(0);
          items["5"] = [
            controller15.text,
            controller16.text,
            controller26.text
          ];
        }
        if (controller17.text != "" &&
            controller18.text != "" &&
            controller27.text != "") {
          itemsQ.add(0);
          items["6"] = [
            controller17.text,
            controller18.text,
            controller27.text
          ];
        }
        if (controller19.text != "" &&
            controller20.text != "" &&
            controller28.text != "") {
          itemsQ.add(0);
          items["7"] = [
            controller19.text,
            controller20.text,
            controller28.text
          ];
        }
        print("^items d :");
        print(items);

        print(select[isSelectedIndex]);
        if (select[isSelectedIndex] == "Kits") {
          await FirebaseFirestore.instance
              .collection(select[isSelectedIndex])
              .doc(quantos.toString())
              .set({
            "comments": 0,
            quem[isSelectedIndex]: [],
            entra[isSelectedIndex]: [],
            "items": items,
            "itemsQ": itemsQ,
            "fechou": false,
            "title": this.title,
            "text": this.text,
            "date": this.date,
            "hour": this.hour,
            "image": this.image,
          });
        } else if (select[isSelectedIndex] == "Posts") {
          await FirebaseFirestore.instance
              .collection(select[isSelectedIndex])
              .doc(quantos.toString())
              .set({
            "comments": 0,
            quem[isSelectedIndex]: [],
            entra[isSelectedIndex]: [],
            "fechou": false,
            "title": this.title,
            "text": this.text,
            "date": this.date,
            "hour": this.hour,
            "image": this.image,
          });
        } else {
          await FirebaseFirestore.instance
              .collection(select[isSelectedIndex])
              .doc(quantos.toString())
              .set({
            "comments": 0,
            "fechou": false,
            "title": this.title,
            "text": this.text,
            "date": this.date,
            "hour": this.hour,
            "image": this.image,
          });
        }
        await FirebaseFirestore.instance
            .collection("Info")
            .doc(select[isSelectedIndex])
            .update({"quantos": quantos + 1});
      }

      controller.text = "";
      controller1.text = "";
      controller2.text = "";
      controller3.text = "";
      controller4.text = "";
      controller5.text = "";
      controller6.text = "";
      controller7.text = "";
      controller8.text = "";
      controller9.text = "";
      controller10.text = "";
      controller11.text = "";
      controller12.text = "";
      controller13.text = "";
      controller14.text = "";
      controller15.text = "";
      controller16.text = "";
      controller17.text = "";
      controller18.text = "";
      controller19.text = "";
      controller20.text = "";
    }
  }

  Future getValuesKits() async {
    await FirebaseFirestore.instance
        .collection("Info")
        .doc("Kits")
        .get()
        .then((value) {
      quantosKits = value.data()["quantos"];
    });
    print(quantosKits);

    for (int i = quantosKits - 1; i >= 0; i--) {
      String text, title, hora, data, imagem;
      await FirebaseFirestore.instance
          .collection("Kits")
          .doc(i.toString())
          .get()
          .then((value) {
        text = value.data()["text"];
        title = value.data()["title"].toString();
        data = value.data()["date"];
        hora = value.data()["hour"];
        imagem = value.data()["image"];
      });
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

  Future _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null &&
        picked != selectedDate &&
        picked.weekday != DateTime.saturday &&
        picked.weekday != DateTime.sunday)
      setState(() {
        selectedDate = picked;
        _widgetOptions.removeLast();
        buildVisitas();
      });
    else {}
  }

  Future getVisitas() async {
    List<dynamic> listaConfX = [];
    await FirebaseFirestore.instance
        .collection("Calendar")
        .doc(selectedDate.year.toString() +
            "_".toString() +
            selectedDate.month.toString())
        .get()
        .then((value) => {
              if (value.data().containsKey(selectedDate.day.toString()))
                visitas = value.data()[selectedDate.day.toString()]
              else
                visitas = [],
            });
    await FirebaseFirestore.instance
        .collection("Calendar")
        .doc(selectedDate.year.toString() +
            "_".toString() +
            selectedDate.month.toString())
        .get()
        .then((value) => {
              if (value.data().containsKey("X" + selectedDate.day.toString()))
                {
                  listaConfX = value.data()["X" + selectedDate.day.toString()],
                  for (int i = 0; i < 108; i++)
                    {
                      if (listaConfX[i] != null)
                        {
                          visitas[i] = 0,
                        }
                    }
                }
            });
  }

  Future getValues() async {
    await FirebaseFirestore.instance
        .collection("Info")
        .doc("Posts")
        .get()
        .then((value) {
      quantosPosts = value.data()["quantos"];
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int quantosCahced = prefs.getInt("PostsCached");

    if (quantosCahced == null) quantosCahced = 0;
    prefs.setInt("PostsCached", quantosPosts);

    for (int i = quantosPosts - 1; i >= 0; i--) {
      Source a = Source.server;
      String text, title, hora, data, imagem;
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(i.toString())
          .get()
          .then((value) {
        text = value.data()["text"];
        title = value.data()["title"].toString() +
            " - ".toString() +
            a.toString()[7];
        data = value.data()["date"];
        hora = value.data()["hour"];
        imagem = value.data()["image"];
      });
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
      quantosAvisos = value.data()["quantos"];
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int quantosAvisosCahced = prefs.getInt("AvisosCached");

    if (quantosAvisosCahced == null) quantosAvisosCahced = 0;
    prefs.setInt("AvisosCached", quantosAvisos);

    for (int i = quantosAvisos - 1; i >= 0; i--) {
      Source a = Source.server;
      String text, title, hora, data, imagem;
      if (i < quantosAvisosCahced) {
        a = Source.cache;
      }
      await FirebaseFirestore.instance
          .collection("Avisos")
          .doc(i.toString())
          .get()
          .then((value) {
        text = value.data()["text"];
        title = value.data()["title"].toString() +
            " - ".toString() +
            a.toString()[7];
        data = value.data()["date"];
        hora = value.data()["hour"];
        imagem = value.data()["image"];
      });
      avisos.add(Aviso(
        text: text,
        title: title,
        hora: hora,
        data: data,
        imagem: imagem,
        number: i,
      ));
    }
    print("fim");
    return this.quantosAvisos;
  }

  Future _scanQR() async {
    try {
      var ttttt = await BarcodeScanner.scan();
      String qrResult = ttttt.toString();
      setState(() {
        result = qrResult;
        _widgetOptions.clear();
        buildBottomNavigationBar();
        print(qrResult);
        rebuildAllChildren(context);
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
          _widgetOptions.clear();
          buildBottomNavigationBar();
          rebuildAllChildren(context);
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
          _widgetOptions.clear();
          buildBottomNavigationBar();
          rebuildAllChildren(context);
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
        _widgetOptions.clear();
        buildBottomNavigationBar();
        rebuildAllChildren(context);
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
        _widgetOptions.clear();
        buildBottomNavigationBar();
        rebuildAllChildren(context);
      });
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    var ttttt = double.parse(s);
    print(ttttt);
    print(ttttt != null);
    return (double.parse(s) != null);
  }

  Future<dynamic> getCotas() async {
    if (!isNumeric(result)) {
      this.cotas = false;
    } else {
      print("bueda teste : |$result|");
      await FirebaseFirestore.instance
          .collection("Logins")
          .doc(result)
          .get()
          .then((value) {
        this.cotas = value.data()["cotas"];
        this.nome = value.data()["Username"];
        this.mail = value.data()["mail"];
        this.telemovel = value.data()["telemovel"];
        this.socio = value.data()["socio"];
      });
    }
    setState(() {});
  }

  void pagaCotas() async {
    if (isNumeric(result)) {
      await FirebaseFirestore.instance
          .collection("Logins")
          .doc(result)
          .update({"cotas": true});

      setState(() {
        _widgetOptions.clear();
        buildBottomNavigationBar();
        rebuildAllChildren(context);
      });
    }
  }

  void update() {
    setState(() {
      _widgetOptions.clear();
      buildBottomNavigationBar();
      rebuildAllChildren(context);
    });
  }

  void despagaCotas() async {
    if (isNumeric(result)) {
      await FirebaseFirestore.instance
          .collection("Logins")
          .doc(result)
          .update({"cotas": false});
      update();
    }
  }

  void showAchievementView(BuildContext context, bool presenca) {
    AchievementView(context,
        title: presenca ? "Yeaaah!" : "Ups...",
        subTitle: presenca ? "Confirmado! " : "Algo se passou...",
        icon: Icon(
          presenca ? Icons.mood : Icons.mood_bad,
          color: Colors.white,
        ),
        borderRadius: 5.0,
        color: presenca ? Colors.green : Colors.red,
        alignment: Alignment.topCenter,
        duration: Duration(seconds: 1),
        isCircle: true,
        listener: (status) {})
      ..show();
  }

  void showAchievementViewSocio(BuildContext context, bool presenca) {
    AchievementView(context,
        title: presenca ? "Yeaaah!" : "Ups...",
        subTitle: presenca ? "Numero Socio Atualizado! " : "Algo se passou...",
        icon: Icon(
          presenca ? Icons.mood : Icons.mood_bad,
          color: Colors.white,
        ),
        borderRadius: 5.0,
        color: presenca ? Colors.green : Colors.red,
        alignment: Alignment.topCenter,
        duration: Duration(seconds: 1),
        isCircle: true,
        listener: (status) {})
      ..show();
  }

  Future confirmVisit(int index) async {
    int _number = 99999;
    List<dynamic> listaConf = [];
    List<dynamic> visitasConf = [];
    await FirebaseFirestore.instance
        .collection("Calendar")
        .doc(selectedDate.year.toString() +
            "_".toString() +
            selectedDate.month.toString())
        .get()
        .then((value) => {
              if (value.data().containsKey("X" + selectedDate.day.toString()))
                {
                  listaConf = value.data()["X" + selectedDate.day.toString()],
                }
              else
                {
                  listaConf = new List.filled(108, 0),
                }
            });
    listaConf[index] = _number.toString();
    await FirebaseFirestore.instance
        .collection("Calendar")
        .doc(selectedDate.year.toString() +
            "_".toString() +
            selectedDate.month.toString())
        .update({"X".toString() + selectedDate.day.toString(): listaConf});

    await FirebaseFirestore.instance
        .collection("Logins")
        .doc(visitas[index].toString())
        .get()
        .then((value) => {
              if (value.data().containsKey("visitasConf"))
                {
                  visitasConf = value.data()["visitasConf"],
                }
              else
                {
                  visitasConf = [],
                }
            });
    visitasConf.add(selectedDate.year.toString() +
        "_".toString() +
        selectedDate.month.toString() +
        "_".toString() +
        selectedDate.day.toString() +
        "_".toString() +
        (((index ~/ 12) + 9).round()).toString() +
        "_".toString() +
        ((index % 12) * 5).toString());

    await FirebaseFirestore.instance
        .collection("Logins")
        .doc(visitas[index].toString())
        .update({"visitasConf": visitasConf});

    visitas.clear();
    _widgetOptions.removeLast();
    buildVisitas();
    setState(() {});
  }

  void _scanPresenca(
      int index, String what, String quem, String levouentrou) async {
    bool presenca = false;
    List<dynamic> lista = [];
    await FirebaseFirestore.instance
        .collection(what)
        .doc(index.toString())
        .get()
        .then((value) {
      lista = value.data()[quem];
    });
    if (lista.contains(result)) {
      lista.remove(result);
      await FirebaseFirestore.instance
          .collection(what)
          .doc(index.toString())
          .update({quem: lista});

      await FirebaseFirestore.instance
          .collection(what)
          .doc(index.toString())
          .get()
          .then((value) {
        lista = value.data()[levouentrou];
      });
      lista.add(result);
      await FirebaseFirestore.instance
          .collection(what)
          .doc(index.toString())
          .update({levouentrou: lista});

      presenca = true;
    } else {
      presenca = false;
    }
    showAchievementView(context, presenca);
  }

  _kitsPagar(int index) async {
    var lista, lista1;
    await FirebaseFirestore.instance
        .collection("Kits")
        .doc(index.toString())
        .get()
        .then((value) {
      lista1 = value.data()["quemquer"];
    });
    if (lista1.contains(result)) {
      await FirebaseFirestore.instance
          .collection("Kits")
          .doc(index.toString())
          .get()
          .then((value) {
        lista = value.data()["pagou"];
      });
      lista.add(result);
      await FirebaseFirestore.instance
          .collection("Kits")
          .doc(index.toString())
          .update({"pagou": lista});

      showAchievementView(context, true);
    } else
      showAchievementView(context, false);
  }

  showAlertDialog(BuildContext context, Kit post) {
    Widget okButton = TextButton(
      child: Text("Entregar"),
      onPressed: () {
        Navigator.pop(context);
        _scanPresenca(post.number, "Kits", "quemquer", "levou");
      },
    );
    Widget pagar = TextButton(
      child: Text("Pagar"),
      onPressed: () {
        Navigator.pop(context);
        _kitsPagar(post.number);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Items do kit"),
      content: Text(textKitsEntrega),
      actions: [okButton, pagar],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future _scanKit(Kit post) async {
    var items;
    //var itemsQ;
    var kitpessoa;
    double aa = 0;
    double ab = 0;
    await _scanQR();
    await FirebaseFirestore.instance
        .collection("Kits")
        .doc(post.number.toString())
        .get()
        .then((value) => {
              items = value.data()["items"],
              //itemsQ = value.data["itemsQ"],
            });
    await FirebaseFirestore.instance
        .collection("Logins")
        .doc(result.toString())
        .get()
        .then((value) => {kitpessoa = value.data()["Kits"]});

    if (kitpessoa.containsKey(post.number.toString()) == false && items != null)
      showAchievementViewSocio(context, false);
    else {
      textKitsEntrega = "";
      int quantosItemsKit = 0;

      for (int i = 0; i < 20; i++) {
        if (items.containsKey(i.toString())) quantosItemsKit++;
      }
      for (int i = 0; i < quantosItemsKit; i++) {
        if (kitpessoa[post.number.toString()][i] == true) {
          aa += double.parse(items[i.toString()][1]);
          ab += double.parse(items[i.toString()][2]);
          textKitsEntrega += "✅-> ";
        } else {
          textKitsEntrega += "❌-> ";
        }
        textKitsEntrega += items[i.toString()][0] + "\n";
      }
      textKitsEntrega += "\n Preço Socio: $ab | Não Socio $aa";
      showAlertDialog(context, post);
    }
  }

  Future _updateSocio() async {
    String socios = controllerSocio.text;
    if (socios != "" && result != "Faz Scan") {
      FirebaseFirestore.instance
          .collection("Logins")
          .doc(result.toString())
          .update({"socio": socios});
      showAchievementViewSocio(context, true);
    } else {
      showAchievementViewSocio(context, false);
    }
  }

  Future buildBottomNavigationBar() async {
    anuncios.clear();
    kits.clear();
    avisos.clear();

    _widgetOptions.add(FutureBuilder(
        future: getCotas(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
                child: Column(children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: FloatingActionButton.extended(
                          heroTag: null,
                          icon: Icon(Icons.camera_alt),
                          label: Text("Scan"),
                          onPressed: _scanQR,
                          backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                        )),
                    Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          result,
                          style: new TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        )),
                  ]),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                  child: Card(
                      child: QrImage(
                    data: result,
                    version: QrVersions.auto,
                    size: 100.0,
                  ))),
              Row(children: <Widget>[
                Expanded(
                    child: TextField(
                        controller: controllerSocio,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.title_outlined),
                          labelText: "Socio",
                        ))),
                FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: _updateSocio,
                    label: Text("Update Socio")),
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 0, 20),
                        child: Text("Cotas:")),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 20),
                        child: FloatingActionButton.extended(
                            backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                            onPressed: pagaCotas,
                            label: Text("Pagar"))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                        child: FloatingActionButton.extended(
                            backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                            onPressed: despagaCotas,
                            label: Text("Despagar"))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                        child: Icon(
                          cotas ? Icons.check : Icons.clear,
                          color: cotas ? Colors.green : Colors.red,
                          size: 50,
                        )),
                  ]),
              Card(
                  child: Column(children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                    child: Text("Mail: " + this.mail)),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                    child: Text("Nome: " + this.nome)),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                    child: Text("Telemovel: " + this.telemovel)),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                    child: Text("N Socio: " + this.socio)),
              ])),
            ]));
          }
        }));

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
                          scan: () => _scanPresenca(
                              post.number, "Posts", "quemvai", "entrou"),
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
                          scan: () => _scanPresenca(
                              post.number, "Posts", "quemvai", "entrou"),
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
                : Center(child: Text("Ainda não existem WorkShops"));
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
                      var post = this.kits[index];
                      return KitCard(
                          kit: post,
                          scan: () => _scanKit(post),
                          more: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        KitPage(post),
                                  ));
                            });
                          });
                    })
                : Center(child: Text("Ainda não existem Kits"));
          }
        }));

    buildCreate();

    buildVisitas();
  }

  Future buildVisitas() async {
    _widgetOptions.add(FutureBuilder(
        future: getVisitas(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                        child: Column(children: <Widget>[
                      FloatingActionButton.extended(
                          heroTag: null,
                          onPressed: _selectDate,
                          label: Text(selectedDate.year.toString() +
                              "-" +
                              selectedDate.month.toString() +
                              "-" +
                              selectedDate.day.toString())),
                      SizedBox(height: 20),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: this.visitas.length, //anuncios.length,
                          itemBuilder: (context, index) {
                            _textDia = ((((index ~/ 12) + 9).round() == 9)
                                    ? "0"
                                    : "") +
                                (((index ~/ 12) + 9).round()).toString() +
                                ":" +
                                (((index % 12) < 2) ? "0" : "") +
                                ((index % 12) * 5).toString() +
                                "   |   ";
                            if (this.visitas[index] != 0)
                              return Card(
                                  child: Row(children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                    child: Text(
                                        _textDia +
                                            this.visitas[index].toString(),
                                        style: TextStyle(fontSize: 20))),
                                FloatingActionButton.extended(
                                    backgroundColor: Colors.white,
                                    heroTag: null,
                                    onPressed: () => confirmVisit(index),
                                    label: Text("Confirm",
                                        style: TextStyle(color: Colors.black)),
                                    icon:
                                        Icon(Icons.check, color: Colors.green)),
                              ]));
                            else
                              return SizedBox(
                                width: 0,
                              );
                          }),
                    ]))));
          }
        }));
  }

  Future buildCreate() async {
    //print("criei");
    _widgetOptions.add(Center(
        child: SingleChildScrollView(
      child: Align(
          alignment: Alignment.center,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Align(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: this.controller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.title_outlined),
                          labelText: "Title",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: this.controller1,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.text_fields),
                          labelText: "text",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: this.controller2,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.image),
                          labelText: "Image",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: this.controller3,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.date_range_outlined),
                          labelText: "Date",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: this.controller4,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.watch),
                          labelText: "Hour",
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  (isSelectedIndex == 2)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                              Row(children: <Widget>[
                                Flexible(
                                    child: TextField(
                                  controller: this.controller5,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.card_travel),
                                    labelText: "Item",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller6,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller21,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço Socio",
                                  ),
                                ))
                              ]),
                              Row(children: <Widget>[
                                Flexible(
                                    child: TextField(
                                  controller: this.controller7,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.card_travel),
                                    labelText: "Item",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller8,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller22,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço Socio",
                                  ),
                                ))
                              ]),
                              Row(children: <Widget>[
                                Flexible(
                                    child: TextField(
                                  controller: this.controller9,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.card_travel),
                                    labelText: "Item",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller10,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller23,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço Socio",
                                  ),
                                ))
                              ]),
                              Row(children: <Widget>[
                                Flexible(
                                    child: TextField(
                                  controller: this.controller11,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.card_travel),
                                    labelText: "Item",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller12,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller24,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço Socio",
                                  ),
                                ))
                              ]),
                              Row(children: <Widget>[
                                Flexible(
                                    child: TextField(
                                  controller: this.controller13,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.card_travel),
                                    labelText: "Item",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller14,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller25,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço Socio",
                                  ),
                                ))
                              ]),
                              Row(children: <Widget>[
                                Flexible(
                                    child: TextField(
                                  controller: this.controller15,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.card_travel),
                                    labelText: "Item",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller16,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller26,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço Socio",
                                  ),
                                ))
                              ]),
                              Row(children: <Widget>[
                                Flexible(
                                    child: TextField(
                                  controller: this.controller17,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.card_travel),
                                    labelText: "Item",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller18,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller27,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço Socio",
                                  ),
                                ))
                              ]),
                              Row(children: <Widget>[
                                Flexible(
                                    child: TextField(
                                  controller: this.controller19,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.card_travel),
                                    labelText: "Item",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller20,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço",
                                  ),
                                )),
                                Flexible(
                                    child: TextField(
                                  controller: this.controller28,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    labelText: "Preço Socio",
                                  ),
                                ))
                              ]),
                            ])
                      : SizedBox(),
                  Text(textinho),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ToggleButtons(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(children: <Widget>[
                                Icon(Icons.warning_rounded),
                                Text("Avisos"),
                              ])),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(children: <Widget>[
                                Icon(Icons.mail_outline_rounded),
                                Text("Palestras")
                              ])),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(children: <Widget>[
                                Icon(Icons.shop_rounded),
                                Text("Kits")
                              ])),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            isSelected = [false, false, false];
                            isSelected[index] = true;
                            isSelectedIndex = index;
                            print(isSelectedIndex);
                            print(select[isSelectedIndex]);
                            _widgetOptions.removeAt(4);
                            _widgetOptions.removeAt(4);
                            buildCreate();
                            buildVisitas();
                          });
                        },
                        isSelected: isSelected,
                      ),
                      Align(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: FloatingActionButton.extended(
                            backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                            onPressed: click,
                            label: Text("Done",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            icon: Icon(
                              Icons.create,
                              color: Colors.white,
                            ),
                            heroTag: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ))),
    )));
    //print(_widgetOptions.length);
  }

  @override
  void initState() {
    super.initState();
    buildBottomNavigationBar();
    print("###########");
    print(quantosAvisos);
    print(quantosPosts);
    print(quantosKits);
    print("###########");
    //setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 102, 51, 1),
          centerTitle: true,
          title: Row(children: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: update),
            Expanded(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'NEEEICUM ADMIN',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            )),
          ])),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        //backgroundColor: Color(121212),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        iconSize: 23,
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_rounded), label: "QRCode"),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: "Avisos"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_post_office), label: "Posts"),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Kits"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline), label: "Gerir"),
          BottomNavigationBarItem(
              icon: Icon(Icons.login_outlined), label: "Idas"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        selectedIconTheme: IconThemeData(color: Colors.amber[800]),
        onTap: _onItemTapped,
      ),
    );
  }
}
