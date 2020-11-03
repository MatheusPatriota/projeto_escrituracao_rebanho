import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ovinos_caprinos/animal/db/animal_database.dart';
import 'package:ovinos_caprinos/pesagem/class/pesagem.dart';
import 'package:ovinos_caprinos/pesagem/db/pesagem_database.dart';
import 'package:ovinos_caprinos/util/funcoes.dart';

class PesagemPage extends StatefulWidget {
  final Pesagem peso;
  final animalId;
  PesagemPage({this.peso, this.animalId});

  @override
  _PesagemPageState createState() => _PesagemPageState();
}

class _PesagemPageState extends State<PesagemPage> {
  final _selectedPeso = TextEditingController();

  Pesagem _pesoCadastrado;

  DateTime _dataSelecionada = DateTime.now();

  AnimalHelper animalHelper = AnimalHelper();
  PesagemHelper pesagemHelper = PesagemHelper();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.peso == null) {
      _pesoCadastrado = Pesagem(animalId: widget.animalId);
      _pesoCadastrado.data = dataFormatada(_dataSelecionada);
    } else {
      _pesoCadastrado = Pesagem.fromMap(widget.peso.toMap());
      _selectedPeso.text = _pesoCadastrado.peso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Registrar Pesagem"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Navigator.pop(context, _pesoCadastrado);
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
              child: Text("Data de Pesagem*"),
              padding: EdgeInsets.only(top: 10.0),
            ),
            RaisedButton(
              child: Text(exibicaoDataPadrao(dataFormatada(_dataSelecionada))),
              onPressed: () async {
                DateTime _dataComparativa =
                    await selectDate(context, _dataSelecionada);
                if (_dataComparativa.compareTo(_dataSelecionada) > 0) {
                  showAlert(context, _dataSelecionada, "Pesagem");
                } else {
                  setState(() {
                    _dataSelecionada = _dataComparativa;
                    _pesoCadastrado.data = dataFormatada(_dataSelecionada);
                  });
                }
              },
            ),
            espacamentoPadrao(),
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: estiloPadrao("Peso(KG)*", 1),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor, insira o Peso';
                }
                return null;
              },
              controller: _selectedPeso,
              onChanged: (text) {
                setState(() {
                  _pesoCadastrado.peso = text;
                });
              },
            ),
          ]),
        ),
      ),
    );
  }
}
