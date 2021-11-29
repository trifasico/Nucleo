import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Aviso {
  String text;
  String title;
  String hora;
  String data;
  String imagem;
  int number;

  Aviso(
      {this.text, this.title, this.hora, this.data, this.imagem, this.number});
}

// ignore: must_be_immutable
class AvisoCard extends StatelessWidget {
  final Aviso aviso;
  final Function more;
  AvisoCard({this.aviso, this.more});

  int sizeToShow = 25;

  int getValue() {
    for (int i = 0; i < this.aviso.text.length - 1; i++) {
      if (this.aviso.text[i] == ' ') {
        sizeToShow = sizeToShow - 1;
      }
      if (sizeToShow == 0) {
        return i;
      }
    }
    return this.aviso.text.length;
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                aviso.title,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              Row(children: <Widget>[
                SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Text(
                      aviso.text.substring(0, getValue()),
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                  ),
                ),
                (aviso.imagem != "a")
                    ? Image.network(
                        aviso.imagem,
                        height: 75,
                      )
                    : SizedBox(),
              ]),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
      onPressed: more,
    );
  }
}
