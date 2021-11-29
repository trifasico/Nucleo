import 'package:flutter/material.dart';
import '../Team/TeamPage.dart';

class ShowTeamPage extends StatefulWidget {
  @override
  _ShowTeamPageState createState() => _ShowTeamPageState();
}

class _ShowTeamPageState extends State<ShowTeamPage> {
  double textSize = 30;

  List<List<String>> p = [
    [
      "Beatriz Isabel Martins Machado",
      "84139",
      "Presidente",
    ],
    [
      "Ana Carolina Coelho Lopes",
      "82562",
      "Vice-Presidente Interno",
    ],
    [
      "Vitor Hugo da Silva Ribeiro",
      "86619",
      "Vice-Presidente Externo",
    ],
    [
      "Tiago Jorge Leite Aston",
      "80541",
      "Tesoureiro",
    ],
    ["Hugo Daniel Vieira de Carvalho", "85156", "Secretário"]
  ];
  List<List<String>> dpa = [
    ["João Alexandre Ferreira Palhares de Carvalho", "83564", "Diretor"],
    ["João Pedro de Oliveira Faria", "85632", "Vice-Diretor"]
  ];
  List<List<String>> dci = [
    ["Daniel Gonçalves da Cunha", "84978", "Diretor"],
    ["Ana Rita Meira Cunha", "88299", "Vice-Diretora"],
  ];
  List<List<String>> dre = [
    [
      "Renata Araújo Fernandes Martins",
      "88244",
      "Diretora",
    ],
    ["Dimitri Emanuel dos Santos", "78006", "Vice-Diretor"],
  ];
  List<List<String>> drds = [
    ["João Pinto", "88230", "Diretor"],
    ["Hugo Manuel de Moura Freitas", "88258", "Vice-Diretor"],
  ];
  List<List<String>> ag = [
    ["João Marcelo Mendes Borges", "80946", "Presidente"],
    ["Marcelo Rodrigues Amaral", "86055", "Vice-Presidente"],
    ["José Paulo Ribeiro Guimarães Mendes", "85951", "Secretário"]
  ];
  List<List<String>> cfj = [
    ["Luiz Cláudio Miranda Alexandre", "86362", "Presidente"],
    ["Margarida Oliveira Correia", "88288", "Vice-Presidente"],
    ["Gabriella Sá", "88222", "Secretária"]
  ];

