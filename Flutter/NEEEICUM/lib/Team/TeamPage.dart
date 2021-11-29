import 'package:flutter/material.dart';
import 'TeamCard.dart';

// ignore: must_be_immutable
class TeamPage extends StatefulWidget {
  List<List<String>> list;
  String name;

  @override
  TeamPage(this.list, this.name);

  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(255, 102, 51, 1),
          title: Row(children: <Widget>[
            Expanded(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  this.widget.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Image.asset(
                  "assets/images/Icon.png",
                  fit: BoxFit.cover,
                  height: 32,
                ),
              ],
            )),
          ])),
      body: ListView.builder(
          //physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: this.widget.list.length, //anuncios.length,
          itemBuilder: (context, index) {
            var pessoa = this.widget.list[index];
            return TeamCard(pessoa);
          }),
    );
  }
}
