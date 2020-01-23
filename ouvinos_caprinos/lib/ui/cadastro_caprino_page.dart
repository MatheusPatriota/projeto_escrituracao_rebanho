import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ouvinos_caprinos/drowpdown_info/dropdown_buttons.dart';
import 'package:ouvinos_caprinos/helper/animais_helper.dart';

class CadastroCaprinoPage extends StatefulWidget {
  final Animal animalCaprino;

  CadastroCaprinoPage({this.animalCaprino});

  @override
  _CadastroCaprinoPageState createState() => _CadastroCaprinoPageState();
}

class _CadastroCaprinoPageState extends State<CadastroCaprinoPage> {
  /// Variveis de controle que passam informacao para o banco de dados
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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // variaveis para o menu de alternativas no cadastro
  List<Sexo> _sexos = Sexo.getSex();
  List<DropdownMenuItem<Sexo>> _menuSexo;
  Sexo _sexoSelecionado;

  List<Categoria> _categorias = Categoria.getCategorias();
  List<DropdownMenuItem<Categoria>> _menuCategorias;
  Categoria _categoriaSelecionado;

  List<RacaCaprino> _racasCaprino = RacaCaprino.getRacaCaprinos();
  List<DropdownMenuItem<RacaCaprino>> _menuRacasCaprinos;
  RacaCaprino _racaCaprinoSelecionado;

  /// Metodo inicializa toda vez que tem alguma alteracao no aplicativo
  @override
  void initState() {
    _menuSexo = buildDropdownSexoItems(_sexos);
    _sexoSelecionado = _menuSexo[0].value;

    _menuCategorias = buildDropdownCategoriaItems(_categorias);
    _categoriaSelecionado = _menuCategorias[0].value;

    _menuRacasCaprinos = buildDropdownRacasCaprinoItems(_racasCaprino);
    _racaCaprinoSelecionado = _menuRacasCaprinos[0].value;

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

  /**
   * Tentei unificar em uma unica funcao do tipo generica, mas nao consegui, tive que colocar desse jeito 
   * se tiver alguma sugestao pode mandar
   */

  /// Metodo responsavel por criar o menu de alternativas para o cadastro
  List<DropdownMenuItem<Sexo>> buildDropdownSexoItems(List x) {
    List<DropdownMenuItem<Sexo>> items = List();
    for (Sexo c in x) {
      items.add(
        DropdownMenuItem(
          value: c,
          child: Text(c.nome),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Categoria>> buildDropdownCategoriaItems(List x) {
    List<DropdownMenuItem<Categoria>> items = List();
    for (Categoria c in x) {
      items.add(
        DropdownMenuItem(
          value: c,
          child: Text(c.nome),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<RacaCaprino>> buildDropdownRacasCaprinoItems(List x) {
    List<DropdownMenuItem<RacaCaprino>> items = List();
    for (RacaCaprino c in x) {
      items.add(
        DropdownMenuItem(
          value: c,
          child: Text(c.nome),
        ),
      );
    }
    return items;
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
          child: Form(
            key: _formKey,
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
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
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
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: DropdownButtonFormField<Sexo>(
                    isExpanded: true,
                    value: _sexoSelecionado,
                    items: _menuSexo,
                    onChanged: (Sexo sexoSelecionado) {
                      setState(() {
                        _userEdited = true;
                        _sexoSelecionado = sexoSelecionado;
                        _editedAnimal.sexo = sexoSelecionado.nome;
                        _editedAnimal.tipo = "caprino";
                      });
                    },
                   
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    hint: Text("Selecione a Categoria"),
                    value: _categoriaSelecionado,
                    items: _menuCategorias,
                    onChanged: (Categoria categoriaSelecionada) {
                      setState(() {
                        _userEdited = true;
                        _categoriaSelecionado = categoriaSelecionada;
                        _editedAnimal.categoria = categoriaSelecionada.nome;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    hint: Text("Selecione a Raça"),
                    value: _racaCaprinoSelecionado,
                    items: _menuRacasCaprinos,
                    onChanged: (RacaCaprino racaCaprinoSelecionada) {
                      setState(() {
                        _userEdited = true;
                        _racaCaprinoSelecionado = racaCaprinoSelecionada;
                        _editedAnimal.raca = racaCaprinoSelecionada.nome;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _brincoControleController,
                    decoration:
                        InputDecoration(labelText: "Brinco de Controle"),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedAnimal.brincoControle = text;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _paiController,
                    decoration: InputDecoration(labelText: "Pai"),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedAnimal.pai = text;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _maeController,
                    decoration: InputDecoration(labelText: "Mae"),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedAnimal.mae = text;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _dataNascimentoController,
                    decoration:
                        InputDecoration(labelText: "Data de Nascimento"),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedAnimal.dataNascimento = text;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _dataAquisicaoController,
                    decoration: InputDecoration(labelText: "Data de aquisicao"),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedAnimal.dataAquisicao = text;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _valorAquisicaoController,
                    decoration:
                        InputDecoration(labelText: "Valor de Aquisicao"),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedAnimal.valorAquisicao = text;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _nomeVendedorController,
                    decoration: InputDecoration(labelText: "Nome do Vendedor"),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedAnimal.nomeVendedor = text;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _patrimonioController,
                    decoration: InputDecoration(labelText: "Patrimonio"),
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedAnimal.patrimonio = text;
                      });
                    },
                  ),
                ),
              ],
            ),
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
