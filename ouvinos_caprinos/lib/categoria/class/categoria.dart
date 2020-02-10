import 'package:ouvinos_caprinos/categoria/db/categoria_database.dart';

class Categoria{

  int id;
  String descricao;


  Categoria(
    {
      this.id,
      this.descricao,
    }
  );

  Categoria.fromMap(Map map) {
  id = map[idCategoriaColumn];
  descricao = map[descricaoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      descricaoColumn: descricao 
    };
    if (id != null) {
      map[id.toString()] = id;
    }
    return map;
  }

   @override
  String toString() {
    return "Categoria(id: $id, descricao:$descricao )";
  }
  
  

}