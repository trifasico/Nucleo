import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Kits/KitCard.dart';
import '../Kits/KitPage.dart';
import '../Workshops/PostCard.dart';
import '../Workshops/PostPage.dart';

class InscritoWidget extends StatefulWidget {
  @override
  _InscritoWidgetState createState() => _InscritoWidgetState();
}

class _InscritoWidgetState extends State<InscritoWidget> {
  var iKits = {};
  List<dynamic> iPosts = [];
  List<Kit> inscritoKits = [];
  List<Post> inscritoPosts = [];

  List<Widget> _widgetOptions = <Widget>[];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("number");
  }

  Future getValuesInscritoPosts() async {
    String text, title, hora, data, imagem;
    String number = await getName();
    await FirebaseFirestore.instance
        .collection("Logins")
        .doc(number)
        .get()
        .then((value) {
      iPosts = value.data()["Posts"];
    });
    if (iPosts == null) iPosts = [];
    for (int i = 0; i < iPosts.length; i++) {
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(iPosts[i].toString())
          .get()
          .then((value) {
        text = value.data()["text"];
        title = value.data()["title"];
        data = value.data()["date"];
        hora = value.data()["hour"];
        imagem = value.data()["image"];
      });
      inscritoPosts.add(Post(
        text: text,
        title: title,
        hora: hora,
        data: data,
        imagem: imagem,
        number: i,
      ));
    }
    setState(() {});
  }

  Future getValuesInscritoKits() async {
    String text, title, hora, data, imagem;
    String number = await getName();
    List<int> quantosKits = [];
    await FirebaseFirestore.instance
        .collection("Logins")
        .doc(number)
        .get()
        .then((value) {
      iKits = value.data()["Kits"];
    });
    for (int i = 0; i < 100; i++) {
      if (iKits.containsKey(i.toString())) quantosKits.add(i);
    }

    for (int i = 0; i < quantosKits.length; i++) {
      await FirebaseFirestore.instance
          .collection("Kits")
          .doc(quantosKits[i].toString())
          .get()
          .then((value) {
        text = value.data()["text"];
        title = value.data()["title"];
        data = value.data()["date"];
        hora = value.data()["hour"];
        imagem = value.data()["image"];
      });
      inscritoKits.add(Kit(
        text: text,
        title: title,
        hora: hora,
        data: data,
        imagem: imagem,
        number: i,
      ));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _widgetOptions.add(FutureBuilder(
        future: getValuesInscritoPosts(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return (inscritoPosts.length != 0)
                ? ListView.builder(
                    itemCount: this.inscritoPosts.length, //anuncios.length,
                    itemBuilder: (context, index) {
                      var post = this.inscritoPosts[index];
                      return PostCard(
                          anuncio: post,
                          more: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PostPage(post),
                                  ));
                            });
                          });
                    })
                : Center(
                    child: Text(
                        "Ainda não te inscreveste em nenhum WorkShop/Palestra"));
          }
        }));

    _widgetOptions.add(FutureBuilder(
        future: getValuesInscritoKits(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return (inscritoKits.length != 0)
                ? ListView.builder(
                    itemCount: this.inscritoKits.length, //anuncios.length,
                    itemBuilder: (context, index) {
                      var kit = this.inscritoKits[index];
                      return KitCard(
                          kit: kit,
                          more: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        KitPage(kit),
                                  ));
                            });
                          });
                    })
                : Center(child: Text("Ainda não pediste nenhum Kit"));
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(121212),
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Inscrito',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Image.asset(
              "assets/images/IconNEEEICUM.png",
              fit: BoxFit.cover,
              height: 32,
            ),
            Text(
              '         ',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 102, 51, 1),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Color(121212),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "WorkShops",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: "Kits",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(255, 102, 51, 1),
        selectedIconTheme: IconThemeData(
          color: Color.fromRGBO(255, 102, 51, 1),
        ),
        onTap: _onItemTapped,
      ),
    );
  }
}
