import 'package:flutter/material.dart';

String ehvazio(dynamic a) {
  String stringFinal = a;
  if (a == null) {
    stringFinal = "Não Informado";
  }
  return stringFinal;
}

String idadeAnimal(String ano, String mes) {
  DateTime _dataAtual = new DateTime.now();
  String anoAtual = "${_dataAtual.year}";
  String mesAtual = "${_dataAtual.month}";
  String resultado = "";
  int anos = int.parse(anoAtual) - int.parse(ano);
  int meses = (int.parse(mesAtual) - int.parse(mes));

  if(meses <0){meses = meses+12;}
  if (anos >= 1 && int.parse(mes) <= int.parse(mesAtual)) {
    resultado = anos.toString() + " ano(s) e " + meses.toString() + " meses";
  } else {
    resultado = meses.toString() + " meses";
  }

  return resultado;
}

// tipo 1 para texto, tipo 2 para valores de compra
InputDecoration estiloPadrao(String texto, int tipo) {
  if (tipo == 1) {
    return InputDecoration(
      border: OutlineInputBorder(),
      labelText: '$texto',
    );
  } else {
    return InputDecoration(
      border: OutlineInputBorder(),
      labelText: '$texto',
      prefixText: "R\$",
    );
  }
}

Container espacamentoPadrao(){
  return Container(
    padding: EdgeInsets.all(5.0),
  );
}
