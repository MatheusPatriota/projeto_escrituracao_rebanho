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
