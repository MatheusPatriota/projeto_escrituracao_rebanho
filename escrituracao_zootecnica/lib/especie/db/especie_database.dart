import 'dart:async';
import 'package:escrituracao_zootecnica/especie/class/especie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = "Especie";
final String idEspecieColumn = "id_raca";
final String descricaoColumn = "descricao";

class EspecieHelper {
  static final EspecieHelper _instance = EspecieHelper.internal();

  factory EspecieHelper() => _instance;

  EspecieHelper.internal();

  Database _especieDataBase;

  Future<Database> get db async {
    if (_especieDataBase != null) {
      return _especieDataBase;
    } else {
      _especieDataBase = await initDb();
      especiesPadrao();
      return _especieDataBase;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "especie_database.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS $tableName (  $idEspecieColumn INTEGER PRIMARY KEY  ,"
          "$descricaoColumn TEXTL)");
      print("Especie dataBase was created");
    });
  }

  Future<Especie> saveEspecie(Especie raca) async {
    Database dbEspecie = await db;
    raca.id = await dbEspecie.insert(tableName, raca.toMap());
    return raca;
  }

  Future<Especie> getEspecie(int id) async {
    Database dbEspecie = await db;
    List<Map> maps = await dbEspecie.query(tableName,
        columns: [idEspecieColumn, descricaoColumn],
        where: "$idEspecieColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Especie.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteEspecie(int id) async {
    Database dbEspecie = await db;
    return await dbEspecie
        .delete(tableName, where: "$idEspecieColumn = ?", whereArgs: [id]);
  }

  Future<int> updateEspecie(Especie raca) async {
    Database dbEspecie = await db;
    return await dbEspecie.update(tableName, raca.toMap(),
        where: "$idEspecieColumn = ?", whereArgs: [raca.id]);
  }

  Future<List> getAllEspecies() async {
    Database dbEspecie = await db;
    List listMap = await dbEspecie.rawQuery("SELECT * FROM $tableName");
    List<Especie> listEspecie = List();
    for (Map m in listMap) {
      listEspecie.add(Especie.fromMap(m));
    }
    return listEspecie;
  }

  Future<int> getNumber() async {
    Database dbEspecie = await db;
    return Sqflite.firstIntValue(
        await dbEspecie.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future close() async {
    Database dbEspecie = await db;
    dbEspecie.close();
  }

  Future especiesPadrao() async {
    int a = await getNumber();
    if (a == 0) {
      saveEspecie(new Especie(id: null, descricao: "Caprino"));
      saveEspecie(new Especie(id: null, descricao: "Ovino"));
    }
  }
}
