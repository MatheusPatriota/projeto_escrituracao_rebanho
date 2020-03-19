import 'package:ouvinos_caprinos/tratamento/db/tratamento_database.dart';

class Tratamento {
  int idTratamento;
  int animalId;
  String data;
  String motivo;
  String medicacao;
  String periodoCarencia;
  String custo;
  String anotacoes;

  Tratamento({
    this.idTratamento,
    this.animalId,
    this.data,
    this.motivo,
    this.medicacao,
    this.periodoCarencia,
    this.custo,
    this.anotacoes,
  });

  Tratamento.fromMap(Map map) {
    idTratamento = map[idTratamentoColumn];
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
    if (idTratamento != null) {
      map[idTratamentoColumn] = idTratamento;
    }
    return map;
  }

  @override
  String toString() {
    return "Tratamento(id: $idTratamento,animalId: $animalId, medicacao: $medicacao, pc: $periodoCarencia, custo: $custo, anotacoes:$anotacoes )";
  }
}
