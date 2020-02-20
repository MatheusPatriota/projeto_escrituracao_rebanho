import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/tratamento/class/tratamento.dart';
import 'package:ouvinos_caprinos/ui/comum/tratamento_page.dart';

String ehvazio(dynamic a){
  String stringFinal = a;
  if (a == null){
    stringFinal = "Não Informado";
  }
  return stringFinal;
}

String idadeAnimal(String ano, String mes){
  DateTime _dataAtual = new DateTime.now();
  String anoAtual ="${_dataAtual.year}";
  String mesAtual ="${_dataAtual.month}";
  String resultado = "";
  int anos = int.parse(anoAtual) - int.parse(ano);
  int meses = int.parse(mesAtual) - int.parse(mes);

  if(anos >=1){
    resultado = anos.toString() +" ano(s) e " + meses.toString() +" meses";
  } else{
    resultado = meses.toString() +" meses";
  }

  return resultado;

}

String slice(String subject, [int start = 0, int end]) {
  if (subject is! String) {
    return '';
  }

  int _realEnd;
  int _realStart = start < 0 ? subject.length + start : start;
  if (end is! int) {
    _realEnd = subject.length;
  } else {
    _realEnd = end < 0 ? subject.length + end : end;
  }

  return subject.substring(_realStart, _realEnd);
}

