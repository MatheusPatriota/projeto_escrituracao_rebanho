import 'package:ovinos_caprinos/categoria/db/categoria_database.dart';

class Categoria {
  int id;
  int especieId;
  String descricao;

  Categoria({
    this.id,
    this.especieId,
    this.descricao,
  });

  Categoria.fromMap(Map map) {
    id = map[idCategoriaColumn];
    especieId = map[especieIdColumn];
    descricao = map[descricaoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      especieIdColumn: especieId,
      descricaoColumn: descricao
    };
    if (id != null) {
      map[id.toString()] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Categoria(id: $id, especie: $especieId ,descricao:$descricao )";
  }
}
