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
      _observacaoCriada.data = dataFormatada(_dataSelecionada);
    } else {
      _observacaoCriada = Observacao.fromMap(widget.observacao.toMap());
      _selectedObservacao.text = _observacaoCriada.descricao;
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
              child: Text(exibicaoDataPadrao(dataFormatada(_dataSelecionada))),
              onPressed: () async {
                _dataSelecionada = await selectDate(context, _dataSelecionada);
                setState(() {
                  setState(() {
                    _observacaoCriada.data = dataFormatada(_dataSelecionada);
                  });
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
