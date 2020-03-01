import 'package:ouvinos_caprinos/tratamento/db/tratamento_database.dart';

class Tratamento {
  int id;
  int animalId;
  String data;
  String motivo;
  String medicacao;
  String periodoCarencia;
  String custo;
  String anotacoes;

  Tratamento({
    this.id,
    this.animalId,
    this.data,
    this.motivo,
    this.medicacao,
    this.periodoCarencia,
    this.custo,
    this.anotacoes,
  });

  Tratamento.fromMap(Map map) {
    id = map[idTratamentoColumn];
    animalId = map[animalIdColumn];
    data = map[dataColumn];
    motivo = map[motivoColumn];
    medicacao = map[medicacaoColumn];
    periodoCarencia = map[periodoCarenciaColumn];
    custo = map[custoColumn];
    anotacoes = map[anotacoesColumn];

  }

  Map toMap() {
    Map<String, dynamic> map = {
      animalIdColumn: animalId,
      dataColumn: data,
      motivoColumn: motivo,
      medicacaoColumn: medicacao,
      periodoCarenciaColumn: periodoCarencia,
      custoColumn: custo,
      anotacoesColumn: anotacoes
      };
    if (id != null) {
      map[id.toString()] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Tratamento(id: $id,animalId: $animalId, medicacao: $medicacao, custo: $custo, anotacoes:$anotacoes )";
  }
}
