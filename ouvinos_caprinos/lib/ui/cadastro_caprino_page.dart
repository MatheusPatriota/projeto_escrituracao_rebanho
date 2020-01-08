import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ouvinos_caprinos/helper/animais_helper.dart';

class CadastroCaprinoPage extends StatefulWidget {
  final Animal animal;

  CadastroCaprinoPage({this.animal});

  @override
  _CadastroCaprinoPageState createState() => _CadastroCaprinoPageState();
}

class _CadastroCaprinoPageState extends State<CadastroCaprinoPage> {


  final _nomeController = TextEditingController();
  final _sexoController = TextEditingController();
  final _categoriaController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _userEdited = false;

  Animal _editedAnimal;

  @override
  void initState() {
    super.initState();

    if (widget.animal == null) {
      _editedAnimal = Animal();
    } else {
      _editedAnimal = Animal.fromMap(widget.animal.toMap());

      _nomeController.text = _editedAnimal.nome;
      _sexoController.text = _editedAnimal.sexo;
      _categoriaController.text = _editedAnimal.categoria;
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
