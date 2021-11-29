import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:achievement_view/achievement_view.dart';
import 'DDPicker.dart';

class DateAndTimePicker extends StatefulWidget {
  @override
  _DateAndTimePickerState createState() => _DateAndTimePickerState();
}

class _DateAndTimePickerState extends State<DateAndTimePicker> {
  int _ano = DateTime.now().year;
  int _mes = DateTime.now().month;
  int _dia = DateTime.now().day;
  int _anoN = DateTime.now().year;
  int _mesN = DateTime.now().month;
  int _diaN = DateTime.now().day;
  int _hor = 9;
  int _min = 0;
  int _anoT, _mesT, _diaT, _horT = 9, _minT = 0;
  Color corzinha = Color.fromRGBO(255, 102, 51, 1);
  String _textDia = " ";
  List<dynamic> _matrix = new List(108);
  String _number = "00000";
  List<dynamic> visitas = [];
  List<dynamic> visitasConf = [];
  List<dynamic> visitasShow = [];
  List<dynamic> visitasDates = [];
  List<dynamic> testDate = [];
  int _numDateTest, _numDateTestT;
  var b;
  int quantasVisitas = 0;

  String a;
  String agora;

  DateTime selectedDate = DateTime.now();
  List<int> maxdias = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  @override
  void initState() {
    super.initState();
    getName();
    _showDay();
  }

  Future getVisitas() async {
    await FirebaseFirestore.instance
        .collection("Logins")
        .doc(_number)
        .get()
        .then((value) => {
              agora = _ano.toString() +
                  "_" +
                  _mes.toString() +
                  "_" +
                  _dia.toString() +
                  "_" +
                  _hor.toString() +
                  "_" +
                  _min.toString(),
              if (value.data().containsKey("visitas"))
                {
                  visitasDates.clear(),
                  visitasShow.clear(),
                  visitas = value.data()["visitas"],
                  visitas.sort(),
                  for (int i = 0; i < visitas.length; i++)
                    {
                      a = visitas[i],
                      testDate = a.split("_"),
                      _anoT = int.parse(testDate[0]),
                      _mesT = int.parse(testDate[1]),
                      _diaT = int.parse(testDate[2]),
                      _horT = int.parse(testDate[3]),
                      _minT = int.parse(testDate[4]),
                      _numDateTestT = _anoT * 100000000 +
                          _mesT * 1000000 +
                          _diaT * 10000 +
                          _horT * 100 +
                          _minT,
                      _numDateTest =
                          _anoN * 100000000 + _mesN * 1000000 + _diaN * 10000,
                      print(_numDateTest.toString() +
                          " | " +
                          _numDateTestT.toString()),
                      if (_numDateTestT >= _numDateTest)
                        {
                          visitasDates.add(visitas[i]),
                          //for (int i = 0; i < visitasDates.length; i++)
                          //{
                          a = visitas[i],
                          //print(visitas[visitasDates[i]]),
                          b = a.split("_"),
                          a = b[0] +
                              "-" +
                              ((int.parse(b[1]) <= 9) ? "0" : "") +
                              b[1] +
                              "-" +
                              ((int.parse(b[2]) <= 9) ? "0" : "") +
                              b[2] +
                              " " +
                              ((b[3] == '9') ? "0" : "") +
                              b[3] +
                              ":" +
                              ((b[4] == '0' || b[4] == '5') ? "0" : "") +
                              b[4],
                          visitasShow.add(a),
                        },
                    }
                },
              print("##############"),
              print(visitasShow),
              quantasVisitas = visitasShow.length,
            });

    await FirebaseFirestore.instance
        .collection("Logins")
        .doc(_number)
        .get()
        .then((value) => {
              if (value.data().containsKey("visitasConf"))
                {
                  visitasConf = value.data()["visitasConf"],
                  visitasConf.sort(),
                }
              else
                {
                  visitasConf = [],
                }
            });
    visitas.sort();
    visitasConf.sort();
    visitasShow.sort();
  }

