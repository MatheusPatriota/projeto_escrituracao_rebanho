import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/observacao/class/observacao.dart';
import 'package:ouvinos_caprinos/pesagem/class/pesagem.dart';
import 'package:ouvinos_caprinos/tratamento/class/tratamento.dart';

class VisualizarEvento extends StatefulWidget {
  final dynamic evento;
  final int tipoEvento;

  VisualizarEvento({this.evento, this.tipoEvento});

  @override
  _VisualizarEventoState createState() => _VisualizarEventoState();
}

class _VisualizarEventoState extends State<VisualizarEvento> {
  Tratamento _tratamentoSelecionado;
  Observacao _observacaoSelecionada;
  Pesagem _pesoSelecionado;

  @override
  void initState() {
    super.initState();

    if (widget.tipoEvento == 1) {
      _tratamentoSelecionado = Tratamento.fromMap(widget.evento.toMap());
    } else if (widget.tipoEvento == 2) {
      _pesoSelecionado = Pesagem.fromMap(widget.evento.toMap());
    } else if (widget.tipoEvento == 3) {
      _observacaoSelecionada = Observacao.fromMap(widget.evento.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Evento"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children:  _listagem(),
          )
        ],
      ),
    );
  }

  List<Widget> _listagem() {
    List<Widget> lista = new List();
    lista.add(Padding(padding: EdgeInsets.all(50.0),));
    if (_tratamentoSelecionado != null) {
      lista.add(fontePadrao("Data do Tratamento"));
      lista.add(fontePadrao(_tratamentoSelecionado.data));
      lista.add(fontePadrao("Motivo do Tratamento"));
      lista.add(fontePadrao(_tratamentoSelecionado.motivo));
      lista.add(fontePadrao("Medicação/Vacinação Utilizada"));
      lista.add(fontePadrao(_tratamentoSelecionado.medicacao));
      lista.add(fontePadrao("Perídodo de Carência"));
      lista.add(fontePadrao(_tratamentoSelecionado.periodoCarencia + "dias"));
      lista.add(fontePadrao("Custo do Tratamento"));
      lista.add(fontePadrao("R\$ "+_tratamentoSelecionado.custo));
      if (_tratamentoSelecionado.anotacoes == null) {
        lista.add(fontePadrao("Não Possui Anotações"));
      } else {
        lista.add(fontePadrao("Anotações"));
        lista.add(fontePadrao(_tratamentoSelecionado.anotacoes));
      }
    } else if (_pesoSelecionado != null) {
      lista.add(fontePadrao("Data da Pesagem"));
      lista.add(fontePadrao(_pesoSelecionado.data));
      lista.add(fontePadrao("Peso Registrado"));
      lista.add(fontePadrao(_pesoSelecionado.peso + " KG"));
    } else {
      lista.add(fontePadrao("Data da Observação"));
      lista.add(fontePadrao(_observacaoSelecionada.data));
      lista.add(fontePadrao("Observação"));
      lista.add(fontePadrao(_observacaoSelecionada.descricao));
    }
    return lista;
  }
  Text fontePadrao(String texto){
    return Text(texto, style: TextStyle(fontSize: 20), textAlign: TextAlign.center,);

  }


}
