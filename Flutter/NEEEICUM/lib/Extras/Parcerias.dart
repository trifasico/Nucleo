import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Parceria {
  String title;
  String imagem;
  String icon;
  String text;

  Parceria({this.title, this.imagem, this.icon, this.text});
}

class Parcerias extends StatefulWidget {
  final Parceria pa;

  Parcerias(this.pa);

  @override
  _ParceriasState createState() => _ParceriasState();
}

class _ParceriasState extends State<Parcerias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          this.widget.pa.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Color.fromRGBO(255, 102, 51, 1),
      ),
      body: Column(children: <Widget>[
        //SizedBox(height: 10),
        Expanded(
            child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: (this.widget.pa.imagem != "a")
                            ? Image.network(
                                this.widget.pa.imagem,
                              )
                            : SizedBox()))),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child:
                    Text(this.widget.pa.text, style: TextStyle(fontSize: 15))),
          ],
        )),
      ]),
    );
  }
}
