import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RelatorioAnaliticoPage extends StatefulWidget {
  @override
  _RelatorioAnaliticoPageState createState() => _RelatorioAnaliticoPageState();
}

String dropdownValue = 'CAPRINO';

class _RelatorioAnaliticoPageState extends State<RelatorioAnaliticoPage> {
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

    Divider divider = Divider(
      color: Colors.black,
      height: 1,
      thickness: 1,
      indent: 2,
      endIndent: 0,
    );

    lista.add(
      DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
                print(dropdownValue);
              });
            },
            items: <String>['CAPRINO', 'OUVINO']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );

    lista.add(divider);

    lista.add(configTexto("Total de animais Disponíveis:"));
    lista.add(configTexto("Total de animais Vendidos:"));
    lista.add(configTexto("Total de animais Mortos:"));

    lista.add(divider);

    lista.add(configTexto("Machos:"));
    lista.add(configTexto("Fêmeas: "));

    lista.add(divider);

    lista.add(configTexto("0-6 meses:"));
    lista.add(configTexto("7-12 meses:"));
    lista.add(configTexto("13-18 meses:"));
    lista.add(configTexto("19-24 meses:"));
    lista.add(configTexto("25-36 meses:"));
    lista.add(configTexto("mais que 36 meses:"));

    lista.add(divider);

    lista.add(configTexto("Cria:"));
    lista.add(configTexto("Recria:"));
    lista.add(configTexto("Terminação:"));

    lista.add(divider);

    if (dropdownValue.toLowerCase() == "caprino") {
    } else if (dropdownValue.toLowerCase() == "ouvino") {}

    return lista;
  }

  Padding configTexto(String texto) {
    return Padding(padding: EdgeInsets.all(10.0), child: Text(texto));
  }
}
