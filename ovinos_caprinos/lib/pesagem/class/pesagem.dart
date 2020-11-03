import 'package:ovinos_caprinos/pesagem/db/pesagem_database.dart';

class Pesagem {
  int idPesagem;
  int animalId;
  String data;
  String peso;

  Pesagem({
    this.idPesagem,
    this.animalId,
    this.data,
    this.peso,
  });

  Pesagem.fromMap(Map map) {
    idPesagem = map[idPesagemColumn];
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
    if (idPesagem != null) {
      map[idPesagemColumn] = idPesagem;
    }
    return map;
  }

  @override
  String toString() {
    return "Pesagem(id: $idPesagem,data: $data,animalId: $animalId, peso:$peso )";
  }
}
