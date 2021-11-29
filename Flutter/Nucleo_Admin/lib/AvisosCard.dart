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
  final Function scan;
  AvisoCard({this.aviso, this.more, this.scan});

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
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
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
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                /*FlatButton.icon(
                  onPressed: scan,
                  label: Text('Scan'),
                  icon: Icon(Icons.qr_code),
                ),*/
                FlatButton.icon(
                  onPressed: more,
                  label: Text('Show'),
                  icon: Icon(Icons.more),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
