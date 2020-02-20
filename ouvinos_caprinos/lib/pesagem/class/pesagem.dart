import 'package:ouvinos_caprinos/pesagem/db/pesagem_database.dart';

class Pesagem{

  int idPesagem;
  int idAnimal;
  String data;
  String peso;


  Pesagem(
    {
      this.idPesagem,
      this.idAnimal,
      this.data,
      this.peso,
    }
  );

  Pesagem.fromMap(Map map) {
  idPesagem = map[idPesagemColumn];
  idAnimal = map[idAnimalColumn];
  data = map[dataColumn];
  peso = map[pesoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idAnimalColumn: idAnimal,
      dataColumn: data,
      pesoColumn: peso 
    };
    if (idPesagem != null) {
      map[idPesagem.toString()] = idPesagem;
    }
    return map;
  }

   @override
  String toString() {
    return "Pesagem(id: $idPesagem, peso:$peso )";
  }
  
  

}