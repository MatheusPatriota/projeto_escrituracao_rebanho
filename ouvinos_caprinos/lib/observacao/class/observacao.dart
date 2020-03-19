
import 'package:ouvinos_caprinos/observacao/db/observacao_database.dart';

class Observacao{

  int idObservacao;
  int animalId;
  String data;
  String descricao;


  Observacao(
    {
      this.idObservacao,
      this.animalId,
      this.data,
      this.descricao,
    }
  );

  Observacao.fromMap(Map map) {
  idObservacao = map[idObservacaoColumn];
  animalId = map[idAnimalColumn];
  data = map[dataColumn];
  descricao = map[descricaoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idAnimalColumn: animalId,
      dataColumn: data,
      descricaoColumn: descricao 
    };
    if (idObservacao != null) {
      map[idObservacaoColumn] = idObservacao;
    }
    return map;
  }

   @override
  String toString() {
    return "Observacao(id: $idObservacao, descricao:$descricao )";
  }
  
  

}