import 'dart:async';
import 'package:escrituracao_zootecnica/ordenha/class/ordenha.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = "Ordenha";
final String idOrdenhaColumn = "id_ordenha";
final String idAnimalColumn = "id_animal";
final String dataColumn = "data";
final String pesoColumn = "peso";

class OrdenhaHelper {
  static final OrdenhaHelper _instance = OrdenhaHelper.internal();

  factory OrdenhaHelper() => _instance;

  OrdenhaHelper.internal();

  Database _ordenhaDataBase;

  Future<Database> get db async {
    if (_ordenhaDataBase != null) {
      return _ordenhaDataBase;
    } else {
      _ordenhaDataBase = await initDb();
      return _ordenhaDataBase;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "ordenha_database.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS $tableName (  $idOrdenhaColumn INTEGER PRIMARY KEY  ,"
          "$idAnimalColumn INTEGER, "
          "$dataColumn TEXT,"
          "$pesoColumn TEXT)");
      print("Ordenha dataBase was created");
    });
  }

  Future<Ordenha> saveOrdenha(Ordenha ordenha) async {
    Database dbOrdenha = await db;
    ordenha.idOrdenha = await dbOrdenha.insert(tableName, ordenha.toMap());
    return ordenha;
  }

  Future<Ordenha> getOrdenha(int id) async {
    Database dbOrdenha = await db;
    List<Map> maps = await dbOrdenha.query(tableName,
        columns: [idOrdenhaColumn, idAnimalColumn, dataColumn, pesoColumn],
        where: "$idOrdenhaColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Ordenha.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteOrdenha(int id) async {
    Database dbOrdenha = await db;
    return await dbOrdenha
        .delete(tableName, where: "$idOrdenhaColumn = ?", whereArgs: [id]);
  }

  Future<int> updateOrdenha(Ordenha ordenha) async {
    Database dbOrdenha = await db;
    return await dbOrdenha.update(tableName, ordenha.toMap(),
        where: "$idOrdenhaColumn = ?", whereArgs: [ordenha.idOrdenha]);
  }

  Future<List> getAllOrdenhas() async {
    Database dbOrdenha = await db;
    List listMap = await dbOrdenha.rawQuery("SELECT * FROM $tableName");
    List<Ordenha> listOrdenha = List();
    for (Map m in listMap) {
      listOrdenha.add(Ordenha.fromMap(m));
    }
    return listOrdenha;
  }

  Future<int> getNumber() async {
    Database dbOrdenha = await db;
    return Sqflite.firstIntValue(
        await dbOrdenha.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future close() async {
    Database dbOrdenha = await db;
    dbOrdenha.close();
  }
}
