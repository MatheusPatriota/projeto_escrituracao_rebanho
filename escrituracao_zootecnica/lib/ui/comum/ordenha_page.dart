import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:escrituracao_zootecnica/animal/db/animal_database.dart';
import 'package:escrituracao_zootecnica/ordenha/class/ordenha.dart';
import 'package:escrituracao_zootecnica/ordenha/db/ordenha_database.dart';
import 'package:escrituracao_zootecnica/util/funcoes.dart';

class OrdenhaPage extends StatefulWidget {
  final Ordenha ordenha;
  final animalId;
  OrdenhaPage({this.ordenha, this.animalId});

  @override
  _OrdenhaPageState createState() => _OrdenhaPageState();
}

class _OrdenhaPageState extends State<OrdenhaPage> {
  final _selectedPeso = TextEditingController();

  Ordenha _ordenhaCadastrada;

  DateTime _dataSelecionada = DateTime.now();

  AnimalHelper animalHelper = AnimalHelper();
  OrdenhaHelper pesagemHelper = OrdenhaHelper();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.ordenha == null) {
      _ordenhaCadastrada = Ordenha(animalId: widget.animalId);
      _ordenhaCadastrada.data = dataFormatada(_dataSelecionada);
    } else {
      _ordenhaCadastrada = Ordenha.fromMap(widget.ordenha.toMap());
      _selectedPeso.text = _ordenhaCadastrada.peso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Registrar Ordenha"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Navigator.pop(context, _ordenhaCadastrada);
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
              child: Text("Data de Ordenha*"),
              padding: EdgeInsets.only(top: 10.0),
            ),
            RaisedButton(
              child: Text(exibicaoDataPadrao(dataFormatada(_dataSelecionada))),
              onPressed: () async {
                DateTime _dataComparativa =
                    await selectDate(context, _dataSelecionada);
                if (_dataComparativa.compareTo(_dataSelecionada) > 0) {
                  showAlert(context, _dataSelecionada, "Ordenha");
                } else {
                  setState(() {
                    _dataSelecionada = _dataComparativa;
                    _ordenhaCadastrada.data = dataFormatada(_dataSelecionada);
                  });
                }
              },
            ),
            espacamentoPadrao(),
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: estiloPadrao("Peso(KG)*", 1),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor, insira o Peso';
                }
                return null;
              },
              controller: _selectedPeso,
              onChanged: (text) {
                setState(() {
                  _ordenhaCadastrada.peso = text;
                });
              },
            ),
          ]),
        ),
      ),
    );
  }
}
