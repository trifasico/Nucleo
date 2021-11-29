import 'package:flutter/material.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DateTimePicker.dart';

class DDPicker extends StatefulWidget {
  @override
  _DDPickerState createState() => _DDPickerState();
}

class _DDPickerState extends State<DDPicker> {
  int _ano = DateTime.now().year;
  int _mes = DateTime.now().month;
  int _dia = DateTime.now().day;
  int _hor = 9;
  int _min = 0;
  String _textDia = " ";
  List<dynamic> _matrix = new List(108);
  String _number = "00000";
  Color corzinha = Color.fromRGBO(255, 102, 51, 1);

  DateTime selectedDate = DateTime.now(); //.add(new Duration(days: 1));

  List<int> maxdias = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  @override
  void initState() {
    super.initState();
    //if (selectedDate == DateTime.now()) selectedDate.add(new Duration(days: 1));
    getName();
    _showDay();
  }

  Future getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _number = prefs.getString("number");
  }

  NumberPicker integerInfiniteNumberPicker;
  Future _selectDate() async {
    /*if (selectedDate == DateTime.now()) selectedDate.add(new Duration(days: 1));
    while (selectedDate.day == DateTime.saturday ||
        selectedDate.day == DateTime.sunday) {
      selectedDate = selectedDate.add(new Duration(days: 1));
    }*/
    print(selectedDate);
    final DateTime picked = await showDatePicker(
      context: context,
      selectableDayPredicate: (DateTime.now().day != DateTime.sunday &&
              DateTime.now().day != DateTime.saturday)
          ? (selectedDate) => selectedDate.weekday == DateTime.sunday ||
                  selectedDate.weekday == DateTime.saturday
              ? true
              : true
          : (selectedDate) => selectedDate.weekday == DateTime.sunday ||
                  selectedDate.weekday == DateTime.saturday
              ? false
              : true,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime.now(), //.add(new Duration(days: 1)),
      lastDate: DateTime(2025),
    );
    if (picked != null &&
        picked.weekday != DateTime.saturday &&
        picked.weekday != DateTime.sunday)
      setState(() {
        selectedDate = picked;
        print(selectedDate);
        _ano = selectedDate.year;
        _mes = selectedDate.month;
        _dia = selectedDate.day;
        _showDay();
      });
    else if (picked == null) {
    } else {
      showAchievementView(context, 2);
    }
  }

  Future _showInfIntDialogHor() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new NumberPickerDialog.integer(
                minValue: 9,
                maxValue: 17,
                step: 1,
                initialIntegerValue: _hor,
                infiniteLoop: true,
              ),
            ]);
      },
    ).then((num value) {
      if (value != null) {
        setState(() => {
              _hor = value,
              _showDay(),
            });
      }
    });
  }

  Future _showInfIntDialogMin() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new NumberPickerDialog.integer(
                minValue: 0,
                maxValue: 55,
                step: 5,
                initialIntegerValue: _min,
                infiniteLoop: true,
              ),
            ]);
      },
    ).then((num value) {
      if (value != null) {
        setState(() => {
              _min = value,
              _showDay(),
            });
      }
    });
  }

  Future _showDay() async {
    String doc = _ano.toString() + "_" + _mes.toString(); // + _dia.toString();
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
            if (_matrix[i] != 0) {
              _textDia += ((((i ~/ 12) + 9).round() == 9) ? "0" : "") +
                  (((i ~/ 12) + 9).round()).toString() +
                  ":" +
                  (((i % 12) < 2) ? "0" : "") +
                  ((i % 12) * 5).toString() +
                  " | ";
            }
          }
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
      "Marcada!",
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
    if (presenca == 0) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => DateAndTimePicker()));
    }
  }

  Future _confirm() async {
    List<dynamic> xx = [];
    for (int i = 0; i < 108; i++) {
      xx.add(0);
    }
    _matrix = xx;
    String doc = _ano.toString() + "_" + _mes.toString(); // + _dia.toString();
    //print(doc);
    await FirebaseFirestore.instance
        .collection("Calendar")
        .doc(doc)
        .get()
        .then((value) => {
              if (value.exists)
                {
                  if (value.data()[_dia.toString()] != null)
                    _matrix = value.data()[_dia.toString()],
                }
            });

    print("ola super");
    if (_matrix == null) _matrix = xx;
    if (_textDia == "Dia Vazio! Escolhe a hora que queres! ") {
      _matrix = xx;
      _matrix[(((_hor - 9) * 12) + (_min / 5)).toInt()] = _number;
      print("ola super nandinhyo");
      await FirebaseFirestore.instance
          .collection("Calendar")
          .doc(doc)
          .set({_dia.toString(): _matrix});
      print("ola snandindindindindindindn");
      List<dynamic> lista = [];
      await FirebaseFirestore.instance
          .collection("Logins")
          .doc(_number)
          .get()
          .then((value) {
        //if (value.data.containsKey("visitas")) \
        if (value.exists) lista = value.data()["visitas"];
      });
      if (lista == null) lista = [];
      lista.add(doc +
          "_" +
          _dia.toString() +
          "_" +
          _hor.toString() +
          "_" +
          _min.toString());
      await FirebaseFirestore.instance
          .collection("Logins")
          .doc(_number)
          .update({"visitas": lista});

      showAchievementView(context, 0);
    } else if (_textDia == "Já tens uma visita neste dia") {
      showAchievementView(context, 3);
    } else {
      print(_matrix[(((_hor - 9) * 12) + (_min / 5)).toInt()]);
      if (_matrix[(((_hor - 9) * 12) + (_min / 5)).toInt()] == 0) {
        _matrix[(((_hor - 9) * 12) + (_min / 5)).toInt()] = _number;
        String aaaaaaaa = _dia.toString();
        print("ola super nandinhyo 2222222");
        print(_dia.toString());
        print(_matrix);
        await FirebaseFirestore.instance
            .collection("Calendar")
            .doc(doc)
            .update({aaaaaaaa: _matrix});
        //_ocupado = " ";
        print("ola super nandinhyo 2222222");
        List<dynamic> lista = [];
        print("ola super nandinhyo 2222222");
        await FirebaseFirestore.instance
            .collection("Logins")
            .doc(_number)
            .get()
            .then((value) {
          //if (value.data.containsKey("visitas")) \
          if (value.exists) lista = value.data()["visitas"];
        });
        print("ola super nandinhyo 2222222");
        if (lista == null) lista = [];
        print("ola super nandinhyo 2222222");
        lista.add(doc +
            "_" +
            _dia.toString() +
            "_" +
            _hor.toString() +
            "_" +
            _min.toString());
        print("ola super nandinhyo 2222222");
        await FirebaseFirestore.instance
            .collection("Logins")
            .doc(_number)
            .update({"visitas": lista});
        print("ola super nandinhyo 2222222");
        showAchievementView(context, 0);
      } else {
        //_ocupado = "Hora já ocupada";
        showAchievementView(context, 1);
      }
    }
    //_showDay();
    //setState(() {});
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
        SizedBox(
          height: 20.0,
        ),
        Padding(
            padding: EdgeInsets.all(5),
            child: Card(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "As visitas são de 5 mins e estão limitadas a uma visita por dia por pessoa.",
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    )))),
        SizedBox(
          height: 20.0,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //Text("Escolhe o dia -> ", style: TextStyle(fontSize: 20)),
              FloatingActionButton.extended(
                  onPressed: _selectDate,
                  backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                  label: Text(
                      selectedDate.year.toString() +
                          " - " +
                          selectedDate.month.toString() +
                          " - " +
                          selectedDate.day.toString(),
                      style: TextStyle(color: Colors.white)))
            ]),
        SizedBox(
          height: 20.0,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21.0)),
                elevation: 4.0,
                onPressed: _showInfIntDialogHor,
                child: Container(
                  color: corzinha,
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.timer,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                                Text(
                                  " $_hor",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        " Horas",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: corzinha,
              ),
              SizedBox(
                width: 20.0,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                elevation: 4.0,
                onPressed: _showInfIntDialogMin,
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            color: corzinha,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.watch,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                                Text(
                                  " $_min",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        " Minutos",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: corzinha,
              ),
            ]),
        SizedBox(
          height: 20.0,
        ),
        Text(
          _textDia,
          style: TextStyle(),
        ),
        SizedBox(
          height: 20.0,
        ),
        FloatingActionButton.extended(
            backgroundColor: Color.fromRGBO(255, 102, 51, 1),
            heroTag: null,
            onPressed: _confirm,
            label: Text("Confirma", style: TextStyle(color: Colors.white))),
      ]),
    );
  }
}
