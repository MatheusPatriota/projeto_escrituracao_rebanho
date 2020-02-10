import 'dart:async';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = "Animal";
final String idAnimalColumn = "id_animal";
final String idEspecieColumn = "id_especie";
final String statusAnimalColumn = "status_animal";
final String nomeColumn = "nome";
final String sexoColumn = "sexo";
final String idCategoriaColumn = "id_categoria";
final String idRacaColumn = "id_raca";
final String brincoControleColumn = "brinco_controle";
final String paiColumn = "pai";
final String maeColumn = "mae";
final String dataNascimentoColumn = "data_nascimento";
final String dataAquisicaoColumn = "data_aquisicao";
final String valorAquisicaoColumn = "valor_aquisicao";
final String patriomionioColumn = "patrimonio";
final String nomeVendedorColumn = "nome_vendedor";
final String imgColumn = "img";
final String dataMorteColumn = "data_morte";
final String descricaoMorteColumn ="descricao_morte";
final String dataRemocaoColumn = "data_remocao";

class AnimalHelper {
  static final AnimalHelper _instance = AnimalHelper.internal();

  factory AnimalHelper() => _instance;

  AnimalHelper.internal();

  Database _animalDataBase;

  Future<Database> get db async {
    if (_animalDataBase != null) {
      return _animalDataBase;
    } else {
      _animalDataBase = await initDb();
      return _animalDataBase;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "animal_database.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE $tableName ("
          "$idAnimalColumn INTEGER PRIMARY KEY,"
          "$nomeColumn TEXT,"         
          "$statusAnimalColumn TEXT,"
          "$sexoColumn TEXT,"
          "$brincoControleColumn TEXT,"
          "$paiColumn TEXT,"
          "$maeColumn TEXT,"
          "$dataNascimentoColumn TEXT,"
          "$dataAquisicaoColumn TEXT,"
          "$valorAquisicaoColumn TEXT,"
          "$patriomionioColumn TEXT,"
          "$nomeVendedorColumn TEXT,"
          "$imgColumn TEXT,"
          "$dataMorteColumn TEXT,"
          "$descricaoMorteColumn TEXT,"
          "$dataRemocaoColumn TEXT,"
          "$idCategoriaColumn INTEGER ,"
          "$idRacaColumn INTEGER ,"
          "$idEspecieColumn INTEGER )"
         );
         print("Database was created!");
    });
  }

  Future<Animal> saveAnimal(Animal animal) async {
    Database dbAnimal = await db;
    animal.idAnimal = await dbAnimal.insert(tableName, animal.toMap());
    return animal;
  }

  Future<Animal> getAnimal(int id) async {
    Database dbAnimal = await db;
    List<Map> maps = await dbAnimal.query(tableName,
        columns: [
          idAnimalColumn,
          idEspecieColumn,
          statusAnimalColumn,
          nomeColumn,
          sexoColumn,
          idCategoriaColumn,
          idRacaColumn,
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
        where: "$idAnimalColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Animal.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteAnimal(int id) async {
    Database dbAnimal = await db;
    return await dbAnimal.delete(tableName, where: "$idAnimalColumn = ?", whereArgs: [id]);
  }

  Future<int> updateAnimal(Animal animal) async {
    Database dbAnimal = await db;
    return await dbAnimal.update(tableName, animal.toMap(),
        where: "$idAnimalColumn = ?", whereArgs: [animal.idAnimal]);
  }

  Future<List> getAllAnimals() async {
    Database dbAnimal = await db;
    List listMap = await dbAnimal.rawQuery("SELECT * FROM $tableName");
    List<Animal> listAnimal = List();
    for (Map m in listMap) {
      listAnimal.add(Animal.fromMap(m));
    }
    return listAnimal;
  }

  Future<int> getNumber() async {
    Database dbAnimal = await db;
    return Sqflite.firstIntValue(
        await dbAnimal.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future close() async {
    Database dbAnimal = await db;
    dbAnimal.close();
  }
}
