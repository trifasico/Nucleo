import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Kit {
  String text;
  String title;
  String hora;
  String data;
  String imagem;
  int number;

  Kit({this.text, this.title, this.hora, this.data, this.imagem, this.number});
}

// ignore: must_be_immutable
class KitCard extends StatelessWidget {
  final Kit kit;
  final Function more;
  KitCard({this.kit, this.more});

  int sizeToShow = 25;

  int getValue() {
    for (int i = 0; i < this.kit.text.length - 1; i++) {
      if (this.kit.text[i] == ' ') {
        sizeToShow = sizeToShow - 1;
      }
      if (sizeToShow == 0) {
        return i;
      }
    }
    return this.kit.text.length;
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      //margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                kit.title,
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
                      kit.text.substring(0, getValue()),
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                  ),
                ),
                (kit.imagem != "a")
                    ? Image.network(
                        kit.imagem,
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
