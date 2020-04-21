import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';
import 'package:ouvinos_caprinos/ordenha/class/ordenha.dart';
import 'package:ouvinos_caprinos/ordenha/db/ordenha_database.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';

class OrdenhaPage extends StatefulWidget {
  final Ordenha ordenha;
  final animalId;
  OrdenhaPage({this.ordenha, this.animalId});

  @override
  _OrdenhaPageState createState() => _OrdenhaPageState();
}

class _OrdenhaPageState extends State<OrdenhaPage> {
  final _selectedPeso = TextEditingController();

  Ordenha _ordenhaCadastrada;

  DateTime _dataSelecionada = DateTime.now();

  AnimalHelper animalHelper = AnimalHelper();
  OrdenhaHelper pesagemHelper = OrdenhaHelper();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.ordenha == null) {
      _ordenhaCadastrada = Ordenha(animalId: widget.animalId);
      _ordenhaCadastrada.data = dataFormatada(_dataSelecionada);
    } else {
      _ordenhaCadastrada = Ordenha.fromMap(widget.ordenha.toMap());
      _selectedPeso.text = _ordenhaCadastrada.peso;
    }
  }

  //  essa funcao eh uma possivel fatoracao de codigo
  
  Future<Null> _selectDataOrdenha(BuildContext context) async {
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
        _ordenhaCadastrada.data = dataFormatada(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Registrar Ordenha"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Navigator.pop(context, _ordenhaCadastrada);
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
              child: Text("Data de Ordenha*"),
              padding: EdgeInsets.only(top: 10.0),
            ),
            RaisedButton(
              child: Text(exibicaoDataPadrao(dataFormatada(_dataSelecionada))),
              onPressed: () {
                _selectDataOrdenha(context);
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
                  _ordenhaCadastrada.peso = text;
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
            title: Text("Você não pode cadastrar uma Ordenha futura!"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                  _selectDataOrdenha(context);
                },
              ),
            ],
          );
        });
  }
}
