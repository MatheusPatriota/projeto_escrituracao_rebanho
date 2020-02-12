import 'package:ouvinos_caprinos/animal/db/animal_database.dart';

class Animal {
  int idAnimal;
  int idCategoria;
  int idRaca;
  int idEspecie;
  int idPai;
  int idMae;
  String status;
  String nome;
  String sexo;
  String brincoControle;
  String dataNascimento;
  String dataAquisicao;
  String valorAquisicao;
  String nomeVendedor;
  String patrimonio;
  String img;

  Animal(
      {this.idAnimal,
      this.idEspecie,
      this.status,
      this.nome,
      this.sexo,
      this.idCategoria,
      this.idRaca,
      this.brincoControle,
      this.idPai,
      this.idMae,
      this.dataNascimento,
      this.dataAquisicao,
      this.nomeVendedor,
      this.patrimonio,
      this.img});

  Animal.fromMap(Map map) {
    idAnimal = map[idAnimalColumn];
    idEspecie = map[idEspecieColumn];
    status = map[statusAnimalColumn];
    nome = map[nomeColumn];
    sexo = map[sexoColumn];
    idCategoria = map[idCategoriaColumn];
    idRaca = map[idRacaColumn];
    brincoControle = map[brincoControle];
    idPai = map[idPaiColumn];
    idMae = map[idMaeColumn];
    dataNascimento = map[dataNascimentoColumn];
    dataAquisicao = map[dataAquisicaoColumn];
    valorAquisicao = map[valorAquisicaoColumn];
    nomeVendedor = map[nomeVendedorColumn];
    patrimonio = map[patriomionioColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idEspecieColumn: idEspecie,
      statusAnimalColumn: status,
      nomeColumn: nome,
      sexoColumn: sexo,
      idCategoriaColumn: idCategoria,
      idRacaColumn: idRaca,
      brincoControleColumn: brincoControle,
      idPaiColumn: idPai,
      idMaeColumn: idMae,
      dataNascimentoColumn: dataNascimento,
      dataAquisicaoColumn: dataAquisicao,
      valorAquisicaoColumn: valorAquisicao,
      patriomionioColumn: patrimonio,
      nomeVendedorColumn: nomeVendedor,
      imgColumn: img
    };
    if (idAnimal != null) {
      map[idAnimalColumn] = idAnimal;
    }
    return map;
  }

  @override
  String toString() {
    return "Animal(idAnimal: $idAnimal, idEspecie:$idEspecie, name: $nome, sexo:$sexo, idCategoria:$idCategoria ,idRaca: $idRaca, brinco de controle:$brincoControle, idPai:$idPai, idMae:$idMae, data de nascimento:$dataNascimento, data de aquisicao:$dataAquisicao, valor de aquisicao: $valorAquisicao, nome do vendedor:$nomeVendedor, patrimonio:$patrimonio, img: $img)";
  }
}
