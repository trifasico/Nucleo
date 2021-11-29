import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TeamCard extends StatefulWidget {
  var pessoa;
  @override
  TeamCard(this.pessoa);

  _TeamCardState createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(children: <Widget>[
              Image.asset(
                "assets/images/" + this.widget.pessoa[1] + ".jpeg",
                fit: BoxFit.cover,
                height: 120,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(this.widget.pessoa[0]),
                  Text("Cargo: " + this.widget.pessoa[2]),
                  Text("Contacto : a" +
                      this.widget.pessoa[1] +
                      "@alunos.uminho.pt"),
                ],
              )),
            ])));
  }
}
