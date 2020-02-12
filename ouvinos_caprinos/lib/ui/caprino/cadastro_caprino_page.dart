// @author: Matheus Patriota

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/categoria/class/categoria.dart';
import 'package:ouvinos_caprinos/categoria/db/categoria_database.dart';
import 'package:ouvinos_caprinos/especie/class/especie.dart';
import 'package:ouvinos_caprinos/especie/db/especie_database.dart';
import 'package:ouvinos_caprinos/raca/class/raca.dart';
import 'package:ouvinos_caprinos/raca/db/raca_database.dart';

class CadastroCaprinoPage extends StatefulWidget {
  final Animal animalCaprino;

  CadastroCaprinoPage({this.animalCaprino});

  @override
  _CadastroCaprinoPageState createState() => _CadastroCaprinoPageState();
}

class _CadastroCaprinoPageState extends State<CadastroCaprinoPage> {
  // variavel responsavel pela chave do formulario
  final _formKey = GlobalKey<FormState>();

  // apontadores para as listas de multipla escolha
  int _selectedGender = 0;
  int _selectedCategoria = 0;
  int _selectedRaca = 0;

  // animal a ser criado/editado
  Animal _editedAnimal;

  CategoriaHelper categoriaHelper = CategoriaHelper();
  RacaHelper racaHelper = RacaHelper();
  EspecieHelper especieHelper = EspecieHelper();

  // listas onde serao armazenada as possiveis escolhas
  List<DropdownMenuItem<int>> genderList = [];
  List<DropdownMenuItem<int>> categoriaList = [];
  List<DropdownMenuItem<int>> racaList = [];

  // checa se o animal foi editado
  bool _userEdited = false;

  // recupera as datas atuais
  DateTime _dataNascimento = new DateTime.now();
  DateTime _dataAquisicao = new DateTime.now();

  List<Categoria> categorias = List();
  List<Especie> especies = List();
  List<Raca> racas = List();

  // funcao para o usuario escolhar a data de nascimento
  Future<Null> _selectDateNascimento(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dataNascimento,
      firstDate: new DateTime(1900),
      lastDate: new DateTime(2100),
    );
    if (picked != null && picked != _dataNascimento) {
      setState(() {
        _dataNascimento = picked;
      });
    }
  }

  // funcao para o usuario escolhar a data de Aquisicao
  Future<Null> _selectDateAquisicao(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dataAquisicao,
      firstDate: new DateTime(1900),
      lastDate: new DateTime(2100),
    );
    if (picked != null && picked != _dataAquisicao) {
      setState(() {
        _dataAquisicao = picked;
      });
    }
  }

  //inicializa toda vez que algo eh alterado
  @override
  void initState() {
    super.initState();

    if (widget.animalCaprino == null) {
      _editedAnimal = Animal();
      _editedAnimal.sexo = "Macho";
      _editedAnimal.idRaca = 1;
      _editedAnimal.idEspecie = 1;
      _editedAnimal.idCategoria = 0;
      _editedAnimal.status = "0";
      print(_editedAnimal);
    } else {
      _editedAnimal = Animal.fromMap(widget.animalCaprino.toMap());
    }

    _getAllCategorias();
    _getAllEspecies();
    _getAllRacas();
  }

  Future<void> _getAllCategorias() async {
    await categoriaHelper.getAllCategorias().then((listaC) {
      print(listaC);

      setState(() {
        categorias = listaC;
      });
    });
  }

  Future<void> _getAllRacas() async {
    await racaHelper.getAllRacas().then((listaR) {
      print(listaR);

      setState(() {
        racas = listaR;
      });
    });
  }

  Future<void> _getAllEspecies() async {
    await especieHelper.getAllEspecies().then((listaE) {
      print(listaE);

      setState(() {
        especies = listaE;
      });
    });
  }

  // carrega a lista de possiveis sexos
  void loadGenderList() {
    genderList = [];
    genderList.add(new DropdownMenuItem(
      child: new Text('Macho'),
      value: 0,
    ));
    genderList.add(new DropdownMenuItem(
      child: new Text('Fêmea'),
      value: 1,
    ));
  }

  // carrega a lista de possiveis categorias
  void loadCategoriaList() {
    categoriaList = [];
    for (var i = 0; i < categorias.length; i++) {
      categoriaList.add(new DropdownMenuItem(
        child: new Text(categorias[i].descricao),
        value: i,
      ));
    }
  }

  // carrega a lista de possiveis racas
  void loadRacaList() {
    racaList = [];

    for (var i = 0; i < racas.length; i++) {
      racaList.add(new DropdownMenuItem(
        child: new Text(racas[i].descricao),
        value: i,
      ));
    }
  }

  // montando a pagina de exibicao
  @override
  Widget build(BuildContext context) {
    // carregando as listas
    loadGenderList();
    loadCategoriaList();
    loadRacaList();
    // willpopScpe vai retornar nosso animal
    return WillPopScope(
      onWillPop: _requestPop,
      // Scaffold possibilita o slide pra cima e para baixo
      child: Scaffold(
        //barra superior com informacoes
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(_editedAnimal.nome ?? "Novo Caprino"),
          centerTitle: true,
        ),
        // botao salvar
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, _editedAnimal);
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.green,
        ),
        // formulario de cadastro
        body: Form(
            key: _formKey,
            child: new Container(
              padding: EdgeInsets.all(13.0),
              child: ListView(
                children: getFormWidgets(),
              ),
            )),
      ),
    );
  }

