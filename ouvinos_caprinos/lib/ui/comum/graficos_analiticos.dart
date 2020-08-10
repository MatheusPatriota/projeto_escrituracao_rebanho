import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/raca/class/raca.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';

class GraficosAnaliticosPage extends StatefulWidget {
  final int especieId;
  final List<Animal> animaisSelecionados;
  final List<Raca> listaDeRacas;
  GraficosAnaliticosPage(
      {this.especieId, this.animaisSelecionados, this.listaDeRacas});

  _GraficosAnaliticosPageState createState() => _GraficosAnaliticosPageState();
}

class _GraficosAnaliticosPageState extends State<GraficosAnaliticosPage> {
  List<charts.Series<AnimaisRaca, String>> _graficoQtdAnimaisRaca = List();
  List<charts.Series<MortosRaca, String>> _graficoQtdMortosRaca = List();
  List<charts.Series<EvolucaoRebanho, DateTime>> _graficoEvolucaoRebanho =
      List();

  List<Animal> listaFinal = List();
  List<int> idsRacasAnimais = List();
  List<int> idsAnimaisMortos = List();

  _ordenaPorData() {
    for (var ani in widget.animaisSelecionados) {
      listaFinal.add(ani);
      idsRacasAnimais.add(ani.idRaca);
      if (ani.status == "2") {
        idsAnimaisMortos.add(ani.idRaca);
      }
    }

    if (widget.animaisSelecionados.isNotEmpty) {
      Comparator<Animal> dataComparator = (a, b) {
        DateTime dateTimeA =
            DateTime.parse("${a.dataNascimento}" + " 00:00:00");
        DateTime dateTimeB =
            DateTime.parse("${b.dataNascimento}" + " 00:00:00");
        return dateTimeA.compareTo(dateTimeB);
      };
      listaFinal.sort(dataComparator);
      listaFinal.forEach((Animal item) {
        print('${item.idAnimal} - ${item.dataNascimento} - ${item.idRaca}');
      });
    }
  }

