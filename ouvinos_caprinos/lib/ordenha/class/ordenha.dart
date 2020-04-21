import 'package:ouvinos_caprinos/ordenha/db/ordenha_database.dart';

class Ordenha{

  int idOrdenha;
  int animalId;
  String data;
  String peso;


  Ordenha(
    {
      this.idOrdenha,
      this.animalId,
      this.data,
      this.peso,
    }
  );

  Ordenha.fromMap(Map map) {
  idOrdenha = map[idOrdenhaColumn];
  animalId = map[idAnimalColumn];
  data = map[dataColumn];
  peso = map[pesoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idAnimalColumn: animalId,
      dataColumn: data,
      pesoColumn: peso 
    };
    if (idOrdenha != null) {
      map[idOrdenhaColumn] = idOrdenha;
    }
    return map;
  }

   @override
  String toString() {
    return "Ordenha(id: $idOrdenha, idAnimal:$animalId, descricao:$peso )";
  }
  
  

}