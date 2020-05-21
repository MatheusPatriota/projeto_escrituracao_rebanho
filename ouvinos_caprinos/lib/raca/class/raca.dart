import 'package:ouvinos_caprinos/raca/db/raca_database.dart';

class Raca{

  int id;
  int especieId;
  String descricao;
  String descricaoMestico;


  Raca({this.id,this.especieId,this.descricao, this.descricaoMestico});

  Raca.fromMap(Map map) {
  id = map[idRacaColumn];
  especieId = map[especieIdColumn];
  descricao = map[descricaoColumn];
  descricaoMestico = map[descricaoMesticoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      especieIdColumn: especieId,
      descricaoColumn: descricao,
      descricaoMesticoColumn : descricaoMestico,
    };
    if (id != null) {
      map[id.toString()] = id;
    }
    return map;
  }

   @override
  String toString() {
    return "Raca(id: $id, especie: $especieId descricao:$descricao, descricaoMestico: $descricaoMestico)";
  }
  
}