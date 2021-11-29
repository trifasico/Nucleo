import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'KitCard.dart';
import 'KitPage.dart';
import '../Extras/DateTimePicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:achievement_view/achievement_view.dart';

// ignore: must_be_immutable
class KitItemsPicker extends StatefulWidget {
  Kit kit;

  @override
  KitItemsPicker(this.kit);

  _KitItemsPickerState createState() => _KitItemsPickerState();
}

class _KitItemsPickerState extends State<KitItemsPicker> {
  List<dynamic> quemquer = [];
  List<dynamic> itemsQ = [];
  List<List<dynamic>> items;

  List<bool> _checked;
  int quantosItems;
  bool firstTime = true;
  String _preco = "";
  String _sprecoS = "";
  String _sprecoNS = "";

  @override
  void initState() {
    super.initState();
  }

  void _updatePrice() {
    double precoS = 0;
    double precoNS = 0;
    for (int i = 0; i < _checked.length; i++) {
      if (_checked[i] == true) {
        precoNS += double.parse(items[i][1]);
        precoS += double.parse(items[i][2]);
      }
    }
    _sprecoS = precoS.toString() + " €";
    _sprecoNS = precoNS.toString() + " €";
    _preco = "Socio: " +
        precoS.toString() +
        "€" +
        " | Não Sócio: " +
        precoNS.toString() +
        "€";
  }

  Future getKitItems() async {
    if (firstTime == true) {
      await FirebaseFirestore.instance
          .collection("Kits")
          .doc(this.widget.kit.number.toString())
          .get()
          .then((value) => {
                quantosItems = 0,
                items = new List(10),
                for (int i = 0; i < 10; i++)
                  {
                    if (value.data()["items"].containsKey(i.toString()))
                      {
                        items[i] = new List(3),
                        items[i][0] = value.data()["items"][i.toString()][0],
                        items[i][1] = value.data()["items"][i.toString()][1],
                        items[i][2] = value.data()["items"][i.toString()][2],
                        quantosItems += 1,
                      },
                  },
                _checked = new List<bool>(quantosItems),
                for (int i = 0; i < quantosItems; i++) {_checked[i] = false},
                _checked[0] = true,
              });
      setState(() {
        firstTime = false;
      });
      _updatePrice();
    }
  }

  Future _going() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic number = prefs.getString('number');

    await FirebaseFirestore.instance
        .collection("Kits")
        .doc(this.widget.kit.number.toString())
        .get()
        .then((value) => {
              quemquer = value.data()["quemquer"],
              itemsQ = value.data()["itemsQ"],
            });

    quemquer.add(number);
    for (int i = 0; i < _checked.length; i++) {
      if (_checked[i] == true) {
        itemsQ[i] += 1;
      }
    }
    await FirebaseFirestore.instance
        .collection("Kits")
        .doc(this.widget.kit.number.toString())
        .update({"quemquer": quemquer, "itemsQ": itemsQ});

    var kitsQUER;

    await FirebaseFirestore.instance
        .collection("Logins")
        .doc(number)
        .get()
        .then((value) => kitsQUER = value.data()["Kits"]);

    if (kitsQUER == null) kitsQUER = {};

    kitsQUER[this.widget.kit.number.toString()] = _checked;

    await FirebaseFirestore.instance
        .collection("Logins")
        .doc(number)
        .update({"Kits": kitsQUER});

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => KitPage(this.widget.kit)));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DateAndTimePicker()));
  }

  void showAchievementView(BuildContext context) {
    AchievementView(context,
        title: "Ups...",
        subTitle: "Não selecionaste nenhum item",
        icon: Icon(
          Icons.mood_bad,
          color: Colors.white,
        ),
        borderRadius: 5.0,
        color: Colors.red,
        alignment: Alignment.topCenter,
        duration: Duration(seconds: 1),
        isCircle: true,
        listener: (status) {})
      ..show();
  }

  _confirmBefore(BuildContext context) {
    bool a = false;
    for (int i = 0; i < _checked.length; i++) {
      if (_checked[i] == true) a = true;
    }
    if (a == true)
      _goingBox(context);
    else
      showAchievementView(context);
  }

  _goingBox(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Confirmar e Agendar"),
      onPressed: () async {
        Navigator.of(context).pop();
        _going();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Confirmar e Agendar"),
      content: Text(
          "Tens a certeza que queres adequirir este kit?\nPor favor agenda uma marcação para efetuares o pagamento.\nO preço final é de $_sprecoNS.\nQuando fores a sala do NEEEICUM, faz-te sócio e paga apenas $_sprecoS"),
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
            this.widget.kit.title + " - ITEMS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          backgroundColor: Color.fromRGBO(255, 102, 51, 1),
        ),
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  Card(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Text(
                            "Escolhe os items do teu kit", // \nOs preços apresentados são o de Socio | Não Socio\nPodes te fazer sócio ao ires pagar o kit!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20))),
                  ),
                  Expanded(
                      child: FutureBuilder(
                          future: getKitItems(),
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                firstTime != false) {
                              return new Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              if (quantosItems > 0)
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: quantosItems, //anuncios.length,
                                    itemBuilder: (context, index) {
                                      var item = this.items[index];
                                      return Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              2.5, 5, 2.5, 5),
                                          child: Card(
                                              child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      2.5, 3, 2.5, 3),
                                                  child: CheckboxListTile(
                                                      title: Text(item[0] +
                                                          "\n" +
                                                          "            Preço Sócio: " +
                                                          item[2] +
                                                          "€" +
                                                          " | Preço não Sócio: " +
                                                          item[1] +
                                                          "€"),
                                                      value: _checked[index],
                                                      onChanged: (bool value) {
                                                        setState(() {
                                                          //if (index != 0)
                                                          _checked[index] =
                                                              value;
                                                          _updatePrice();
                                                        });
                                                      }))));
                                    });
                              else
                                return Text("Items <= 0");
                            }
                          })),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Card(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text("Preço total a pagar: " + _preco,
                                  style: TextStyle(fontSize: 23))))),
                  FloatingActionButton.extended(
                      onPressed: () {
                        _confirmBefore(context);
                      },
                      backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                      label: Text("Confirmação",
                          style: TextStyle(color: Colors.white)),
                      icon: Icon(Icons.check, color: Colors.white))
                ]))));
  }
}
