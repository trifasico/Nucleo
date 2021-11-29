import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'InformacoesMain.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InfoIndividual extends StatefulWidget {
  final Informacoes info;

  InfoIndividual(this.info);

  @override
  _InfoIndividualState createState() => _InfoIndividualState();
}

class _InfoIndividualState extends State<InfoIndividual> {
  @override
  YoutubePlayerController _controller;
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: this.widget.info.url,
      flags:
          YoutubePlayerFlags(autoPlay: true, mute: false, disableDragSeek: true
              //hideControls: true,
              ),
    )..addListener(() {
        if (_controller.value.isFullScreen) _controller..toggleFullScreenMode();
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
        backgroundColor: Color.fromRGBO(148, 212, 72, 1),
        centerTitle: true,
        title: Text(
          this.widget.info.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
      body: Column(children: <Widget>[
        SizedBox(height: 10),
        Expanded(
            child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
                child: (this.widget.info.imagem != "a")
                    ? Card(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Image.network(
                              this.widget.info.imagem,
                              width: 500,
                            )))
                    : SizedBox()),
            Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
                child: (this.widget.info.url != "a")
                    ? Card(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: YoutubePlayerBuilder(
                                player: YoutubePlayer(
                                  controller: _controller,
                                ),
                                builder: (context, player) {
                                  return Column(
                                    children: [
                                      // some widgets
                                      player,
                                      //some other widgets
                                    ],
                                  );
                                })))
                    : SizedBox()),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Text(this.widget.info.text,
                    style: TextStyle(fontSize: 15))),
          ],
        )),
      ]),
    );
  }
}
