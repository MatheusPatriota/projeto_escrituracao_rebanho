import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String animalTable = "animalTable";
final String idColumn = "idColumn";
final String tipoAnimalColumn = "tipoAnimalColumn";
final String statusAnimalColumn = "statusAnimalColumn";
final String nomeColumn = "nomeColumn";
final String sexoColumn = "sexoColumn";
final String categoriaColumn = "categoriaColumn";
final String racaColumn = "racaColumn";
final String brincoControleColumn = "brincoControleColumn";
final String paiColumn = "paiColumn";
final String maeColumn = "maeColumn";
final String dataNascimentoColumn = "dataNascimentoColumn";
final String dataAquisicaoColumn = "dataAquisicaoColumn";
final String valorAquisicaoColumn = "valorAquisicaoColumn";
final String patriomionioColumn = "patrimonioColumn";
final String nomeVendedorColumn = "nomeVendedorColumn";
final String imgColumn = "imgColumn";

class AnimalHelper {
  static final AnimalHelper _instance = AnimalHelper.internal();

  factory AnimalHelper() => _instance;

  AnimalHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "Animalsnew.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $animalTable($idColumn INTEGER PRIMARY KEY, $tipoAnimalColumn TEXT, $statusAnimalColumn TEXT ,$nomeColumn TEXT, $sexoColumn TEXT,"
            "$categoriaColumn TEXT, $racaColumn TEXT, $brincoControleColumn TEXT, $paiColumn TEXT,"
            "$maeColumn TEXT, $dataNascimentoColumn TEXT, $dataAquisicaoColumn TEXT, $valorAquisicaoColumn TEXT, "
            "$patriomionioColumn TEXT, $nomeVendedorColumn TEXT, $imgColumn TEXT)"
        );
    });
  }

  Future<Animal> saveAnimal(Animal animal) async {
    Database dbAnimal = await db;
    animal.id = await dbAnimal.insert(animalTable, animal.toMap());
    return animal;
  }

  Future<Animal> getAnimal(int id) async {
    Database dbAnimal = await db;
    List<Map> maps = await dbAnimal.query(animalTable,
        columns: [
          idColumn,
          tipoAnimalColumn,
          statusAnimalColumn,
          nomeColumn,
          sexoColumn,
          categoriaColumn,
          racaColumn,
          brincoControleColumn,
          paiColumn,
          maeColumn,
          dataNascimentoColumn,
          dataAquisicaoColumn,
          valorAquisicaoColumn,
          patriomionioColumn,
          nomeVendedorColumn,
          imgColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Animal.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteAnimal(int id) async {
    Database dbAnimal = await db;
    return await dbAnimal
        .delete(animalTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateAnimal(Animal animal) async {
    Database dbAnimal = await db;
    return await dbAnimal.update(animalTable, animal.toMap(),
        where: "$idColumn = ?", whereArgs: [animal.id]);
  }

  Future<List> getAllAnimals() async {
    Database dbAnimal = await db;
    List listMap = await dbAnimal.rawQuery("SELECT * FROM $animalTable");
    List<Animal> listAnimal = List();
    for (Map m in listMap) {
      listAnimal.add(Animal.fromMap(m));
    }
    return listAnimal;
  }

  Future<int> getNumber() async {
    Database dbAnimal = await db;
    return Sqflite.firstIntValue(
        await dbAnimal.rawQuery("SELECT COUNT(*) FROM $animalTable"));
  }

  Future close() async {
    Database dbAnimal = await db;
    dbAnimal.close();
  }
}

class Animal {
  int id;
  String tipo;
  String status;
  String nome;
  String sexo;
  String categoria;
  String raca;
  String brincoControle;
  String pai;
  String mae;
  String dataNascimento;
  String dataAquisicao;
  String valorAquisicao;
  String nomeVendedor;
  String patrimonio;
  String img;

  Animal();

  Animal.fromMap(Map map) {
    id = map[idColumn];
    tipo = map[tipoAnimalColumn];
    status = map[statusAnimalColumn];
    nome = map[nomeColumn];
    sexo = map[sexoColumn];
    categoria = map[categoriaColumn];
    raca = map[racaColumn];
    brincoControle = map[brincoControleColumn];
    pai = map[paiColumn];
    mae = map[maeColumn];
    dataNascimento = map[dataNascimentoColumn];
    dataAquisicao = map[dataAquisicaoColumn];
    valorAquisicao = map[valorAquisicaoColumn];
    nomeVendedor = map[nomeVendedorColumn];
    patrimonio = map[patriomionioColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      tipoAnimalColumn: tipo,
      statusAnimalColumn: status,
      nomeColumn: nome,
      sexoColumn: sexo,
      categoriaColumn: categoria,
      racaColumn: raca,
      brincoControleColumn: brincoControle,
      paiColumn: pai,
      maeColumn: mae,
      dataNascimentoColumn: dataNascimento,
      dataAquisicaoColumn: dataAquisicao,
      valorAquisicaoColumn: valorAquisicao,
      patriomionioColumn: patrimonio,
      nomeVendedorColumn: nomeVendedor,
      imgColumn: img
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Animal(id: $id, tipo:$tipo, name: $nome, sexo:$sexo, categoria:$categoria ,raca: $raca, brinco de controle:$brincoControle, pai:$pai, mae:$mae, data de nascimento:$dataNascimento, data de aquisicao:$dataAquisicao, valor de aquisicao: $valorAquisicao, nome do vendedor:$nomeVendedor, patrimonio:$patrimonio, img: $img)";
  }
}
