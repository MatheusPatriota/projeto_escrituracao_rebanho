import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/raca/class/raca.dart';

class GraficosAnaliticosPage extends StatefulWidget {
  final int especieId;
  final List<Animal> animaisSelecionados;
  final List<Raca> listaDeRacas;
  GraficosAnaliticosPage(
      {this.especieId, this.animaisSelecionados, this.listaDeRacas});

  _GraficosAnaliticosPageState createState() => _GraficosAnaliticosPageState();
}

class _GraficosAnaliticosPageState extends State<GraficosAnaliticosPage> {
  List<charts.Series<AnimaisRaca, int>> _graficoQtdAnimaisRaca;
  List<charts.Series<MortosRaca, int>> _graficoQtdMortosRaca;
  List<charts.Series<EvolucaoRebanho, DateTime>> _graficoEvolucaoRebanho;

  _generateData() {
    // mortes por raca
    var qtdMortosRaca = [
      // new MortosRaca('Work', 35.8, Color(0xff3366cc)),
      // new MortosRaca('Eat', 8.3, Color(0xff990099)),
      // new MortosRaca('Commute', 10.8, Color(0xff109618)),
      // new MortosRaca('TV', 15.6, Color(0xfffdbe19)),
      // new MortosRaca('Sleep', 19.2, Color(0xffff9900)),
      // new MortosRaca('Other', 10.3, Color(0xffdc3912)),
    ];
    // quantidade de animais por raca
    var qtdAnimaisRaca = [
      // new MortosRaca('Work', 35.8, Color(0xff3366cc)),
      // new MortosRaca('Eat', 8.3, Color(0xff990099)),
      // new MortosRaca('Commute', 10.8, Color(0xff109618)),
      // new MortosRaca('TV', 15.6, Color(0xfffdbe19)),
      // new MortosRaca('Sleep', 19.2, Color(0xffff9900)),
      // new MortosRaca('Other', 10.3, Color(0xffdc3912)),
    ];

    var evolucaoRebanho = [
      new EvolucaoRebanho(new DateTime(2017, 9, 19), 5),
      new EvolucaoRebanho(new DateTime(2017, 9, 26), 25),
      new EvolucaoRebanho(new DateTime(2017, 10, 3), 100),
      new EvolucaoRebanho(new DateTime(2017, 10, 10), 110),
      new EvolucaoRebanho(new DateTime(2018, 2, 19), 100),
      new EvolucaoRebanho(new DateTime(2018, 3, 26), 125),
      new EvolucaoRebanho(new DateTime(2018, 5, 3), 150),
      new EvolucaoRebanho(new DateTime(2018, 7, 10), 175),
    ];

    // _graficoQtdAnimaisRaca.add(
    //   charts.Series(
    //     domainFn: (AnimaisRaca pollution, _) => pollution.raca,
    //     measureFn: (AnimaisRaca pollution, _) => pollution.quantity,
    //     id: '2017',
    //     data: data1,
    //     fillPatternFn: (_, __) => charts.FillPatternType.solid,
    //     fillColorFn: (AnimaisRaca pollution, _) =>
    //         charts.ColorUtil.fromDartColor(Color(0xff990099)),
    //   ),
    // );

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
      length: 1,
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
              // Tab(icon: Icon(FontAwesomeIcons.chartPie)),
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
          ],
        ),
      ),
    );
  }
}

// classes para dados

class AnimaisRaca {
  String raca;
  int qtdMortos;
  Color cor;

  AnimaisRaca(this.qtdMortos, this.raca, this.cor);
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
