
import 'package:ouvinos_caprinos/observacao/db/observacao_database.dart';

class Observacao{

  int idObservacao;
  int idAnimal;
  String data;
  String descricao;


  Observacao(
    {
      this.idObservacao,
      this.idAnimal,
      this.data,
      this.descricao,
    }
  );

  Observacao.fromMap(Map map) {
  idObservacao = map[idObservacaoColumn];
  idAnimal = map[idAnimalColumn];
  data = map[dataColumn];
  descricao = map[descricaoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idAnimalColumn: idAnimal,
      dataColumn: data,
      descricaoColumn: descricao 
    };
    if (idObservacao != null) {
      map[idObservacao.toString()] = idObservacao;
    }
    return map;
  }

   @override
  String toString() {
    return "Observacao(id: $idObservacao, descricao:$descricao )";
  }
  
  

}