import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';

class TratamentoPage extends StatefulWidget {
  final Animal animalTratamento;

  TratamentoPage({this.animalTratamento});

  @override
  _TratamentoPageState createState() => _TratamentoPageState();
}

class _TratamentoPageState extends State<TratamentoPage> {
  Animal _animalSelecionado;

  DateTime _dataSelecionada = DateTime.now();

  AnimalHelper animalHelper = AnimalHelper();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _animalSelecionado = Animal.fromMap(widget.animalTratamento.toMap());
  }

  String _dataFormatada(data) {
    return "${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}";
  }

  Future<Null> _selectDataTratamento(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: new DateTime(1900),
      lastDate: new DateTime(2100),
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Registrar Tratamento"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, _animalSelecionado);
          },
          child: Icon(Icons.check),
          backgroundColor: Colors.green,
        ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(13.0),
          child: ListView(
            children: [
              Container(
                child: Text("Data de Tratamento*"),
                padding: EdgeInsets.only(top: 10.0),
              ),
              RaisedButton(
                child: Text(_dataFormatada(_dataSelecionada)),
                onPressed: () {
                  _selectDataTratamento(context);
                  setState(() {
                    // _userEdited = true;
                    // _editedAnimal.dataNascimento = _dataNascimentoFormatada;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Motivo do Tratamento*"),
                // controller: _selectedNome,
                onChanged: (text) {
                  setState(() {
                    // _userEdited = true;
                    // _editedAnimal.nome = text;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Medicação*"),
                // controller: _selectedNome,
                onChanged: (text) {
                  setState(() {
                    // _userEdited = true;
                    // _editedAnimal.nome = text;
                  });
                },
              ),
              TextField(
                decoration:
                    InputDecoration(labelText: "Periodo de Carencia(DIAS)"),
                // controller: _selectedNome,
                onChanged: (text) {
                  setState(() {
                    // _userEdited = true;
                    // _editedAnimal.nome = text;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Custo*"),
                // controller: _selectedNome,
                onChanged: (text) {
                  setState(() {
                    // _userEdited = true;
                    // _editedAnimal.nome = text;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Anotações"),
                // controller: _selectedNome,
                onChanged: (text) {
                  setState(() {
                    // _userEdited = true;
                    // _editedAnimal.nome = text;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
