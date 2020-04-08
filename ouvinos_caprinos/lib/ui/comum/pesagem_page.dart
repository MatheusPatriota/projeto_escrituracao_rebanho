import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';
import 'package:ouvinos_caprinos/pesagem/class/pesagem.dart';
import 'package:ouvinos_caprinos/pesagem/db/pesagem_database.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';

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

  //  essa funcao eh uma possivel fatoracao de codigo
  
  Future<Null> _selectDataPesagem(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: new DateTime(1900),
      lastDate: new DateTime(2100),
    );
    if (picked.compareTo(_dataSelecionada) > 0) {
      _showAlert();
    } else if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
        _pesoCadastrado.data = dataFormatada(picked);
      });
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
              onPressed: () {
                _selectDataPesagem(context);
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

  // alerta para caso o usuario tente cadastra uma pesgem futura(nao permitido)
  void _showAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Você não pode cadastrar uma pesagem futura!"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                  _selectDataPesagem(context);
                },
              ),
            ],
          );
        });
  }
}