  _generateData() {
    //inicializacoes necessarias
    _ordenaPorData();
    //paleta e cores
    List<Color> listaDeCores = [
      Color(0xff3366cc),
      Color(0xff990099),
      Color(0xff109618),
      Color(0xfffdbe19),
      Color(0xffff9900),
      Color(0xffdc3912),
      Colors.black,
      Colors.amber[500],
      Colors.grey,
      Colors.lime,
      Colors.white60,
      Colors.blueAccent,
    ];

    // animais mortos por raca
    List<MortosRaca> qtdMortosRaca = List();
    int contadorAnimaisMortos = 0;
    for (var raca in widget.listaDeRacas) {
      int ocorrencias = count(idsAnimaisMortos, raca.id);
      if (ocorrencias > 0) {
        qtdMortosRaca.add(new MortosRaca(
            raca.descricao, ocorrencias, listaDeCores[contadorAnimaisMortos]));
      }
      contadorAnimaisMortos++;
    }

    // quantidade de animais por raca
    List<AnimaisRaca> qtdAnimaisRaca = List();

    int contadorAnimaisPorRaca = 0;
    for (var raca in widget.listaDeRacas) {
      int ocorrencias = count(idsRacasAnimais, raca.id);
      if (ocorrencias > 0) {
        qtdAnimaisRaca.add(new AnimaisRaca(
            raca.descricao, ocorrencias, listaDeCores[contadorAnimaisPorRaca]));
      }
      contadorAnimaisPorRaca++;
    }

    //evolucao do rebanho
    List<EvolucaoRebanho> evolucaoRebanho = [];
    evolucaoRebanho.add(new EvolucaoRebanho(new DateTime(2020, 1, 1), 0));
    int contadorAnimais = 0;
    for (var ani in listaFinal) {
      contadorAnimais++;
      List<String> data = ani.dataNascimento.split("-");
      evolucaoRebanho.add(EvolucaoRebanho(
          DateTime(int.parse(data[0]), int.parse(data[1]), int.parse(data[2])),
          contadorAnimais));
    }

    //adicionando ao grafico e animais por raca
    _graficoQtdAnimaisRaca.add(
      charts.Series(
        domainFn: (AnimaisRaca raca, _) => raca.raca,
        measureFn: (AnimaisRaca raca, _) => raca.qtdAnimais,
        colorFn: (AnimaisRaca raca, _) =>
            charts.ColorUtil.fromDartColor(raca.cor),
        id: 'Animais por Raca',
        data: qtdAnimaisRaca,
        labelAccessorFn: (AnimaisRaca row, _) => '${row.qtdAnimais}',
      ),
    );

    //adicionando ao grafico e animais por raca
    _graficoQtdMortosRaca.add(
      charts.Series(
        domainFn: (MortosRaca raca, _) => raca.raca,
        measureFn: (MortosRaca raca, _) => raca.qtdMortos,
        colorFn: (MortosRaca raca, _) =>
            charts.ColorUtil.fromDartColor(raca.cor),
        id: 'Animais por Raca',
        data: qtdMortosRaca,
        labelAccessorFn: (MortosRaca row, _) => '${row.qtdMortos}',
      ),
    );

    //adicionano ao grafico de evolucao do rebanho
    _graficoEvolucaoRebanho.add(
      charts.Series<EvolucaoRebanho, DateTime>(
        id: 'EvolucaoRebanho',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (EvolucaoRebanho evolucao, _) => evolucao.time,
        measureFn: (EvolucaoRebanho evolucao, _) => evolucao.qtdAnimais,
        data: evolucaoRebanho,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // _graficoQtdAnimaisRaca = List<charts.Series<AnimaisRaca, String>>();
    // _graficoQtdMortosRaca = List<charts.Series<MortosRaca, String>>();
    _graficoEvolucaoRebanho = List<charts.Series<EvolucaoRebanho, DateTime>>();

    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green,
          bottom: TabBar(
            indicatorColor: Color(0xff9962D0),
            tabs: [
              Tab(
                icon: Icon(FontAwesomeIcons.chartLine),
              ),
              Tab(icon: Icon(FontAwesomeIcons.chartPie)),
              Tab(icon: Icon(Icons.pie_chart)),
              // Tab(icon: Icon(FontAwesomeIcons.solidChartBar)),
            ],
          ),
          title: Text('Gráficos Analíticos'),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Evolução do Rebanho',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: charts.TimeSeriesChart(
                          _graficoEvolucaoRebanho,
                          animate: false,
                          dateTimeFactory: const charts.LocalDateTimeFactory(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Quantidade de animais por Raça',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: charts.PieChart(
                          _graficoQtdAnimaisRaca,
                          animate: true,
                          animationDuration: Duration(seconds: 5),
                          behaviors: [
                            new charts.DatumLegend(
                              outsideJustification:
                                  charts.OutsideJustification.endDrawArea,
                              horizontalFirst: false,
                              desiredMaxRows: 2,
                              cellPadding:
                                  new EdgeInsets.only(right: 4.0, bottom: 4.0),
                              entryTextStyle: charts.TextStyleSpec(
                                  color: charts
                                      .MaterialPalette.purple.shadeDefault,
                                  fontFamily: 'Georgia',
                                  fontSize: 11),
                            )
                          ],
                          defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 100,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator(
                                  labelPosition: charts.ArcLabelPosition.inside)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Quantidade de animais Mortos por Raça',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: charts.PieChart(
                          _graficoQtdMortosRaca,
                          animate: true,
                          animationDuration: Duration(seconds: 5),
                          behaviors: [
                            new charts.DatumLegend(
                              outsideJustification:
                                  charts.OutsideJustification.endDrawArea,
                              horizontalFirst: false,
                              desiredMaxRows: 2,
                              cellPadding:
                                  new EdgeInsets.only(right: 4.0, bottom: 4.0),
                              entryTextStyle: charts.TextStyleSpec(
                                  color: charts
                                      .MaterialPalette.purple.shadeDefault,
                                  fontFamily: 'Georgia',
                                  fontSize: 11),
                            )
                          ],
                          defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 100,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator(
                                  labelPosition: charts.ArcLabelPosition.inside)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //  Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Container(
            //     child: Center(
            //       child: Column(
            //         children: <Widget>[
            //           Text(
            //             'Evolução do Rebanho',
            //             style: TextStyle(
            //                 fontSize: 24.0, fontWeight: FontWeight.bold),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// classes para dados

class AnimaisRaca {
  String raca;
  int qtdAnimais;
  Color cor;

  AnimaisRaca(this.raca, this.qtdAnimais, this.cor);
}

class MortosRaca {
  String raca;
  int qtdMortos;
  Color cor;

  MortosRaca(this.raca, this.qtdMortos, this.cor);
}

class EvolucaoRebanho {
  DateTime time;
  int qtdAnimais;

  EvolucaoRebanho(this.time, this.qtdAnimais);
}

class AnimaisIdade {
  String idade;
  int qtdAnimais;

  AnimaisIdade(this.idade, this.qtdAnimais);
}
