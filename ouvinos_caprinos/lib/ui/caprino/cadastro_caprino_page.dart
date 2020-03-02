// @author: Matheus Patriota
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';
import 'package:ouvinos_caprinos/categoria/class/categoria.dart';
import 'package:ouvinos_caprinos/categoria/db/categoria_database.dart';
import 'package:ouvinos_caprinos/especie/class/especie.dart';
import 'package:ouvinos_caprinos/especie/db/especie_database.dart';
import 'package:ouvinos_caprinos/raca/class/raca.dart';
import 'package:ouvinos_caprinos/raca/db/raca_database.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';

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
  int _selectedMae = 0;
  int _selectedPai = 0;

  final _selectedNome = TextEditingController();
  final _selectedBrincoControle = TextEditingController();
  final _selectedValorAquisicao = TextEditingController();
  final _selectedNomeVendedor = TextEditingController();
  final _selectedPatrimonio = TextEditingController();

  // animal a ser criado/editado
  Animal _editedAnimal;

  AnimalHelper animalHelper = AnimalHelper();
  CategoriaHelper categoriaHelper = CategoriaHelper();
  RacaHelper racaHelper = RacaHelper();
  EspecieHelper especieHelper = EspecieHelper();

  // listas onde serao armazenada as possiveis escolhas
  List<DropdownMenuItem<int>> genderList = [];
  List<DropdownMenuItem<int>> categoriaList = [];
  List<DropdownMenuItem<int>> racaList = [];
  List<DropdownMenuItem<int>> paiList = [];
  List<DropdownMenuItem<int>> maeList = [];

  // checa se o animal foi editado
  bool _userEdited = false;

  // recupera as datas atuais
  DateTime _dataNascimento = new DateTime.now();
  DateTime _dataAquisicao = new DateTime.now();

  String _dataNascimentoFormatada = "";
  String _dataAquisicaoFormatada = "";

  List<Categoria> categorias = List();
  List<Especie> especies = List();
  List<Raca> racas = List();
  List<Animal> pais = List();
  List<Animal> maes = List();

  String _dataFormatada(data) {
    return "${data.day}/${data.month}/${data.year}";
  }

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
        _dataNascimentoFormatada = _dataFormatada(picked);
        _dataNascimento = picked;
        _editedAnimal.dataNascimento = _dataFormatada(picked);
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
        _dataAquisicaoFormatada = _dataFormatada(picked);
        _dataAquisicao = picked;
        _editedAnimal.dataAquisicao = _dataFormatada(picked);
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
      _editedAnimal.idRaca = 0;
      _editedAnimal.idEspecie = 1;
      _editedAnimal.idCategoria = 0;
      _editedAnimal.status = "0";

      _dataNascimentoFormatada = _dataFormatada(_dataNascimento);
      _dataAquisicaoFormatada = _dataFormatada(_dataAquisicao);

      _editedAnimal.dataNascimento = _dataNascimentoFormatada;
      print(_editedAnimal);
    } else {
      _editedAnimal = Animal.fromMap(widget.animalCaprino.toMap());
      _selectedGender = _retornaNumeracaoSexo(_editedAnimal.sexo);
      _selectedCategoria = _editedAnimal.idCategoria;
      _selectedRaca = _editedAnimal.idRaca;
      _selectedMae = _editedAnimal.idMae;
      _selectedPai = _editedAnimal.idPai;
      _selectedNome.text = _editedAnimal.nome;
      _selectedBrincoControle.text = _editedAnimal.brincoControle;
      _selectedNomeVendedor.text = _editedAnimal.nomeVendedor;
      _selectedValorAquisicao.text = _editedAnimal.valorAquisicao;
      _selectedPatrimonio.text = _editedAnimal.patrimonio;
      _dataNascimentoFormatada = _editedAnimal.dataNascimento;
    }

    _getAllCategorias();
    _getAllEspecies();
    _getAllRacas();
    _getAllAnimals();
  }

  int _retornaNumeracaoSexo(String a) {
    int result = 0;
    if (a == "Fêmea") {
      result = 1;
    }
    return result;
  }

  _getAllCategorias() async {
    await categoriaHelper.getAllCategorias().then((listaC) {
      setState(() {
        categorias = listaC;
      });
    });
  }

  _getAllRacas() async {
    await racaHelper.getAllRacas().then((listaR) {
      setState(() {
        racas = listaR;
      });
    });
  }

  _getAllAnimals() async {
    await animalHelper.getAllAnimals().then((listaA) {
      List<Animal> paisFinal = List();
      List<Animal> maesFinal = List();

      for (var animal in listaA) {
        if (animal.idEspecie == 1) {
          if (animal.sexo == "Macho") {
            paisFinal.add(animal);
          } else {
            maesFinal.add(animal);
          }
        }
      }

      setState(() {
        pais = paisFinal;
        maes = maesFinal;
      });
    });
  }

  Future<void> _getAllEspecies() async {
    await especieHelper.getAllEspecies().then((listaE) {
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

  void loadPaiList() {
    paiList = [];
    paiList.add(new DropdownMenuItem(
      child: new Text("Não Selecionado"),
      value: 0,
    ));
    if (pais.isNotEmpty) {
      for (var i = 0; i < pais.length; i++) {
        paiList.add(new DropdownMenuItem(
          child: Text(pais[i].nome ?? pais[i].idAnimal.toString()),
          value: i + 1,
        ));
      }
    }
  }

  void loadMaeList() {
    maeList = [];
    maeList.add(new DropdownMenuItem(
      child: new Text("Não Selecionada"),
      value: 0,
    ));
    if (maes.isNotEmpty) {
      for (var i = 0; i < maes.length; i++) {
        maeList.add(new DropdownMenuItem(
          child: new Text(maes[i].nome ?? maes[i].idAnimal.toString()),
          value: i + 1,
        ));
      }
    }
  }

  // montando a pagina de exibicao
  @override
  Widget build(BuildContext context) {
    // carregando as listas
    loadGenderList();
    loadCategoriaList();
    loadRacaList();
    loadPaiList();
    loadMaeList();
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
    formWidget.add(espacamentoPadrao());
    // widget para inserir o nome do animal
    formWidget.add(
      TextField(
        decoration: estiloPadrao("Nome", 1),
        controller: _selectedNome,
        onChanged: (text) {
          setState(() {
            _userEdited = true;
            _editedAnimal.nome = text;
          });
        },
      ),
    );
    formWidget.add(espacamentoPadrao());
    formWidget.add(
      OutlineDropdownButton(
        inputDecoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(10.0),
        ),
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
      ),
    );
    // formWidget.add(espacamentoPadrao());
    formWidget.add(Container(
      child: Text("Categoria"),
      padding: EdgeInsets.only(top: 10.0),
    ));
    // widget para inserir a categoria do animal
    formWidget.add(OutlineDropdownButton(
      inputDecoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(10.0),
      ),
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
    // formWidget.add(espacamentoPadrao());
    formWidget.add(Container(
      child: Text("Raça*"),
      padding: EdgeInsets.only(top: 10.0),
    ));
    // widget para inserir a raca do animal
    formWidget.add(OutlineDropdownButton(
      inputDecoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(10.0),
      ),
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
    formWidget.add(espacamentoPadrao());
    formWidget.add(
      new TextField(
        decoration: estiloPadrao("Brinco de Controle", 1),
        controller: _selectedBrincoControle,
        onChanged: (text) {
          setState(() {
            _userEdited = true;
            _editedAnimal.brincoControle = text;
          });
        },
      ),
    );
    
    formWidget.add(Container(
      child: Text("Pai"),
      padding: EdgeInsets.only(top: 10.0),
    ));
    // widget para inserir o idPai do animal
    formWidget.add(
      OutlineDropdownButton(
        inputDecoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(10.0),
        ),
        hint: new Text('Pai'),
        items: paiList,
        value: _selectedPai,
        onChanged: (value) {
          setState(() {
            _userEdited = true;
            _selectedPai = value;
            _editedAnimal.idPai = paiList[value].value;
          });
        },
        isExpanded: true,
      ),
    );
    formWidget.add(Container(
      child: Text("Mãe"),
      padding: EdgeInsets.only(top: 10.0),
    ));
    // widget para inserir a idMae do animal
    formWidget.add(OutlineDropdownButton(
      inputDecoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(10.0),
      ),
      hint: new Text('Mãe'),
      items: maeList,
      value: _selectedMae,
      onChanged: (value) {
        setState(() {
          _userEdited = true;
          _selectedMae = value;
          _editedAnimal.idMae = maeList[value].value;
        });
      },
      isExpanded: true,
    ));
    formWidget.add(espacamentoPadrao());
    formWidget.add(Container(
      child: Text("Data de Nascimento*"),
      padding: EdgeInsets.only(top: 10.0),
    ));
    // widget para data de nascimentoque eh obrigatoria
    formWidget.add(espacamentoPadrao());
    formWidget.add(
      new RaisedButton(
        child: Text("$_dataNascimentoFormatada"),
        onPressed: () {
          _selectDateNascimento(context);
          setState(() {
            _userEdited = true;
            _editedAnimal.dataNascimento = _dataNascimentoFormatada;
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
          child: Text("$_dataAquisicaoFormatada"),
          onPressed: () {
            _selectDateAquisicao(context);
            setState(() {
              _userEdited = true;
              _editedAnimal.dataAquisicao = _dataAquisicaoFormatada;
            });
          }),
    );
    // widget para o valor da aquisicao do animal
    formWidget.add(espacamentoPadrao());
    formWidget.add(
      new TextField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        controller: _selectedValorAquisicao,
        decoration: estiloPadrao("Valor da Aquisição", 2),
        onChanged: (text) {
          _userEdited = true;
          setState(() {
            _editedAnimal.valorAquisicao = text;
          });
        },
      ),
    );
    // widget para o nome do vendedor
    formWidget.add(espacamentoPadrao());
    formWidget.add(
      new TextField(
        decoration: estiloPadrao("Nome do Vendedor", 1),
        controller: _selectedNomeVendedor,
        onChanged: (text) {
          _userEdited = true;
          setState(() {
            _editedAnimal.nomeVendedor = text;
          });
        },
      ),
    );
    // widget para o patrimonio
    formWidget.add(espacamentoPadrao());
    formWidget.add(
      new TextField(
        decoration: estiloPadrao("Número do Patrimonio/Valor do Patrimonio", 1),
        controller: _selectedPatrimonio,
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
