import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ouvinos_caprinos/helper/animais_helper.dart';

class CadastroCaprinoPage extends StatefulWidget {
  final Animal animalCaprino;

  CadastroCaprinoPage({this.animalCaprino});

  @override
  _CadastroCaprinoPageState createState() => _CadastroCaprinoPageState();
}

class _CadastroCaprinoPageState extends State<CadastroCaprinoPage> {


  final _tipoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _sexoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _racaController = TextEditingController();
  final _brincoControleController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _dataAquisicaoController = TextEditingController();
  final _valorAquisicaoController = TextEditingController();
  final _nomeVendedorController = TextEditingController();
  final _patrimonioController = TextEditingController();


  final _nomeFocus = FocusNode();

  bool _userEdited = false;

  Animal _editedAnimal;

  @override
  void initState() {
    super.initState();

    if (widget.animalCaprino == null) {
      _editedAnimal = Animal();
    } else {
      _editedAnimal = Animal.fromMap(widget.animalCaprino.toMap());
      
      _tipoController.text = _editedAnimal.tipo;
      _nomeController.text = _editedAnimal.nome;
      _sexoController.text = _editedAnimal.sexo;
      _categoriaController.text = _editedAnimal.categoria;
      _racaController.text = _editedAnimal.raca;
      _brincoControleController.text = _editedAnimal.brincoControle;
      _paiController.text = _editedAnimal.pai;
      _maeController.text = _editedAnimal.mae;
      _dataNascimentoController.text = _editedAnimal.dataNascimento;
      _dataAquisicaoController.text = _editedAnimal.dataAquisicao;
      _valorAquisicaoController.text = _editedAnimal.valorAquisicao;
      _nomeVendedorController.text = _editedAnimal.nomeVendedor;
      _patrimonioController.text = _editedAnimal.patrimonio;

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(_editedAnimal.nome ?? "Novo Caprino"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedAnimal.nome != null && _editedAnimal.nome.isNotEmpty) {
              Navigator.pop(context, _editedAnimal);
            } else {
              FocusScope.of(context).requestFocus(_nomeFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedAnimal.img != null
                            ? FileImage(File(_editedAnimal.img))
                            : AssetImage("images/caprino.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.camera)
                      .then((file) {
                    if (file == null) return;
                    setState(() {
                      _editedAnimal.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                controller: _nomeController,
                focusNode: _nomeFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedAnimal.nome = text;
                  });
                },
              ),
              TextField(
                controller: _sexoController,             
                decoration: InputDecoration(labelText: "Sexo"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedAnimal.sexo = text;
                    _editedAnimal.tipo = "caprino";
                  });
                },
               
              ),
              TextField(
                controller: _categoriaController,
                decoration: InputDecoration(labelText: "Categoria"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedAnimal.categoria = text;
                  });
                },
                
              ),
              TextField(
                controller: _racaController,
                decoration: InputDecoration(labelText: "Raca"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedAnimal.raca = text;
                  });
                },
              
              ),
              TextField(
                controller: _brincoControleController,
                decoration: InputDecoration(labelText: "Brinco de Controle"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedAnimal.brincoControle = text;
                  });
                },
              ),
               TextField(
                controller: _paiController,
                decoration: InputDecoration(labelText: "Pai"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedAnimal.pai = text;
                  });
                },
              ),
               TextField(
                controller: _maeController,
                decoration: InputDecoration(labelText: "Mae"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedAnimal.mae = text;
                  });
                },
              ),
               TextField(
                controller: _dataNascimentoController,
                decoration: InputDecoration(labelText: "Data de Nascimento"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedAnimal.dataNascimento = text;
                  });
                },
              ),
               TextField(
                controller: _dataAquisicaoController,
                decoration: InputDecoration(labelText: "Data de aquisicao"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedAnimal.dataAquisicao = text;
                  });
                },
              ),
               TextField(
                controller: _valorAquisicaoController,
                decoration: InputDecoration(labelText: "Valor de Aquisicao"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedAnimal.valorAquisicao = text;
                  });
                },
              ),
               TextField(
                controller: _nomeVendedorController,
                decoration: InputDecoration(labelText: "Nome do Vendedor"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedAnimal.nomeVendedor = text;
                  });
                },
              ),
               TextField(
                controller: _patrimonioController,
                decoration: InputDecoration(labelText: "Patrimonio"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedAnimal.patrimonio = text;
                  });
                },
              ),
              //menu para opcoes de sexo
               
              //Menu para opcoes de Categoria
             
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
