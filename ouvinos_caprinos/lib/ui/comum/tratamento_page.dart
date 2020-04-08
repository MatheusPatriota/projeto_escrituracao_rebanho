import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
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
  var _selectedCusto = MoneyMaskedTextController();

  final _selectedAnotacoes = TextEditingController();

  bool _edited = false;

  Tratamento _tratamentoCadastrado;

  DateTime _dataTratamentoSelecionada = DateTime.now();
  DateTime _dataAgendamentoSelecionada = DateTime.now();

  AnimalHelper animalHelper = AnimalHelper();

  final _formKey = GlobalKey<FormState>();

  bool agendamento = false;

  String _dataFormatada(data) {
    String dia = "${data.day}";
    String nd = "";
    String mes = "${data.month}";
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
    return "${_dataTratamentoSelecionada.year}-" + nm + "-" + nd;
  }

  Future<Null> _selectDataTratamento(BuildContext context, int opcao) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dataTratamentoSelecionada,
      firstDate: new DateTime(1900),
      lastDate: new DateTime(2100),
    );
    if (picked != null && picked != _dataTratamentoSelecionada) {
      if (opcao == 0) {
        setState(() {
          _edited = true;
          _dataTratamentoSelecionada = picked;

          _tratamentoCadastrado.dataTratamento =
              _dataFormatada(_dataTratamentoSelecionada);
        });
      } else {
        setState(() {
          _edited = true;
          _dataAgendamentoSelecionada = picked;
          _tratamentoCadastrado.dataAgendamento =
              _dataFormatada(_dataAgendamentoSelecionada);
        });
      }
    }
  }

  Widget agendar(bool a) {
    if (a == true) {
      return RaisedButton(
        child: Text(
            exibicaoDataPadrao(_dataFormatada(_dataAgendamentoSelecionada))),
        onPressed: () {
          _selectDataTratamento(context, 1);
          setState(() {
            _edited = true;
            // _editedAnimal.dataNascimento = _dataNascimentoFormatada;
          });
        },
      );
    } else {
      return Text("");
    }
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

  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initializeNotifications() async {
    var initializeAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializeIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(initializeAndroid, initializeIOS);
    await localNotificationsPlugin.initialize(initSettings);
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    if (widget.tratamento == null) {
      _tratamentoCadastrado = Tratamento();
      _tratamentoCadastrado.animalId = widget.animalId;
      _tratamentoCadastrado.dataTratamento =
          _dataFormatada(_dataTratamentoSelecionada);
    } else {
      _tratamentoCadastrado = Tratamento.fromMap(widget.tratamento.toMap());
      _selectedMotivo.text = _tratamentoCadastrado.motivo;
      _selectedMedicacaoVacinacao.text = _tratamentoCadastrado.medicacao;
      _selectedCusto.text = _tratamentoCadastrado.custo;
      _selectedPeriodoCarencia.text = _tratamentoCadastrado.periodoCarencia;
      _selectedAnotacoes.text = _tratamentoCadastrado.anotacoes;
    }
  }

  Future singleNotification(
      DateTime datetime, String message, String subtext, int hashcode,
      {String sound}) async {
    var androidChannel = AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      'channel-description',
      importance: Importance.Max,
      priority: Priority.Max,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    localNotificationsPlugin.schedule(
        hashcode, message, subtext, datetime, platformChannel,
        payload: hashcode.toString());
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
                    child: Text(exibicaoDataPadrao(
                        _dataFormatada(_dataTratamentoSelecionada))),
                    onPressed: () {
                      _selectDataTratamento(context, 0);
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
                    decoration: estiloPadrao("Periodo de Carência(Dias)*", 1),
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
                    decoration: estiloPadrao("Custo(R\$)*", 2),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor, insira o Custo';
                      }
                      return null;
                    },
                    controller: _selectedCusto,
                    onChanged: (text) {
                      setState(() {
                        _tratamentoCadastrado.custo = _selectedCusto.text;
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
                  Column(
                    children: <Widget>[
                      Text("Agendamento"),
                      Checkbox(
                        value: agendamento,
                        onChanged: (bool value) {
                          setState(() {
                            agendamento = value;
                          });
                        },
                      ),
                    ],
                  ),
                  agendar(agendamento),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check),
            backgroundColor: Colors.green,
            onPressed: () async {
              DateTime now = DateTime.now().toUtc().add(
                    Duration(seconds: 10),
                  );
              await singleNotification(
                now,
                "Oi lindo",
                "Tú eh lindo demais mano",
                98123871,
              );
              if (_formKey.currentState.validate()) {
                Navigator.pop(context, _tratamentoCadastrado);
              }
            },
          ),
        ),
        onWillPop: _requestPop);
  }
}
