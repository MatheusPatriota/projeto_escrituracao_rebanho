import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/categoria/class/categoria.dart';
import 'package:ouvinos_caprinos/categoria/db/categoria_database.dart';
import 'package:ouvinos_caprinos/raca/class/raca.dart';
import 'package:ouvinos_caprinos/raca/db/raca_database.dart';


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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.arrow_drop_down_circle),
        backgroundColor: Colors.green,
      ),
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
                        DataCell(Text("Indetificação")),
                        DataCell(Text(_caprinoSelecionado.idAnimal.toString()))
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Nome")),
                        DataCell(Text(_caprinoSelecionado.nome))
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
