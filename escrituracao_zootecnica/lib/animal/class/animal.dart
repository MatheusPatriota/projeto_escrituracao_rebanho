import 'package:escrituracao_zootecnica/animal/db/animal_database.dart';

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
  String imgMorte;
  String dataMorte;
  String descricaoMorte;
  String dataRemocao;
  String dataVendaAnimal;
  String motivoRemocao;
  String valorVenda;
  String nomeComprador;
  String anotacoesVenda;
  String descricaoMestico;
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
      this.img,
      this.imgMorte,
      this.dataMorte,
      this.descricaoMorte,
      this.dataRemocao,
      this.dataVendaAnimal,
      this.motivoRemocao,
      this.valorVenda,
      this.nomeComprador,
      this.anotacoesVenda,
      this.descricaoMestico});

  Animal.fromMap(Map map) {
    idAnimal = map[idAnimalColumn];
    idEspecie = map[idEspecieColumn];
    status = map[statusAnimalColumn];
    nome = map[nomeColumn];
    sexo = map[sexoColumn];
    idCategoria = map[idCategoriaColumn];
    idRaca = map[idRacaColumn];
    brincoControle = map[brincoControleColumn];
    idPai = map[idPaiColumn];
    idMae = map[idMaeColumn];
    dataNascimento = map[dataNascimentoColumn];
    dataAquisicao = map[dataAquisicaoColumn];
    valorAquisicao = map[valorAquisicaoColumn];
    nomeVendedor = map[nomeVendedorColumn];
    patrimonio = map[patriomionioColumn];
    img = map[imgColumn];
    imgMorte = map[imgMorteColumn];
    dataMorte = map[dataMorteColumn];
    descricaoMorte = map[descricaoMorteColumn];
    dataRemocao = map[dataRemocaoColumn];
    dataVendaAnimal = map[dataVendaAnimalColumn];
    motivoRemocao = map[motivoRemocaoColumn];
    valorVenda = map[valorVendaColumn];
    nomeComprador = map[nomeCompradorColumn];
    anotacoesVenda = map[anotacoesVendaColumn];
    descricaoMestico = map[descricaoMesticoColumn];
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
      imgColumn: img,
      imgMorteColumn: imgMorte,
      dataMorteColumn: dataMorte,
      descricaoMorteColumn: descricaoMorte,
      dataRemocaoColumn: dataRemocao,
      dataVendaAnimalColumn: dataVendaAnimal,
      motivoRemocaoColumn: motivoRemocao,
      valorVendaColumn: valorVenda,
      nomeCompradorColumn: nomeComprador,
      anotacoesVendaColumn: anotacoesVenda,
      descricaoMesticoColumn: descricaoMestico,
    };
    if (idAnimal != null) {
      map[idAnimalColumn] = idAnimal;
    }
    return map;
  }

  @override
  String toString() {
    return "Animal(idAnimal: $idAnimal, idEspecie:$idEspecie, name: $nome, status: $status,sexo:$sexo, idCategoria:$idCategoria ,idRaca: $idRaca, brinco de controle:$brincoControle, idPai:$idPai, idMae:$idMae, data de nascimento:$dataNascimento, data de aquisicao:$dataAquisicao, valor de aquisicao: $valorAquisicao, nome do vendedor:$nomeVendedor, patrimonio:$patrimonio, img: $img, imgMorte: $imgMorte, dataMorte: $dataMorte, descricaoMorte: $descricaoMorte, dr: $dataRemocao, dva: $dataVendaAnimal, mr: $motivoRemocao, vv: $valorVenda, nomeComprador: $nomeComprador, anotacoesVenda: $anotacoesVenda, descricaoMestico: $descricaoMestico)\n";
  }
}
