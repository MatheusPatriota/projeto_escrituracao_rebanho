import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';
import 'package:ouvinos_caprinos/observacao/class/observacao.dart';

class ObservacaoPage extends StatefulWidget {
  final Animal animalObservacao;

  ObservacaoPage({this.animalObservacao});

  @override
  _ObservacaoPageState createState() => _ObservacaoPageState();
}

class _ObservacaoPageState extends State<ObservacaoPage> {
  Animal _animalSelecionado;
  Observacao _observacaoCriada;

  DateTime _dataSelecionada = DateTime.now();

  AnimalHelper animalHelper = AnimalHelper();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _animalSelecionado = Animal.fromMap(widget.animalObservacao.toMap());

    if (_observacaoCriada == null) {
      _observacaoCriada = Observacao(animalId: _animalSelecionado.idAnimal);
      _observacaoCriada.data = _dataFormatada(_dataSelecionada);
    }
  }

  String _dataFormatada(data) {
    return "${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}";
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
        _observacaoCriada.data = _dataFormatada(picked);
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
          Navigator.pop(context, _observacaoCriada);
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
              child: Text(_dataFormatada(_dataSelecionada)),
              onPressed: () {
                _selectDataPesagem(context);
                setState(() {
                  // _userEdited = true;
                  // _editedAnimal.dataNascimento = _dataNascimentoFormatada;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Observação"),
              // controller: _selectedNome,
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
