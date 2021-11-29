import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SponsorsIndividual.dart';

class Sponsor {
  String title;
  String imagem;
  String icon;
  String text;
  String url;

  Sponsor({this.title, this.imagem, this.icon, this.text, this.url});
}

class Sponsors extends StatefulWidget {
  @override
  _SponsorsState createState() => _SponsorsState();
}

class _SponsorsState extends State<Sponsors> {
  List<Widget> _widgetOptions = <Widget>[];
  int numeroDeSponsors = 69;
  List<Sponsor> spon = <Sponsor>[];

  Future<dynamic> _test() async {
    await FirebaseFirestore.instance
        .collection("JEE21")
        .doc("Info")
        .get()
        .then((value) {
      numeroDeSponsors = value["sponsors"];
    });

    for (int i = 0; i < numeroDeSponsors; i++) {
      String text, title, icon, imagem, url;
      await FirebaseFirestore.instance
          .collection("JEE21")
          .doc("Dados")
          .collection("Sponsors")
          .doc(i.toString())
          .get()
          .then((value) {
        title = value.data()["title"];
        text = value.data()["text"];
        icon = value.data()["icon"];
        imagem = value.data()["imagem"];
        url = value.data()["urlvideo"];
      });
      text = text.replaceAll("|", "\n");
      spon.add(Sponsor(
        text: text,
        title: title,
        icon: icon,
        imagem: imagem,
        url: url,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    buildBottomNavigationBar();
    setState(() {});
  }

  void _goToSpon(int index) {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  SponsorsIndividual(this.spon.elementAt(index))));
    });
  }

  Future buildBottomNavigationBar() async {
    _widgetOptions.clear();
    _widgetOptions.add(FutureBuilder(
        future: _test(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return (numeroDeSponsors != 0)
                ? Padding(
                    padding: EdgeInsets.all(5),
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      itemCount: numeroDeSponsors,
                      itemBuilder: (BuildContext context, int index) =>
                          new FlatButton(
                        onPressed: () => _goToSpon(index),
                        child: Container(
                            color: Color.fromRGBO(255, 102, 51, 0),
                            child: new Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.all(2),
                                      child: (spon[index].icon != "a")
                                          ? Image.network(
                                              spon[index].icon,
                                              height: 100,
                                            )
                                          : SizedBox())
                                ]))),
                      ),
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(2, 2),
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ))
                : Center(
                    child: Card(
                        elevation: 0,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Brevemente Disponível...",
                                style: TextStyle(fontSize: 20)))),
                  );
          }
        }));
    setState(() {
      rebuildAllChildren(context);
    });
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Sponsors",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Color.fromRGBO(148, 212, 72, 1),
      ),
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(0),
    );
  }
}
