import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Inscrito {
  String text;
  String title;
  String hora;
  String data;
  String imagem;
  int number;

  Inscrito(
      {this.text, this.title, this.hora, this.data, this.imagem, this.number});
}

// ignore: must_be_immutable
class InscritoCard extends StatelessWidget {
  final Inscrito inscrito;
  final Function more;
  InscritoCard({this.inscrito, this.more});

  int sizeToShow = 25;

  int getValue() {
    for (int i = 0; i < this.inscrito.text.length - 1; i++) {
      if (this.inscrito.text[i] == ' ') {
        sizeToShow = sizeToShow - 1;
      }
      if (sizeToShow == 0) {
        return i;
      }
    }
    return this.inscrito.text.length;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              inscrito.title,
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
                    inscrito.text.substring(0, getValue()),
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ),
              ),
              (inscrito.imagem != "a")
                  ? Image.network(
                      inscrito.imagem,
                      height: 75,
                    )
                  : SizedBox(),
            ]),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
