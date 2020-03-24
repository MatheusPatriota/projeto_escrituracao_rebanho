import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';
import 'package:ouvinos_caprinos/observacao/class/observacao.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';

class ObservacaoPage extends StatefulWidget {
  final Observacao observacao;
  final int animalId;

  ObservacaoPage({this.observacao, this.animalId});

  @override
  _ObservacaoPageState createState() => _ObservacaoPageState();
}

class _ObservacaoPageState extends State<ObservacaoPage> {
  Observacao _observacaoCriada;

  DateTime _dataSelecionada = DateTime.now();

  AnimalHelper animalHelper = AnimalHelper();

  final _formKey = GlobalKey<FormState>();

  final _selectedObservacao = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.observacao == null) {
      _observacaoCriada = Observacao(animalId: widget.animalId);
      _observacaoCriada.data = _dataFormatada();
    } else {
      _observacaoCriada = Observacao.fromMap(widget.observacao.toMap());
      _selectedObservacao.text = _observacaoCriada.descricao;
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
        _observacaoCriada.data = _dataFormatada();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Registrar Observação"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {       
            Navigator.pop(context, _observacaoCriada);
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
              child: Text("Data da Observação"),
              padding: EdgeInsets.only(top: 10.0),
            ),
            RaisedButton(
              child: exibicaoDataPadrao(_dataFormatada()),
              onPressed: () {
                _selectDataPesagem(context);
                setState(() {
                  // _userEdited = true;
                  // _editedAnimal.dataNascimento = _dataNascimentoFormatada;
                });
              },
            ),
            espacamentoPadrao(),
            TextFormField(
              decoration: estiloPadrao("Observação*", 1),
              controller: _selectedObservacao,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor, insira a observação';
                }
                return null;
              },
              onChanged: (text) {
                setState(() {
                  _observacaoCriada.descricao = text;
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