  void _goPage(List<List<String>> a, String n) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => TeamPage(a, n)),
    );
  }

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
                    'Equipa ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Image.asset(
                    "assets/images/Icon.png",
                    fit: BoxFit.cover,
                    height: 32,
                  ),
                  Icon(
                    Icons.hourglass_empty,
                    color: Color.fromRGBO(255, 102, 51, 1),
                  )
                ],
              )),
            ])),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(20),
                    child: FloatingActionButton.extended(
                        heroTag: null,
                        backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                        onPressed: () => {_goPage(p, "Presidência")},
                        label: Text("Presidência",
                            style: TextStyle(color: Colors.white)))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: FloatingActionButton.extended(
                        heroTag: null,
                        backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                        onPressed: () => {
                              _goPage(dpa,
                                  "Departamento Pedagógico e de Atividades")
                            },
                        label: Text("Departamento Pedagógico e de Atividades",
                            style: TextStyle(color: Colors.white)))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: FloatingActionButton.extended(
                        heroTag: null,
                        backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                        onPressed: () =>
                            {_goPage(dci, "Departamento Comunicação e Imagem")},
                        label: Text("Departamento Comunicação e Imagem",
                            style: TextStyle(color: Colors.white)))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: FloatingActionButton.extended(
                        heroTag: null,
                        backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                        onPressed: () =>
                            {_goPage(dre, "Departamento Relações Externas")},
                        label: Text("Departamento Relações Externas",
                            style: TextStyle(color: Colors.white)))),

                Padding(
                    padding: EdgeInsets.all(10),
                    child: FloatingActionButton.extended(
                        heroTag: null,
                        backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                        onPressed: () => {
                              _goPage(drds,
                                  "Departamento Recreativo, Desportivo e Social")
                            },
                        label: Text(
                            "Departamento Recreativo, Desportivo e Social",
                            style: TextStyle(color: Colors.white)))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: FloatingActionButton.extended(
                        heroTag: null,
                        backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                        onPressed: () => {_goPage(ag, "Assembleia Geral")},
                        label: Text("Assembleia Geral",
                            style: TextStyle(color: Colors.white)))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: FloatingActionButton.extended(
                        heroTag: null,
                        backgroundColor: Color.fromRGBO(255, 102, 51, 1),
                        onPressed: () =>
                            {_goPage(cfj, "Conselho Fiscal e Jurisdicional")},
                        label: Text("Conselho Fiscal e Jurisdicional",
                            style: TextStyle(color: Colors.white)))),
                //   Padding(
                //       padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //       child: Card(
                //           child: Padding(
                //               padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //               child: Align(
                //                   alignment: Alignment.center,
                //                   child: Text("Presidência",
                //                       style: TextStyle(fontSize: textSize)))))),
                //   ListView.builder(
                //       physics: NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemCount: this.p.length, //anuncios.length,
                //       itemBuilder: (context, index) {
                //         var pessoa = this.p[index];
                //         return TeamCard(pessoa);
                //       }),
                //   Padding(
                //       padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //       child: Card(
                //           child: Padding(
                //               padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //               child: Align(
                //                   alignment: Alignment.center,
                //                   child: Text(
                //                       "Departamento Pedagógico e de Atividades",
                //                       style: TextStyle(fontSize: textSize)))))),
                //   ListView.builder(
                //       physics: NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemCount: this.dpa.length, //anuncios.length,
                //       itemBuilder: (context, index) {
                //         var pessoa = this.dpa[index];
                //         return TeamCard(pessoa);
                //       }),
                //   Padding(
                //       padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //       child: Card(
                //           child: Padding(
                //               padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //               child: Align(
                //                   alignment: Alignment.center,
                //                   child: Text("Departamento Comunicação e Imagem",
                //                       style: TextStyle(fontSize: textSize)))))),
                //   ListView.builder(
                //       physics: NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemCount: this.dci.length, //anuncios.length,
                //       itemBuilder: (context, index) {
                //         var pessoa = this.dci[index];
                //         return TeamCard(pessoa);
                //       }),
                //   Padding(
                //       padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //       child: Card(
                //           child: Padding(
                //               padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //               child: Align(
                //                   alignment: Alignment.center,
                //                   child: Text("Departamento Relações Externas",
                //                       style: TextStyle(fontSize: textSize)))))),
                //   ListView.builder(
                //       physics: NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemCount: this.dre.length, //anuncios.length,
                //       itemBuilder: (context, index) {
                //         var pessoa = this.dre[index];
                //         return TeamCard(pessoa);
                //       }),
                //   Padding(
                //       padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //       child: Card(
                //           child: Padding(
                //               padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //               child: Align(
                //                   alignment: Alignment.center,
                //                   child: Align(
                //                       alignment: Alignment.center,
                //                       child: Text(
                //                           "Departamento Recreativo, Desportivo e Social",
                //                           style:
                //                               TextStyle(fontSize: textSize))))))),
                //   ListView.builder(
                //       physics: NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemCount: this.drds.length, //anuncios.length,
                //       itemBuilder: (context, index) {
                //         var pessoa = this.drds[index];
                //         return TeamCard(pessoa);
                //       }),
                //   Padding(
                //       padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //       child: Card(
                //           child: Padding(
                //               padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //               child: Align(
                //                   alignment: Alignment.center,
                //                   child: Text("Assembleia Geral",
                //                       style: TextStyle(fontSize: textSize)))))),
                //   ListView.builder(
                //       physics: NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemCount: this.ag.length, //anuncios.length,
                //       itemBuilder: (context, index) {
                //         var pessoa = this.ag[index];
                //         return TeamCard(pessoa);
                //       }),
                //   Padding(
                //       padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //       child: Card(
                //           child: Padding(
                //               padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                //               child: Align(
                //                   alignment: Alignment.center,
                //                   child: Text("Conselho Fiscal e Jurisdicional",
                //                       style: TextStyle(fontSize: textSize)))))),
                //   ListView.builder(
                //       scrollDirection: Axis.vertical,
                //       physics: NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemCount: this.cfj.length, //anuncios.length,
                //       itemBuilder: (context, index) {
                //         var pessoa = this.cfj[index];
                //         return TeamCard(pessoa);
                //       }),
              ],
            ),
          ),
        ));
  }
}
