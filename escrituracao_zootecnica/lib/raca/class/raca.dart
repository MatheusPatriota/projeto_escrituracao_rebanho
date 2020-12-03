import 'package:escrituracao_zootecnica/raca/db/raca_database.dart';

class Raca {
  int id;
  int especieId;
  String descricao;

  Raca({this.id, this.especieId, this.descricao});

  Raca.fromMap(Map map) {
    id = map[idRacaColumn];
    especieId = map[especieIdColumn];
    descricao = map[descricaoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      especieIdColumn: especieId,
      descricaoColumn: descricao,
    };
    if (id != null) {
      map[id.toString()] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Raca(id: $id, especie: $especieId descricao:$descricao)";
  }
}
