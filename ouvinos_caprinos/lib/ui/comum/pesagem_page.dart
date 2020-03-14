import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
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
      _pesoCadastrado.data = _dataFormatada(_dataSelecionada);
      // _pesoCadastrado.idAnimal = 1;
    }else{
      _pesoCadastrado = Pesagem.fromMap(widget.peso.toMap());
      _selectedPeso.text = _pesoCadastrado.peso;

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
        _pesoCadastrado.data = _dataFormatada(_dataSelecionada);
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
          Navigator.pop(context, _pesoCadastrado);
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
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: estiloPadrao("Peso(KG)*", 1) ,
              controller: _selectedPeso,
              onChanged: (text) {
                setState(() {
                  _pesoCadastrado.peso = text;
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
