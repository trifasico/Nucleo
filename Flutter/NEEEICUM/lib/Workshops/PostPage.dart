import 'package:flutter/material.dart';
import '../Extras/TextInputWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PostCard.dart';
import '../Extras/coments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PostPage extends StatefulWidget {
  final Post post;

  PostPage(this.post);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<Coments> comments = [];
  List<dynamic> quemvai = [];
  List<dynamic> entrou = [];
  int quantosComments = 0;
  bool inscrito = false;
  bool fechou = false;

  Future getInfo() async {
    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(this.widget.post.number.toString())
        .get()
        .then((value) {
      quantosComments = value.data()["comments"];
      quemvai = value.data()["quemvai"];
      entrou = value.data()["entrou"];
      fechou = value.data()["fechou"];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString('number');
    if (quemvai.contains(number) == true || entrou.contains(number)) {
      prefs.setInt("Vai_" + this.widget.post.number.toString(), 1);
      inscrito = true;
    }

    for (int i = 0; i < quantosComments; i++) {
      String text, author;
      List<dynamic> likesP = [];
      int likes;
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(this.widget.post.number.toString())
          .collection("Comments")
          .doc(i.toString())
          .get()
          .then((value) {
        likes = value.data()["likes"];
        text = value.data()["text"];
        author = value.data()["author"];
        likesP = value.data()["quemgostou"];
      });
      if (likesP == null) {
        likesP = [];
        await FirebaseFirestore.instance
            .collection("Posts")
            .doc(this.widget.post.number.toString())
            .collection("Comments")
            .doc(i.toString())
            .update({"quemgostou": []});
      }
      comments.add(Coments(
        text,
        author,
        likes,
        i,
        this.widget.post.number,
        "Posts",
        likesP.contains(number),
      ));
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  Future _going() async {
    await getInfo();
    setState(() {
      rebuildAllChildren(context);
    });
  }

  void newComment(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String name = prefs.getString('name');
    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(this.widget.post.number.toString())
        .update({"comments": quantosComments + 1});
    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(this.widget.post.number.toString())
        .collection("Comments")
        .doc(quantosComments.toString())
        .set({"author": name, "text": text, "likes": 0, "quemgostou": []});

    comments.add(new Coments(text, name, 0, quantosComments,
        this.widget.post.number, "Posts", false));

    quantosComments += 1;

    this.setState(() {});
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () async {
        Navigator.of(context).pop();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String number = prefs.getString('number');
        prefs.setInt("Vai_" + this.widget.post.number.toString(), 1);
        quemvai.add(number);
        await FirebaseFirestore.instance
            .collection("Posts")
            .doc(this.widget.post.number.toString())
            .update({"quemvai": quemvai});

        comments.clear();
        List<dynamic> postsQUER = [];
        await FirebaseFirestore.instance
            .collection("Logins")
            .doc(number)
            .get()
            .then((value) => postsQUER = value.data()["Posts"]);
        if (postsQUER == null) postsQUER = [];
        postsQUER.add(this.widget.post.number);
        await FirebaseFirestore.instance
            .collection("Logins")
            .doc(number)
            .update({"Posts": postsQUER});
        _going();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Confirmação"),
      content: Text("Tens a certeza que queres ir a palestra?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          this.widget.post.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Color.fromRGBO(255, 102, 51, 1),
      ),
      body: Column(children: <Widget>[
        SizedBox(height: 10),
        Expanded(
            child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: (this.widget.post.imagem != "a")
                            ? Image.network(
                                this.widget.post.imagem,
                                height: (kIsWeb) ? 500 : 350,
                              )
                            : SizedBox()))),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, (kIsWeb) ? 20 : 5),
                child: Text(this.widget.post.text,
                    style: TextStyle(fontSize: 15))),
            Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          !fechou
                              ? FloatingActionButton.extended(
                                  backgroundColor:
                                      Color.fromRGBO(255, 102, 51, 1),
                                  label: Text(
                                      inscrito
                                          ? "Já te encontras inscrito"
                                          : "Confirma aqui a tua participação",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      )),
                                  icon: Icon(Icons.check,
                                      size: inscrito ? 0 : 25,
                                      color: inscrito
                                          ? Colors.black
                                          : Colors.white),
                                  onPressed: () {
                                    if (!inscrito) showAlertDialog(context);
                                  },
                                )
                              : FloatingActionButton.extended(
                                  backgroundColor:
                                      Color.fromRGBO(255, 102, 51, 1),
                                  label: Text("Inscrições fechadas",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      )),
                                  onPressed: () {},
                                ),
                        ]))),
            ComentsList(this.comments),
          ],
        )),
        TextInputWidget(this.newComment),
      ]),
    );
  }
}

/*
                            Text(
                                inscrito
                                    ? "Já te encontras inscrito"
                                    : "Confirma aqui a tua participação",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                )),
                            inscrito
                                ? Text(" ")
                                : IconButton(
                                    icon: Icon(Icons.check,
                                        size: inscrito ? 0 : 25,
                                        color: inscrito
                                            ? Colors.white
                                            : Colors.black),
                                    onPressed: () {
                                      if (!inscrito) showAlertDialog(context);
                                    },
                                  ),
                                  */
