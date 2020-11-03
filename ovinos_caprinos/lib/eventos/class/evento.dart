import 'package:ovinos_caprinos/eventos/class/enumerate_enventos.dart';

class Evento {
  int idEvento;
  String descricao;
  Eventos tipoEvento;
  String data;

  Evento({this.idEvento, this.data, this.tipoEvento, this.descricao});

  @override
  String toString() {
    return "Evento(id: $idEvento,data: $data,, tipo:$tipoEvento,)";
  }
}
