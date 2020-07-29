import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';

class ExclusaoPage extends StatefulWidget {
  final Animal animalExcluido;

  ExclusaoPage({this.animalExcluido});

  @override
  _ExclusaoPageState createState() => _ExclusaoPageState();
}

class _ExclusaoPageState extends State<ExclusaoPage> {
  Animal _animalSelecionado;

  DateTime _dataSelecionada = DateTime.now();

  AnimalHelper animalHelper = AnimalHelper();

  final _motivoMorte = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _animalSelecionado = Animal.fromMap(widget.animalExcluido.toMap());
    _animalSelecionado.dataRemocao = dataFormatada(_dataSelecionada);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Registrar Remoção"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Navigator.pop(context, _animalSelecionado);
          }
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(13.0),
          child: ListView(children: [
            Container(
              child: Text("Data da Remoção*"),
              padding: EdgeInsets.only(top: 10.0),
            ),
            RaisedButton(
              child: Text(exibicaoDataPadrao(dataFormatada(_dataSelecionada))),
              onPressed: () async {
                _dataSelecionada = await selectDate(context, _dataSelecionada);

                setState(() {
                  _animalSelecionado.dataRemocao =
                      dataFormatada(_dataSelecionada);
                });
              },
            ),
            espacamentoPadrao(),
            TextFormField(
              decoration: estiloPadrao("Motivo da Remoção*", 1),
              controller: _motivoMorte,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor, insira o motivo da remoção';
                }
                return null;
              },
              onChanged: (text) {
                setState(() {
                  _animalSelecionado.motivoRemocao = text;
                  _animalSelecionado.status = "3";
                });
              },
            ),
          ]),
        ),
      ),
    );
  }
}
