import 'package:ouvinos_caprinos/raca/db/raca_database.dart';

class Raca{

  int id;
  String descricao;


  Raca({this.id,this.descricao});

  Raca.fromMap(Map map) {
  id = map[idRacaColumn];
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
    return "Raca(id: $id, descricao:$descricao )";
  }
  
}