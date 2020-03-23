import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';
import 'package:ouvinos_caprinos/tratamento/class/tratamento.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';

class TratamentoPage extends StatefulWidget {
  final Tratamento tratamento;
  final int animalId;

  TratamentoPage({this.tratamento, this.animalId});

  @override
  _TratamentoPageState createState() => _TratamentoPageState();
}

class _TratamentoPageState extends State<TratamentoPage> {
  final _selectedMotivo = TextEditingController();
  final _selectedMedicacaoVacinacao = TextEditingController();
  final _selectedPeriodoCarencia = TextEditingController();
  final _selectedCusto = TextEditingController();
  final _selectedAnotacoes = TextEditingController();
  String _selectedData = "";
  bool _edited = false;

  Tratamento _tratamentoCadastrado;

  DateTime _dataSelecionada = DateTime.now();

  AnimalHelper animalHelper = AnimalHelper();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.tratamento == null) {
      _tratamentoCadastrado = Tratamento();
      _tratamentoCadastrado.animalId = widget.animalId;
      _tratamentoCadastrado.data = _dataFormatada(_dataSelecionada);
      _selectedData = _dataFormatada(_dataSelecionada);
    } else {
      _tratamentoCadastrado = Tratamento.fromMap(widget.tratamento.toMap());
      _selectedMotivo.text = _tratamentoCadastrado.motivo;
      _selectedMedicacaoVacinacao.text = _tratamentoCadastrado.medicacao;
      _selectedCusto.text = _tratamentoCadastrado.custo;
      _selectedPeriodoCarencia.text = _tratamentoCadastrado.periodoCarencia;
      _selectedAnotacoes.text = _tratamentoCadastrado.anotacoes;
      _selectedData = _tratamentoCadastrado.data;
    }
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
        _edited = true;
        _dataSelecionada = picked;
        _selectedData = _dataFormatada(picked);
        _tratamentoCadastrado.data = _dataFormatada(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text("Registrar Tratamento"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a Snackbar.
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
                Navigator.pop(context, _tratamentoCadastrado);
              }
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
                    child: Text("$_selectedData"),
                    onPressed: () {
                      _selectDataTratamento(context);
                      setState(() {
                        _edited = true;
                        // _editedAnimal.dataNascimento = _dataNascimentoFormatada;
                      });
                    },
                  ),
                  espacamentoPadrao(),
                  TextFormField(
                    controller: _selectedMotivo,
                    decoration: estiloPadrao("Motivo*", 1),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor, insira o Motivo';
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() {
                        _tratamentoCadastrado.motivo = text;
                        _edited = true;
                        // _editedAnimal.nome = text;
                      });
                    },
                  ),
                  espacamentoPadrao(),
                  TextFormField(
                    decoration: estiloPadrao("Medicação/Vacinação*", 1),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor, insira a Medicação/Vacinação';
                      }
                      return null;
                    },
                    controller: _selectedMedicacaoVacinacao,
                    onChanged: (text) {
                      setState(() {
                        _tratamentoCadastrado.medicacao = text;
                        _edited = true;
                        // _editedAnimal.nome = text;
                      });
                    },
                  ),
                  espacamentoPadrao(),
                  TextFormField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: estiloPadrao("Periodo de Carência*", 1),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor, insira o Periodo de Carência';
                      }
                      return null;
                    },
                    controller: _selectedPeriodoCarencia,
                    onChanged: (text) {
                      setState(() {
                        _tratamentoCadastrado.periodoCarencia = text;
                        _edited = true;
                        // _editedAnimal.nome = text;
                      });
                    },
                  ),
                  espacamentoPadrao(),
                  TextFormField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: estiloPadrao("Custo*", 2),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor, insira o Custo';
                      }
                      return null;
                    },
                    controller: _selectedCusto,
                    onChanged: (text) {
                      setState(() {
                        _tratamentoCadastrado.custo = text;
                        _edited = true;
                        // _editedAnimal.nome = text;
                      });
                    },
                  ),
                  espacamentoPadrao(),
                  TextField(
                    decoration: estiloPadrao("Anotações", 1),
                    controller: _selectedAnotacoes,
                    onChanged: (text) {
                      setState(() {
                        _tratamentoCadastrado.anotacoes = text;
                        _edited = true;
                        // _editedAnimal.nome = text;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  Future<bool> _requestPop() {
    if (_edited) {
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
