import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';
import 'package:ouvinos_caprinos/categoria/class/categoria.dart';
import 'package:ouvinos_caprinos/categoria/db/categoria_database.dart';
import 'package:ouvinos_caprinos/observacao/class/observacao.dart';
import 'package:ouvinos_caprinos/observacao/db/observacao_database.dart';
import 'package:ouvinos_caprinos/pesagem/class/pesagem.dart';
import 'package:ouvinos_caprinos/pesagem/db/pesagem_database.dart';
import 'package:ouvinos_caprinos/raca/class/raca.dart';
import 'package:ouvinos_caprinos/raca/db/raca_database.dart';
import 'package:ouvinos_caprinos/tratamento/class/tratamento.dart';
import 'package:ouvinos_caprinos/tratamento/db/tratamento_database.dart';
import 'package:ouvinos_caprinos/ui/comum/morte_page.dart';
import 'package:ouvinos_caprinos/ui/comum/observacao_page.dart';
import 'package:ouvinos_caprinos/ui/comum/pesagem_page.dart';
import 'package:ouvinos_caprinos/ui/comum/tratamento_page.dart';
import 'package:ouvinos_caprinos/ui/comum/venda_page.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';

class CaprinoInformation extends StatefulWidget {
  final Animal caprino;

  CaprinoInformation({this.caprino});

  @override
  _CaprinoInformationState createState() => _CaprinoInformationState();
}

class _CaprinoInformationState extends State<CaprinoInformation> {
  Animal _caprinoSelecionado;

  AnimalHelper animalHelper = AnimalHelper();
  CategoriaHelper categoriaHelper = CategoriaHelper();
  RacaHelper racaHelper = RacaHelper();

  // variaveis para acessor os dbs dos eventos
  TratamentoHelper tratamentoHelper = TratamentoHelper();
  ObservacaoHelper observacaoHelper = ObservacaoHelper();
  PesagemHelper pesagemHelper = PesagemHelper();

  List<Categoria> categorias = List();
  List<Raca> racas = List();

  //listas de eventos
  List<Tratamento> tratamentos = List();
  List<Observacao> observacoes = List();
  List<Pesagem> pesos = List();

  List<String> _dataComSplit;

  Future<void> _getAllCategorias() async {
    await categoriaHelper.getAllCategorias().then((listaC) {
      print(listaC);
      print(_caprinoSelecionado);

      setState(() {
        categorias = listaC;
      });
    });
  }

  Future<void> _getAllRacas() async {
    await racaHelper.getAllRacas().then((listaR) {
      print(listaR);

      setState(() {
        racas = listaR;
      });
    });
  }

  Future<void> _getAllTratamentos() async {
    List<Tratamento> tratamentosFinal = List();
    await tratamentoHelper.getAllTratamentos().then((listaT) {
      if (listaT.isNotEmpty) {
        for (var tratamento in listaT) {
          if (tratamento.animalId == _caprinoSelecionado.idAnimal) {
            tratamentosFinal.add(tratamento);
          }
        }
        print(listaT);
        setState(() {
          tratamentos = tratamentosFinal;
        });
      }
    });
  }

  Future<void> _getAllObservacoes() async {
    List<Observacao> observacoesFinal = List();
    await observacaoHelper.getAllObservacaos().then((listaO) {
      if (listaO.isNotEmpty) {
        for (var observacao in listaO) {
          if (observacao.animalId == _caprinoSelecionado.idAnimal) {
            observacoesFinal.add(observacao);
          }
        }

        setState(() {
          observacoes = observacoesFinal;
        });
      }
    });
  }

