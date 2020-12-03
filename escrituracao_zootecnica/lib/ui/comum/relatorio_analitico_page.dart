import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:escrituracao_zootecnica/animal/class/animal.dart';
import 'package:escrituracao_zootecnica/animal/db/animal_database.dart';
import 'package:escrituracao_zootecnica/raca/class/raca.dart';
import 'package:escrituracao_zootecnica/util/funcoes.dart';

class RelatorioAnaliticoPage extends StatefulWidget {
  final int especieId;
  final List<Animal> animaisSelecionados;
  final List<Raca> listaDeRacas;
  RelatorioAnaliticoPage(
      {this.especieId, this.animaisSelecionados, this.listaDeRacas});
  @override
  _RelatorioAnaliticoPageState createState() => _RelatorioAnaliticoPageState();
}

AnimalHelper animalHelper = AnimalHelper();

String nome = "";
int animaisDiponiveis = 0;
int animaisMortos = 0;
int animaisVendidos = 0;
int machos = 0;
int femeas = 0;
int zeroSeis = 0;
int seteDoze = 0;
int trezeDezoito = 0;
int dezenoveVinteQuatro = 0;
int vinteCincoTrintaSeis = 0;
int maisqueTrintaSeis = 0;
int cria = 0;
int recria = 0;
int terminacao = 0;
List<int> idsRacasAnimais = List();
List<String> racas = List();

class _RelatorioAnaliticoPageState extends State<RelatorioAnaliticoPage> {
  void _getAllAnimals() {
    print(widget.animaisSelecionados.length);
    for (var ani in widget.animaisSelecionados) {
      if (ani.idEspecie == 1) {
        nome = "CAPRINOS";
      } else {
        nome = "OVINOS";
      }
      // status animal
      if (ani.status == "0") {
        animaisDiponiveis += 1;
      } else if (ani.status == "1") {
        animaisVendidos += 1;
      } else if (ani.status == "2") {
        animaisMortos += 1;
      }

      //sexo
      if (ani.sexo == "Macho") {
        machos += 1;
      } else if (ani.sexo == "Fêmea") {
        femeas += 1;
      }

      //idade
      List<String> dataSplitada = ani.dataNascimento.split("-");
      int idadeAni =
          int.parse(idadeAnimal(dataSplitada[0], dataSplitada[1], condicao: 0));
      if (idadeAni >= 0 && idadeAni <= 6) {
        zeroSeis += 1;
      } else if (idadeAni >= 7 && idadeAni <= 12) {
        seteDoze += 1;
      } else if (idadeAni >= 13 && idadeAni <= 18) {
        trezeDezoito += 1;
      } else if (idadeAni >= 19 && idadeAni <= 24) {
        dezenoveVinteQuatro += 1;
      } else if (idadeAni >= 25 && idadeAni <= 36) {
        vinteCincoTrintaSeis += 1;
      } else if (idadeAni >= 36) {
        maisqueTrintaSeis += 1;
      }

      //cria, recria, terminação
      if (ani.idCategoria == 1) {
        cria += 1;
      } else if (ani.idCategoria == 2) {
        recria += 1;
      } else if (ani.idCategoria == 3) {
        terminacao += 1;
      }

      // raca do animal
      idsRacasAnimais.add(ani.idRaca);
    }

    for (var raca in widget.listaDeRacas) {
      int ocorrencias = count(idsRacasAnimais, raca.id);
      if (ocorrencias > 0) {
        racas.add(raca.descricao + ": " + ocorrencias.toString());
      }
    }
    setState(() {
      print("ok");
    });
  }

  @override
  void initState() {
    animaisDiponiveis = 0;
    animaisMortos = 0;
    animaisVendidos = 0;
    machos = 0;
    femeas = 0;
    zeroSeis = 0;
    seteDoze = 0;
    trezeDezoito = 0;
    dezenoveVinteQuatro = 0;
    vinteCincoTrintaSeis = 0;
    maisqueTrintaSeis = 0;
    cria = 0;
    recria = 0;
    terminacao = 0;
    idsRacasAnimais = List();
    racas = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatório Analítico"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: relatorioGerado(),
        ),
      ),
    );
  }

  List<Widget> relatorioGerado() {
    List<Widget> lista = List();
    _getAllAnimals();
    Divider divider = Divider(
      color: Colors.black,
      height: 1,
      thickness: 1,
      indent: 2,
      endIndent: 0,
    );

    lista.add(configTexto("RELATÓRIO DOS ANIMAIS " + nome));

    lista.add(divider);

    //status dos animais
    lista.add(configTexto(
        "Total de animais Disponíveis: " + animaisDiponiveis.toString()));
    lista.add(configTexto(
        "Total de animais Vendidos: " + animaisVendidos.toString()));
    lista.add(
        configTexto("Total de animais Mortos: " + animaisMortos.toString()));

    lista.add(divider);

    //sexo do animais
    lista.add(configTexto("Machos: " + machos.toString()));
    lista.add(configTexto("Fêmeas: " + femeas.toString()));

    lista.add(divider);

    //idades dos animais
    lista.add(configTexto("0-6 meses: " + zeroSeis.toString()));
    lista.add(configTexto("7-12 meses: " + seteDoze.toString()));
    lista.add(configTexto("13-18 meses: " + trezeDezoito.toString()));
    lista.add(configTexto("19-24 meses: " + dezenoveVinteQuatro.toString()));
    lista.add(configTexto("25-36 meses: " + vinteCincoTrintaSeis.toString()));
    lista
        .add(configTexto("mais que 36 meses: " + maisqueTrintaSeis.toString()));

    lista.add(divider);

    // categorias dos animais
    lista.add(configTexto("Cria: " + cria.toString()));
    lista.add(configTexto("Recria: " + recria.toString()));
    lista.add(configTexto("Terminação: " + terminacao.toString()));

    lista.add(divider);

    // racas dos animais
    for (var raca in racas) {
      lista.add(configTexto(raca));
    }

    return lista;
  }

  Padding configTexto(String texto) {
    return Padding(padding: EdgeInsets.all(10.0), child: Text(texto));
  }
}
