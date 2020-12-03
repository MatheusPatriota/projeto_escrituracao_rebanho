import 'dart:async';
import 'package:escrituracao_zootecnica/pesagem/class/pesagem.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = "Pesagem";
final String idPesagemColumn = "id_pesagem";
final String idAnimalColumn = "id_animal";
final String dataColumn = "data";
final String pesoColumn = "peso";

class PesagemHelper {
  static final PesagemHelper _instance = PesagemHelper.internal();

  factory PesagemHelper() => _instance;

  PesagemHelper.internal();

  Database _pesagemDataBase;

  Future<Database> get db async {
    if (_pesagemDataBase != null) {
      return _pesagemDataBase;
    } else {
      _pesagemDataBase = await initDb();
      return _pesagemDataBase;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "pesagem_database.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS $tableName (  $idPesagemColumn INTEGER PRIMARY KEY  ,"
          "$idAnimalColumn INTEGER, "
          "$dataColumn TEXT,"
          "$pesoColumn TEXT)");
      print("Pesagem dataBase was created");
    });
  }

  Future<Pesagem> savePesagem(Pesagem pesagem) async {
    Database dbPesagem = await db;
    pesagem.idPesagem = await dbPesagem.insert(tableName, pesagem.toMap());
    return pesagem;
  }

  Future<Pesagem> getPesagem(int id) async {
    Database dbPesagem = await db;
    List<Map> maps = await dbPesagem.query(tableName,
        columns: [idPesagemColumn, idAnimalColumn, dataColumn, pesoColumn],
        where: "$idPesagemColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Pesagem.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletePesagem(int id) async {
    Database dbPesagem = await db;
    return await dbPesagem
        .delete(tableName, where: "$idPesagemColumn = ?", whereArgs: [id]);
  }

  Future<int> updatePesagem(Pesagem pesagem) async {
    Database dbPesagem = await db;
    return await dbPesagem.update(tableName, pesagem.toMap(),
        where: "$idPesagemColumn = ?", whereArgs: [pesagem.idPesagem]);
  }

  Future<List> getAllPesagems() async {
    Database dbPesagem = await db;
    List listMap = await dbPesagem.rawQuery("SELECT * FROM $tableName");
    List<Pesagem> listPesagem = List();
    for (Map m in listMap) {
      listPesagem.add(Pesagem.fromMap(m));
    }
    return listPesagem;
  }

  Future<int> getNumber() async {
    Database dbPesagem = await db;
    return Sqflite.firstIntValue(
        await dbPesagem.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future close() async {
    Database dbPesagem = await db;
    dbPesagem.close();
  }
}
