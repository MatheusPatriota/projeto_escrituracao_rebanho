import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:escrituracao_zootecnica/animal/class/animal.dart';
import 'package:escrituracao_zootecnica/animal/db/animal_database.dart';
import 'package:escrituracao_zootecnica/util/funcoes.dart';

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

  var _selectedValorVenda = MoneyMaskedTextController();
  final _selectedVendendor = TextEditingController();
  final _selectedAnotacoes = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animalSelecionado = Animal.fromMap(widget.animalVenda.toMap());
    if (widget.animalVenda.status == "1") {
      _selectedValorVenda.text = _animalSelecionado.valorVenda;
      _selectedVendendor.text =
          _animalSelecionado.nomeVendedor ?? "Nome do Vendendor não Informado";
      _selectedAnotacoes.text =
          _animalSelecionado.anotacoesVenda ?? "Não possui anotações";
    } else {
      _animalSelecionado.dataVendaAnimal = dataFormatada(_dataSelecionada);
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
          if (_formKey.currentState.validate()) {
            _animalSelecionado.status = "1";
            Navigator.pop(context, _animalSelecionado);
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
              child: Text("Data da Venda*"),
              padding: EdgeInsets.only(top: 10.0),
            ),
            RaisedButton(
              child: Text(exibicaoDataPadrao(dataFormatada(_dataSelecionada))),
              onPressed: () async {
                _dataSelecionada = await selectDate(context, _dataSelecionada);

                setState(() {
                  _animalSelecionado.dataVendaAnimal =
                      dataFormatada(_dataSelecionada);
                });
              },
            ),
            espacamentoPadrao(),
            TextFormField(
              controller: _selectedValorVenda,
              decoration: estiloPadrao("Valor da Venda*", 2),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor, insira o valor da venda';
                }
                return null;
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (text) {
                setState(() {
                  _animalSelecionado.valorVenda = text;
                });
              },
            ),
            espacamentoPadrao(),
            TextFormField(
              decoration: estiloPadrao("Comprador*", 1),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor, insira a o nome do Comprador';
                }
                return null;
              },
              controller: _selectedVendendor,
              onChanged: (text) {
                setState(() {
                  _animalSelecionado.nomeComprador = text;
                });
              },
            ),
            espacamentoPadrao(),
            TextField(
              decoration: estiloPadrao("Anotações", 1),
              controller: _selectedAnotacoes,
              onChanged: (text) {
                setState(() {
                  _animalSelecionado.anotacoesVenda = text;
                });
              },
            ),
          ]),
        ),
      ),
    );
  }
}
