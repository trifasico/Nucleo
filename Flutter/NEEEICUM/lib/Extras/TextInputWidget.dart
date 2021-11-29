import 'package:flutter/material.dart';

class TextInputWidget extends StatefulWidget {
  final Function(String) callback;

  TextInputWidget(this.callback);

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final controller = TextEditingController(); //

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void click() {
    FocusScope.of(context).unfocus();
    widget.callback(controller.text); //Mandei o text escrito para tras
    controller.clear(); //limpo aquilo que esta escrito
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        controller: this.controller,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.message),
            labelText: "Alguma dúvida? Deixa-a aqui!",
            suffixIcon: IconButton(
                icon: Icon(Icons.send),
                splashColor: Colors.blue,
                tooltip: "Post Message",
                onPressed: () => {print(this.controller.text), if(this.controller.text != "") this.click()})),
      ),
    ]);
  }
}
