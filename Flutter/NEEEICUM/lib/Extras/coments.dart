import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Coments {
  String body;
  String author;
  int likes = 0;
  int comnetNumber;
  int postNumber;
  bool userLiked = false;
  String what = "Kits";
  List<dynamic> likesP = [];

  Coments(this.body, this.author, this.likes, this.comnetNumber,
      this.postNumber, this.what, this.userLiked);

  Future likePost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString('number');
    await FirebaseFirestore.instance
        .collection(this.what)
        .doc(this.postNumber.toString())
        .collection("Comments")
        .doc(this.comnetNumber.toString())
        .get()
        .then((value) => likesP = value.data()["quemgostou"]);
    await FirebaseFirestore.instance
        .collection(this.what)
        .doc(this.postNumber.toString())
        .collection("Comments")
        .doc(this.comnetNumber.toString())
        .get()
        .then((value) {
      this.likes = value.data()["likes"];
    });
    this.userLiked = !this.userLiked;
    if (this.userLiked) {
      this.likes += 1;
      likesP.add(number);
    } else {
      this.likes -= 1;
      likesP.remove(number);
    }
    await FirebaseFirestore.instance
        .collection(this.what)
        .doc(this.postNumber.toString())
        .collection("Comments")
        .doc(this.comnetNumber.toString())
        .update({"likes": this.likes});
    await FirebaseFirestore.instance
        .collection(this.what)
        .doc(this.postNumber.toString())
        .collection("Comments")
        .doc(this.comnetNumber.toString())
        .update({"quemgostou": likesP});
  }
}

class ComentsList extends StatefulWidget {
  final List<Coments> listItems;

  ComentsList(this.listItems);

  @override
  _ComentsListState createState() => _ComentsListState();
}

class _ComentsListState extends State<ComentsList> {
  void like(Function callback) async {
    await callback();
    setState(() {});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index) {
        var post = this.widget.listItems[index];
        return Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Card(
                child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 4, 0, 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                                  child: Text(post.body,
                                      style: TextStyle(fontSize: 17))),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                  child: Text(post.author,
                                      style: TextStyle(fontSize: 10))),
                            ],
                          ))),
                  Row(
                    children: <Widget>[
                      Container(
                          child: Text(
                            post.likes.toString(),
                            style: TextStyle(fontSize: 17),
                          ),
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      IconButton(
                        icon: Icon(Icons.thumb_up),
                        onPressed: () async {
                          await post.likePost();
                          setState(() {});
                        },
                        color: post.userLiked ? Colors.blue : Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            )));
      },
    );
  }
}