  Future<void> _getAllPesagens() async {
    List<Pesagem> pesagemFinal = List();
    await pesagemHelper.getAllPesagems().then((listaP) {
      print(listaP);
      if (listaP.isNotEmpty) {
        for (var peso in listaP) {
          if (peso.animalId == _caprinoSelecionado.idAnimal) {
            pesagemFinal.add(peso);
          }
        }
        print(pesagemFinal);
        setState(() {
          pesos = pesagemFinal;
        });
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _caprinoSelecionado = Animal.fromMap(widget.caprino.toMap());
    _dataComSplit = _caprinoSelecionado.dataNascimento.split("/");
    _getAllCategorias();
    _getAllRacas();
    _getAllTratamentos();
    _getAllObservacoes();
    _getAllPesagens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Informações Sobre Caprino"),
        centerTitle: true,
      ),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(MdiIcons.needle),
            backgroundColor: Colors.green,
            label: 'Tratamento',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              final recTratamento = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TratamentoPage(
                            animalTratamento: _caprinoSelecionado,
                          )));
              if (recTratamento != null) {
                if (_caprinoSelecionado != null) {
                  tratamentoHelper.saveTratamento(recTratamento);
                  _getAllTratamentos();
                }
              }
            },
          ),
          SpeedDialChild(
            child: Icon(MdiIcons.weightKilogram),
            backgroundColor: Colors.green,
            label: 'Pesagem',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              final recPesagem = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PesagemPage(
                            animalPesagem: _caprinoSelecionado,
                          )));
              if (recPesagem != null) {
                if (_caprinoSelecionado != null) {
                  pesagemHelper.savePesagem(recPesagem);
                  _getAllPesagens();
                }
              }
            },
          ),
          SpeedDialChild(
            child: Icon(MdiIcons.cashUsd),
            backgroundColor: Colors.green,
            label: 'Venda',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              final recAnimal = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VendaPage(
                            animalVenda: _caprinoSelecionado,
                          )));
              if (recAnimal != null) {
                print(recAnimal);
                if (_caprinoSelecionado != null) {
                  await animalHelper.updateAnimal(recAnimal);
                }
              }
            },
          ),
          SpeedDialChild(
            child: Icon(MdiIcons.skullCrossbones),
            backgroundColor: Colors.green,
            label: 'Morte',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              final recAnimal = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MortePage(
                            animalMorte: _caprinoSelecionado,
                          )));
              if (recAnimal != null) {
                if (_caprinoSelecionado != null) {
                  animalHelper.updateAnimal(recAnimal);
                }
              }
            },
          ),
          SpeedDialChild(
            child: Icon(MdiIcons.alert),
            backgroundColor: Colors.green,
            label: 'Observações',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              final recObservacao = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ObservacaoPage(
                            animalObservacao: _caprinoSelecionado,
                          )));
              if (recObservacao != null) {
                if (_caprinoSelecionado != null) {
                  observacaoHelper.saveObservacao(recObservacao);
                  _getAllObservacoes();
                }
              }
            },
          ),
        ],
      ),
      //  FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.arrow_drop_down_circle),
      //   backgroundColor: Colors.green,
      // ),
      body: Form(
        key: _formKey,
        child: new Container(
          padding: EdgeInsets.all(13.0),
          child: ListView(
            children: [
              Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _caprinoSelecionado.img != null
                                ? FileImage(File(_caprinoSelecionado.img))
                                : AssetImage("images/caprino.png"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text("Patrimônio")),
                        DataCell(Text(ehvazio(_caprinoSelecionado.patrimonio)))
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Brinco")),
                        DataCell(
                            Text(ehvazio(_caprinoSelecionado.brincoControle)))
                      ]),
                      DataRow(cells: [
                        DataCell(Text("ID")),
                        DataCell(Text(_caprinoSelecionado.idAnimal.toString()))
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Idade")),
                        DataCell(
                          Text(
                            idadeAnimal(_dataComSplit[2], _dataComSplit[1]),
                          ),
                        ),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Nome")),
                        DataCell(Text(ehvazio(_caprinoSelecionado.nome)))
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Sexo")),
                        DataCell(Text(_caprinoSelecionado.sexo))
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Categoria")),
                        DataCell(Text(
                            categorias[_caprinoSelecionado.idCategoria]
                                    .descricao ??
                                ""))
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Raça")),
                        DataCell(Text(
                            racas[_caprinoSelecionado.idRaca].descricao ?? ""))
                      ]),
                    ],
                  ),
                  DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: listaEventos(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DataRow> listaEventos() {
    List<DataRow> lista = [];
    //data nascimento

    lista.add(DataRow(cells: [
      DataCell(Icon(MdiIcons.cake)),
      DataCell(Text(_caprinoSelecionado.dataNascimento)),
      DataCell(Text("Nascimento")),
    ]));

    // pesagem
    if (pesos.isNotEmpty) {
      for (var peso in pesos) {
        lista.add(DataRow(cells: [
          DataCell(Icon(MdiIcons.weightKilogram)),
          DataCell(Text(peso.data)),
          DataCell(Text(peso.peso + "KG"))
        ]));
      }
    }

    // morte
    if (_caprinoSelecionado.status == "2") {
      lista.add(DataRow(cells: [
        DataCell(Icon(MdiIcons.skullCrossbones)),
        DataCell(Text(_caprinoSelecionado.dataMorte)),
        DataCell(Text(_caprinoSelecionado.descricaoMorte))
      ]));
    }
    // tratamento
    if (tratamentos.isNotEmpty) {
      for (var tratamento in tratamentos) {
        lista.add(DataRow(cells: [
          DataCell(Icon(MdiIcons.needle)),
          DataCell(Text(tratamento.data)),
          DataCell(Text(tratamento.medicacao))
        ]));
      }
    }

    //venda
    if (_caprinoSelecionado.status == "1") {
      lista.add(DataRow(cells: [
        DataCell(Icon(MdiIcons.cashUsd)),
        DataCell(Text(_caprinoSelecionado.dataVendaAnimal)),
        DataCell(Text(_caprinoSelecionado.valorVenda))
      ]));
    }
    //observacoes
    if (observacoes.isNotEmpty) {
      for (var observacao in observacoes) {
        lista.add(DataRow(cells: [
          DataCell(Icon(MdiIcons.alert)),
          DataCell(Text(observacao.data)),
          DataCell(Text(observacao.descricao))
        ]));
      }
    }

    return lista;
  }
}
