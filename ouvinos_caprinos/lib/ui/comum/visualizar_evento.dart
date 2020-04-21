import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/observacao/class/observacao.dart';
import 'package:ouvinos_caprinos/ordenha/class/ordenha.dart';
import 'package:ouvinos_caprinos/pesagem/class/pesagem.dart';
import 'package:ouvinos_caprinos/tratamento/class/tratamento.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';

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
  Ordenha _ordenhaSelecionada;


  @override
  void initState() {
    super.initState();

    if (widget.tipoEvento == 1) {
      _tratamentoSelecionado = Tratamento.fromMap(widget.evento.toMap());
    } else if (widget.tipoEvento == 2) {
      _pesoSelecionado = Pesagem.fromMap(widget.evento.toMap());
    } else if (widget.tipoEvento == 3) {
      _observacaoSelecionada = Observacao.fromMap(widget.evento.toMap());
    }else if(widget.tipoEvento == 4){
      _ordenhaSelecionada = Ordenha.fromMap(widget.evento.toMap());
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
      body: Center(
        child: ListView(
          children: [
            DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: Text('Categoria'),
                ),
                DataColumn(
                  label: Text('Informação'),
                ),
              ],
              rows: _listagem(),
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> _listagem() {
    List<DataRow> lista = new List();
    if (_tratamentoSelecionado != null) {
      lista.add(DataRow(cells: [
        DataCell(fontePadrao("Data do Tratamento")),
        DataCell(fontePadrao(
            exibicaoDataPadrao(_tratamentoSelecionado.dataTratamento)))
      ]));
       lista.add(DataRow(cells: [
        DataCell(fontePadrao("Motivo do Tratamento")),
        DataCell(fontePadrao(_tratamentoSelecionado.motivo))
      ]));
       lista.add(DataRow(cells: [
        DataCell(fontePadrao("Medicação/Vacinação")),
        DataCell(fontePadrao(_tratamentoSelecionado.medicacao))
      ]));
      lista.add( DataRow(cells: [
        DataCell(fontePadrao("Perídodo de Carência")),
        DataCell(fontePadrao(_tratamentoSelecionado.periodoCarencia + " dias"))
      ]));
      lista.add( DataRow(cells: [
        DataCell(fontePadrao("Custo do Tratamento")),
        DataCell(fontePadrao("R\$ " + _tratamentoSelecionado.custo))
      ]));
      if (_tratamentoSelecionado.anotacoes == null) {
         lista.add(DataRow(cells: [
          DataCell(fontePadrao("Anotações")),
          DataCell(fontePadrao("Não Possui Anotações"))
        ]));
      } else {
         lista.add(DataRow(cells: [
          DataCell(fontePadrao("Anotações")),
          DataCell(fontePadrao(_tratamentoSelecionado.anotacoes))
        ]));
      }
      if (_tratamentoSelecionado.dataAgendamento != null) {
         lista.add(DataRow(cells: [
          DataCell(fontePadrao("Data Agendada para proxima aplicação")),
          DataCell(fontePadrao(
              exibicaoDataPadrao(_tratamentoSelecionado.dataAgendamento)))
        ]));
      }
    } else if (_pesoSelecionado != null) {
       lista.add(DataRow(cells: [
        DataCell(fontePadrao("Data da Pesagem")),
        DataCell(fontePadrao(exibicaoDataPadrao(_pesoSelecionado.data)))
      ]));
       lista.add(DataRow(cells: [
        DataCell(fontePadrao("Peso Registrado")),
        DataCell(fontePadrao(_pesoSelecionado.peso + " KG"))
      ]));
    } else if(_observacaoSelecionada != null){
       lista.add(DataRow(cells: [
        DataCell(fontePadrao("Data da Observação")),
        DataCell(fontePadrao(exibicaoDataPadrao(_observacaoSelecionada.data)))
      ]));
       lista.add(DataRow(cells: [
        DataCell(fontePadrao("Observação")),
        DataCell(fontePadrao(_observacaoSelecionada.descricao))
      ]));
    }else if(_ordenhaSelecionada != null){
       lista.add(DataRow(cells: [
        DataCell(fontePadrao("Data da Pesagem")),
        DataCell(fontePadrao(exibicaoDataPadrao(_ordenhaSelecionada.data)))
      ]));
       lista.add(DataRow(cells: [
        DataCell(fontePadrao("Peso Registrado")),
        DataCell(fontePadrao(_ordenhaSelecionada.peso + " KG"))
      ]));
    }

    return lista;
  }

  Text fontePadrao(String texto) {
    return Text(
      texto,
      style: TextStyle(fontSize: 13),
      textAlign: TextAlign.center,
    );
  }
}
