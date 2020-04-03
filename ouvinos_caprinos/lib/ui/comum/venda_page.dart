import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';

class VendaPage extends StatefulWidget {
  final Animal animalVenda;

  VendaPage({this.animalVenda});

  @override
  _VendaPageState createState() => _VendaPageState();
}

class _VendaPageState extends State<VendaPage> {
  Animal _animalSelecionado;

  DateTime _dataSelecionada = DateTime.now();

  AnimalHelper animalHelper = AnimalHelper();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _animalSelecionado = Animal.fromMap(widget.animalVenda.toMap());
    _animalSelecionado.dataVendaAnimal = _dataFormatada();
  }

  String _dataFormatada() {
    String dia = "${_dataSelecionada.day}";
    String nd = "";
    String mes = "${_dataSelecionada.month}";
    String nm = "";
    if (dia.length < 2) {
      nd = "0" + dia;
    } else {
      nd = dia;
    }
    if (mes.length < 2) {
      nm = "0" + mes;
    } else {
      nm = mes;
    }
    return "${_dataSelecionada.year}-" + nm + "-" + nd;
  }

  Future<Null> _selectDataPesagem(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: new DateTime(1900),
      lastDate: new DateTime(2100),
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
        _animalSelecionado.dataVendaAnimal = _dataFormatada();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Registrar Venda"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _animalSelecionado.status = "1";
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
              child: Text("Data da Venda*"),
              padding: EdgeInsets.only(top: 10.0),
            ),
            RaisedButton(
              child: Text(exibicaoDataPadrao(_dataFormatada())),
              onPressed: () {
                _selectDataPesagem(context);
                setState(() {
                  _animalSelecionado.dataVendaAnimal = _dataFormatada();
                  // _userEdited = true;
                  // _editedAnimal.dataNascimento = _dataNascimentoFormatada;
                });
              },
            ),
            espacamentoPadrao(),
            TextFormField(
              decoration: estiloPadrao("Valor da Venda*", 2),
              // controller: _selectedNome,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor, insira o valor da venda';
                }
                return null;
              },
              onChanged: (text) {
                setState(() {
                  _animalSelecionado.valorVenda = text;
                  // _userEdited = true;
                  // _editedAnimal.nome = text;
                });
              },
            ),
            espacamentoPadrao(),
            TextFormField(
              decoration: estiloPadrao("Comprador*", 1),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor, insira a o nome do Comprador';
                }
                return null;
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              // controller: _selectedNome,]
              onChanged: (text) {
                setState(() {
                  _animalSelecionado.nomeComprador = text;
                  // _userEdited = true;
                  // _editedAnimal.nome = text;
                });
              },
            ),
            espacamentoPadrao(),
            TextField(
              decoration: estiloPadrao("Anotações", 1),
              // controller: _selectedNome,
              onChanged: (text) {
                setState(() {
                  _animalSelecionado.anotacoesVenda = text;
                  // _userEdited = true;
                  // _editedAnimal.nome = text;
                });
              },
            ),
          ]),
        ),
      ),
    );
  }
}