  Future getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _number = prefs.getString("number");
  }

  NumberPicker integerInfiniteNumberPicker;

  Future _showDay() async {
    String doc = _ano.toString() + "_" + _mes.toString(); // + _dia.toString();
    print(doc);
    await FirebaseFirestore.instance
        .collection("Calendar")
        .doc(doc)
        .get()
        .then((value) {
      if (value.exists) {
        if (value.data()[_dia.toString()] == null) {
          _textDia = "Dia Vazio! Escolhe a hora que queres!";
          _matrix = new List(108);
        } else if (value.data()[_dia.toString()].contains(_number)) {
          _textDia = "Já tens uma visita neste dia";
        } else {
          _textDia = "Ocupado nestas horas: ";
          _matrix = value.data()[_dia.toString()];
          for (int i = 0; i < 108; i++) {
            if (_matrix[i] != null) {
              _textDia += ((((i ~/ 12) + 9).round() == 9) ? "0" : "") +
                  (((i ~/ 12) + 9).round()).toString() +
                  ":" +
                  (((i % 12) < 2) ? "0" : "") +
                  ((i % 12) * 5).toString() +
                  " | ";
            }
          }
          print(_textDia);
        }
      } else {
        _textDia = "Dia Vazio! Escolhe a hora que queres! ";
      }
    });
    setState(() {});
  }

  void showAchievementView(BuildContext context, int presenca) {
    List<String> titulos = ["Yeaaaah!", "Ups...", "Ups...", "Ups..."];
    List<String> subtitulos = [
      "Confirmado!",
      "Hora já ocupada",
      "Escolheste um fim de semana",
      "Já tens uma visita neste dia"
    ];
    AchievementView(context,
        title: titulos[presenca],
        subTitle: subtitulos[presenca],
        icon: Icon(
          (presenca == 0) ? Icons.mood : Icons.mood_bad,
          color: Colors.white,
        ),
        borderRadius: 5.0,
        color: (presenca == 0) ? Colors.green : Colors.red,
        alignment: Alignment.topCenter,
        duration: Duration(seconds: 1),
        isCircle: true,
        listener: (status) {})
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(255, 102, 51, 1),
          title: Text(
            'Marca a tua ida à sala do Núcleo',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "A visita tem que ser confirmada por alguém responsável.",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      )))),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: FutureBuilder(
                            future: getVisitas(),
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return new Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return (quantasVisitas != 0)
                                    ? ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: this
                                            .visitasShow
                                            .length, //anuncios.length,
                                        itemBuilder: (context, index) {
                                          var post = this.visitasShow[index];
                                          var postCMP =
                                              this.visitasDates[index];
                                          print(visitasConf
                                              .contains(visitasDates[index]));
                                          print(visitasShow);
                                          print(visitasDates);
                                          return Card(
                                              child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      20, 5, 20, 5),
                                                  child: Row(children: <Widget>[
                                                    Text(post),
                                                    Expanded(child: Text("")),
                                                    Text(
                                                        (visitasConf.contains(
                                                                postCMP))
                                                            ? "Visita Confirmada!"
                                                            : "Visita por Confirmar",
                                                        style: TextStyle(
                                                            color: (visitasConf
                                                                    .contains(
                                                                        postCMP))
                                                                ? Colors.green
                                                                : Colors.red)),
                                                    Icon(
                                                        (visitasConf.contains(
                                                                postCMP))
                                                            ? Icons.check
                                                            : Icons.clear,
                                                        color: (visitasConf
                                                                .contains(
                                                                    postCMP))
                                                            ? Colors.green
                                                            : Colors.red)
                                                  ])));
                                        })
                                    : Center(
                                        child: Text(
                                            "Ainda não agendaste nenhuma ida à sala do Núcleo"));
                              }
                            })),
                    SizedBox(height: 20),
                    FloatingActionButton.extended(
                        heroTag: null,
                        onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DDPicker()))
                            },
                        backgroundColor: corzinha,
                        label: Text(
                          "Nova Visita",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              ),
            ),
          )
        ]));
  }
}
