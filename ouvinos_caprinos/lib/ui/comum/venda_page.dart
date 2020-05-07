import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
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

  var _selectedValorVenda = MoneyMaskedTextController();
  final _selectedVendendor = TextEditingController();
  final _selectedAnotacoes = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animalSelecionado = Animal.fromMap(widget.animalVenda.toMap());
    if (widget.animalVenda.status == "1") {
      _selectedValorVenda.text = _animalSelecionado.valorVenda;
      _selectedVendendor.text =
          _animalSelecionado.nomeVendedor ?? "Nome do Vendendor não Informado";
      _selectedAnotacoes.text =
          _animalSelecionado.anotacoesVenda ?? "Não possui anotações";
    } else {
      _animalSelecionado.dataVendaAnimal = _dataFormatada();
    }
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
                });
              },
            ),
            espacamentoPadrao(),
            TextFormField(
              controller: _selectedValorVenda,
              decoration: estiloPadrao("Valor da Venda*", 2),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor, insira o valor da venda';
                }
                return null;
              },
              onChanged: (text) {
                setState(() {
                  _animalSelecionado.valorVenda = text;
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
              controller: _selectedVendendor,
              onChanged: (text) {
                setState(() {
                  _animalSelecionado.nomeComprador = text;
                });
              },
            ),
            espacamentoPadrao(),
            TextField(
              decoration: estiloPadrao("Anotações", 1),
              controller: _selectedAnotacoes,
              onChanged: (text) {
                setState(() {
                  _animalSelecionado.anotacoesVenda = text;
                });
              },
            ),
          ]),
        ),
      ),
    );
  }
}
