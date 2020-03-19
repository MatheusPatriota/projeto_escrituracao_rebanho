import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
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
      _observacaoCriada.data = _dataFormatada(_dataSelecionada);
    }else{
      _observacaoCriada = Observacao.fromMap(widget.observacao.toMap());
      _selectedObservacao.text = _observacaoCriada.descricao;
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
            espacamentoPadrao(),
            TextField(
              decoration: estiloPadrao("Observação*", 1),
              controller: _selectedObservacao,
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
