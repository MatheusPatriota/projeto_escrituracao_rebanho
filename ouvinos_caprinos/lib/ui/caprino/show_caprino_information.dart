import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/categoria/class/categoria.dart';
import 'package:ouvinos_caprinos/categoria/db/categoria_database.dart';
import 'package:ouvinos_caprinos/raca/class/raca.dart';
import 'package:ouvinos_caprinos/raca/db/raca_database.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';


class CaprinoInformation extends StatefulWidget {
  final Animal caprino;

  CaprinoInformation({this.caprino});

  @override
  _CaprinoInformationState createState() => _CaprinoInformationState();
}

class _CaprinoInformationState extends State<CaprinoInformation> {
  Animal _caprinoSelecionado;

  CategoriaHelper categoriaHelper = CategoriaHelper();
  RacaHelper racaHelper = RacaHelper();

  List<Categoria> categorias = List();
  List<Raca> racas = List();

  Future<void> _getAllCategorias() async{
    await categoriaHelper.getAllCategorias().then((listaC){
      print(listaC);
     

      setState(() {
        categorias = listaC;
      });
    });
  }

Future<void> _getAllRacas() async{
    await racaHelper.getAllRacas().then((listaR){
      print(listaR);
      
      setState(() {
        racas = listaR;
      });
    });
  }


  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _caprinoSelecionado = Animal.fromMap(widget.caprino.toMap());
    _getAllCategorias();
    _getAllRacas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Informações Sobre " + _caprinoSelecionado.nome),
        centerTitle: true,
      ),
      floatingActionButton:  SpeedDial(
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
              onTap: () => print('FIRST CHILD')
            ),
            SpeedDialChild(
              child: Icon(MdiIcons.weightKilogram),
              backgroundColor: Colors.green,
              label: 'Pesagem',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('SECOND CHILD'),
            ),
            SpeedDialChild(
              child: Icon(MdiIcons.cashUsd),
              backgroundColor: Colors.green,
              label: 'Venda',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('THIRD CHILD'),
            ),
            SpeedDialChild(
              child: Icon(MdiIcons.skullCrossbones),
              backgroundColor: Colors.green,
              label: 'Morte',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('FOUR CHILD'),
            ),
            SpeedDialChild(
              child: Icon(MdiIcons.alert),
              backgroundColor: Colors.green,
              label: 'Observações',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('FIVE CHILD'),
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
                        DataCell(Text(ehvazio(_caprinoSelecionado.brincoControle)))
                      ]),
                      DataRow(cells: [
                        DataCell(Text("ID")),
                        DataCell(Text(_caprinoSelecionado.idAnimal.toString()))
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Idade")),
                        DataCell(Text(idadeAnimal(slice(_caprinoSelecionado.dataNascimento,5), slice(_caprinoSelecionado.dataNascimento,3,4))))
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
                        DataCell(Text(categorias[_caprinoSelecionado.idCategoria].descricao))
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Raça")),
                        DataCell(Text(racas[_caprinoSelecionado.idRaca].descricao))
                      ]),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