// Funcao que retorna todos os widgets usados no formulario de cadastro
  List<Widget> getFormWidgets() {
    // formatando a data para guardar no bd
    var formatoDataNascimento =
        "${_dataNascimento.day}-${_dataNascimento.month}-${_dataNascimento.year}";
    var formatoDataAquisicao =
        "${_dataAquisicao.day}-${_dataAquisicao.month}-${_dataAquisicao.year}";
    List<Widget> formWidget = new List();
    // widget para inserir a imagem no formulario
    formWidget.add(
      Column(
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
              ImagePicker.pickImage(source: ImageSource.camera).then((file) {
                if (file == null) return;
                setState(() {
                  _editedAnimal.img = file.path;
                });
              });
            },
          ),
        ],
      ),
    );

    // widget para inserir o nome do animal
    formWidget.add(
      new TextField(
        decoration: InputDecoration(labelText: "Nome"),
        onChanged: (text) {
          _userEdited = true;
          setState(() {
            _editedAnimal.nome = text;
          });
        },
      ),
    );
    formWidget.add(Container(
      child: Text("Sexo*"),
      padding: EdgeInsets.only(top: 10.0),
    ));
    // widget para inserir o sexo do animal
    formWidget.add(new DropdownButton(
      hint: new Text('Select Gender'),
      items: genderList,
      value: _selectedGender,
      onChanged: (value) {
        setState(() {
          _userEdited = true;
          _selectedGender = value;
          _editedAnimal.sexo =
              removeCaracteres(genderList[value].child.toString());
        });
      },
      isExpanded: true,
    ));
    formWidget.add(Container(
      child: Text("Categoria"),
      padding: EdgeInsets.only(top: 10.0),
    ));
    // widget para inserir a categoria do animal
    formWidget.add(new DropdownButton(
      hint: new Text('Select Categoria'),
      items: categoriaList,
      value: _selectedCategoria,
      onChanged: (value) {
        setState(() {
          _userEdited = true;
          _selectedCategoria = value;
          _editedAnimal.idCategoria = categoriaList[value].value;
        });
      },
      isExpanded: true,
    ));
    formWidget.add(Container(
      child: Text("Raça*"),
      padding: EdgeInsets.only(top: 10.0),
    ));
    // widget para inserir a raca do animal
    formWidget.add(new DropdownButton(
      hint: new Text('Selecione a Raça'),
      items: racaList,
      value: _selectedRaca,
      onChanged: (value) {
        setState(() {
          _userEdited = true;
          _selectedRaca = value;
          _editedAnimal.idRaca = racaList[value].value;
        });
      },
      isExpanded: true,
    ));
    // widget para inserir o numero do brinco de controle
    formWidget.add(
      new TextField(
        decoration: InputDecoration(labelText: "Brinco de Controle"),
        onChanged: (text) {
          _userEdited = true;
          setState(() {
            _editedAnimal.brincoControle = text;
          });
        },
      ),
    );
    // widget para inserir o idPai do animal
    formWidget.add(
      new TextField(
        decoration: InputDecoration(labelText: "Pai"),
        onChanged: (text) {
          _userEdited = true;
          setState(() {
            _editedAnimal.idPai = 0;
          });
        },
      ),
    );
    // widget para inserir a idMae do animal
    formWidget.add(
      new TextField(
        decoration: InputDecoration(labelText: "Mãe"),
        onChanged: (text) {
          _userEdited = true;
          setState(() {
            _editedAnimal.idMae = 0;
          });
        },
      ),
    );
    formWidget.add(Container(
      child: Text("Data de Nascimento*"),
      padding: EdgeInsets.only(top: 10.0),
    ));
    // widget para data de nascimentoque eh obrigatoria
    formWidget.add(
      new RaisedButton(
        child: Text("$formatoDataNascimento"),
        onPressed: () {
          _selectDateNascimento(context);
          print(_dataNascimento.toString());
          _userEdited = true;
          setState(() {
            _editedAnimal.dataNascimento = formatoDataNascimento;
          });
        },
      ),
    );
    // widget para data de aquisicao
    formWidget.add(Container(
      child: Text("Data de Aquisição"),
      padding: EdgeInsets.only(top: 10.0),
    ));
    formWidget.add(
      RaisedButton(
          child: Text("$formatoDataAquisicao"),
          onPressed: () {
            _selectDateAquisicao(context);
            _userEdited = true;

            setState(() {
              _editedAnimal.dataAquisicao = formatoDataAquisicao;
            });
          }),
    );
    // widget para o valor da aquisicao do animal
    formWidget.add(
      new TextField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration:
            InputDecoration(labelText: "Valor da Aquisição", prefixText: "R\$"),
        onChanged: (text) {
          _userEdited = true;
          setState(() {
            _editedAnimal.valorAquisicao = text;
          });
        },
      ),
    );
    // widget para o nome do vendedor
    formWidget.add(
      new TextField(
        decoration: InputDecoration(labelText: "Nome do Vendedor"),
        onChanged: (text) {
          _userEdited = true;
          setState(() {
            _editedAnimal.nomeVendedor = text;
          });
        },
      ),
    );
    // widget para o patrimonio
    formWidget.add(
      new TextField(
        decoration: InputDecoration(labelText: "Patrimônio/N do Patrimônio"),
        onChanged: (text) {
          _userEdited = true;
          setState(() {
            _editedAnimal.patrimonio = text;
          });
        },
      ),
    );

    return formWidget;
  }

// funcao para remover caracteres indesejados na string
  String removeCaracteres(String s) {
    String resp = "";
    bool removed = false;
    for (var i = 0; i < s.length; i++) {
      if (!(s[i] == "T" ||
          s[i] == "x" ||
          s[i] == "t" ||
          s[i] == "(" ||
          s[i] == ")" ||
          s[i] == '"')) {
        if (removed == false && s[i] == "e") {
          removed = true;
        } else {
          resp += s[i];
        }
      }
    }
    return resp;
  }

  // Funcao para checar se foi feita alguma alteracao no cadastro
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
