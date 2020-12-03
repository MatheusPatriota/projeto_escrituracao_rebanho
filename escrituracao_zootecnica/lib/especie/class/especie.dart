import 'package:escrituracao_zootecnica/especie/db/especie_database.dart';

class Especie {
  int id;
  String descricao;

  Especie({this.id, this.descricao});

  Especie.fromMap(Map map) {
    id = map[idEspecieColumn];
    descricao = map[descricaoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {descricaoColumn: descricao};
    if (id != null) {
      map[id.toString()] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Especie(id: $id, descricao:$descricao )";
  }
}
