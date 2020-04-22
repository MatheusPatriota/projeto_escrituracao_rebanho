import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';

class MortePage extends StatefulWidget {
  final Animal animalMorte;

  MortePage({this.animalMorte});

  @override
  _MortePageState createState() => _MortePageState();
}

class _MortePageState extends State<MortePage> {
  Animal _animalSelecionado;

  DateTime _dataSelecionada = DateTime.now();

  AnimalHelper animalHelper = AnimalHelper();

  final _motivoMorte = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _animalSelecionado = Animal.fromMap(widget.animalMorte.toMap());
    _animalSelecionado.dataMorte = _dataFormatada();
  }

  String _dataFormatada() {
    String dia = "${_dataSelecionada.day}";
    String nd = "";
    String mes = "${_dataSelecionada.month}";
    String nm = "";
    if (dia.length < 2) {
      nd = "0" + dia;
    } else {
      nd = dia;
    }
    if (mes.length < 2) {
      nm = "0" + mes;
    } else {
      nm = mes;
    }
    return "${_dataSelecionada.year}-" + nm + "-" + nd;
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
        _animalSelecionado.dataMorte = _dataFormatada();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Registrar Morte"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _showAlert();
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
              child: Text("Data da Morte*"),
              padding: EdgeInsets.only(top: 10.0),
            ),
            RaisedButton(
              child: Text(exibicaoDataPadrao(_dataFormatada())),
              onPressed: () {
                _selectDataPesagem(context);
              },
            ),
            espacamentoPadrao(),
            TextFormField(
              decoration: estiloPadrao("Motivo da Morte*", 1),
              controller: _motivoMorte,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor, insira o motivo da morte';
                }
                return null;
              },
              onChanged: (text) {
                setState(() {
                  _animalSelecionado.descricaoMorte = text;
                });
              },
            ),
          ]),
        ),
      ),
    );
  }

  void _showAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Vamos tirar uma foto do animal Morto, prepare-se!"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                  _selecionaImagemMorte();               
                },
              ),
            ],
          );
        });
  }

  _selecionaImagemMorte() {
    ImagePicker.pickImage(source: ImageSource.camera).then((file) {
      if (file == null) return;
      setState(() {
        _animalSelecionado.status = "2";
        _animalSelecionado.imgMorte = file.path;
      });
      Navigator.pop(context, _animalSelecionado);
      Navigator.pop(context);
    });
  }
}
