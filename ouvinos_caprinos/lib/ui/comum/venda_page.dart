import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

   @override
  void initState() {
    super.initState();
    _animalSelecionado = Animal.fromMap(widget.animalVenda.toMap());
    _animalSelecionado.dataVendaAnimal = _dataFormatada(_dataSelecionada);
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
        _animalSelecionado.dataVendaAnimal = _dataFormatada(picked);
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
            _animalSelecionado.status = "1";
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
                child: Text("Data da Venda*"),
                padding: EdgeInsets.only(top: 10.0),
              ),
              RaisedButton(
                child: Text(_dataFormatada(_dataSelecionada)),
                onPressed: () {
                  _selectDataPesagem(context);
                  setState(() {
                    _animalSelecionado.dataVendaAnimal = _dataFormatada(_dataSelecionada);
                    // _userEdited = true;
                    // _editedAnimal.dataNascimento = _dataNascimentoFormatada;
                  });
                },
              ),
              espacamentoPadrao(),
              TextField(
                decoration: estiloPadrao("Valor da Venda*", 2),
                // controller: _selectedNome,
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  setState(() {
                    _animalSelecionado.valorVenda = text;
                    // _userEdited = true;
                    // _editedAnimal.nome = text;
                  });
                },
              ),
              espacamentoPadrao(),
              TextField(
                decoration: estiloPadrao("Comprador*", 1),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                // controller: _selectedNome,]
                onChanged: (text) {
                  setState(() {
                    _animalSelecionado.nomeComprador = text;
                    // _userEdited = true;
                    // _editedAnimal.nome = text;
                  });
                },
              ),
              espacamentoPadrao(),
              TextField(
                decoration: estiloPadrao("Anotações", 1),
                // controller: _selectedNome,
                onChanged: (text) {
                  setState(() {
                    _animalSelecionado.anotacoesVenda = text;
                    // _userEdited = true;
                    // _editedAnimal.nome = text;
                  });
                },
              ),
            ]
          ),
        ),
      ),
    );
  }
}
