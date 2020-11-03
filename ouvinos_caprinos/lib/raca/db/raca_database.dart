import 'dart:async';
import 'package:ovinos_caprinos/raca/class/raca.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = "Raca";
final String idRacaColumn = "id_raca";
final String especieIdColumn = "id_especie";
final String descricaoColumn = "descricao";

class RacaHelper {
  static final RacaHelper _instance = RacaHelper.internal();

  factory RacaHelper() => _instance;

  RacaHelper.internal();

  Database _racaDataBase;

  Future<Database> get db async {
    if (_racaDataBase != null) {
      return _racaDataBase;
    } else {
      _racaDataBase = await initDb();
      racasPadrao();
      return _racaDataBase;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "raca_database.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS $tableName (  $idRacaColumn INTEGER PRIMARY KEY  ,"
          "$especieIdColumn INTEGER, "
          "$descricaoColumn TEXT)");
      print("Raca dataBase was created");
    });
  }

  Future<Raca> saveRaca(Raca raca) async {
    Database dbRaca = await db;
    raca.id = await dbRaca.insert(tableName, raca.toMap());
    return raca;
  }

  Future<Raca> getRaca(int id) async {
    Database dbRaca = await db;
    List<Map> maps = await dbRaca.query(tableName,
        columns: [
          idRacaColumn,
          especieIdColumn,
          descricaoColumn,
        ],
        where: "$idRacaColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Raca.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteRaca(int id) async {
    Database dbRaca = await db;
    return await dbRaca.delete(tableName, where: "$id = ?", whereArgs: [id]);
  }

  Future<int> updateRaca(Raca raca) async {
    Database dbRaca = await db;
    return await dbRaca.update(tableName, raca.toMap(),
        where: "$idRacaColumn = ?", whereArgs: [raca.id]);
  }

  Future<List> getAllRacas() async {
    Database dbRaca = await db;
    List listMap = await dbRaca.rawQuery("SELECT * FROM $tableName");
    List<Raca> listRaca = List();
    for (Map m in listMap) {
      listRaca.add(Raca.fromMap(m));
    }
    return listRaca;
  }

  Future<int> getNumber() async {
    Database dbRaca = await db;
    return Sqflite.firstIntValue(
        await dbRaca.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future close() async {
    Database dbRaca = await db;
    dbRaca.close();
  }

  Future racasPadrao() async {
    int a = await getNumber();
    if (a == 0) {
      saveRaca(new Raca(
        id: null,
        especieId: 1,
        descricao: "Alpino",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 1,
        descricao: "Anglo Nubiano",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 1,
        descricao: "Boer",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 1,
        descricao: "Mestiço",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 1,
        descricao: "Saanen",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 1,
        descricao: "Toggenburg",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 2,
        descricao: "Bergamácia Brasileira",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 2,
        descricao: "Dorper",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 2,
        descricao: "Dâmara",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 2,
        descricao: "Hampshire Down",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 2,
        descricao: "Ile de France",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 2,
        descricao: "Lacaune",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 2,
        descricao: "Mestiço",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 2,
        descricao: "Morada Nova",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 2,
        descricao: "Santa Inês",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 2,
        descricao: "Somalis Brasileira",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 2,
        descricao: "Suffolk",
      ));
      saveRaca(new Raca(
        id: null,
        especieId: 2,
        descricao: "Texel",
      ));
    }
  }
}
