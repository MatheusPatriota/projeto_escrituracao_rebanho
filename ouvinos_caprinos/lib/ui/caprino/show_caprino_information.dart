import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';


class CaprinoInformation extends StatefulWidget {
  final Animal caprino;

  CaprinoInformation({this.caprino});

  @override
  _CaprinoInformationState createState() => _CaprinoInformationState();
}

class _CaprinoInformationState extends State<CaprinoInformation> {
  Animal _caprinoSelecionado;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _caprinoSelecionado = Animal.fromMap(widget.caprino.toMap());
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
                        // DataCell(Text(_caprinoSelecionado.idategoria))
                      ]),
                      DataRow(cells: [
                        DataCell(Text("Raça")),
                        // DataCell(Text(_caprinoSelecionado.raca))
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
