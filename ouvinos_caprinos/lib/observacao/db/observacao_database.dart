import 'dart:async';
import 'package:ouvinos_caprinos/observacao/class/observacao.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = "Observacao";
final String idObservacaoColumn = "id_observacao";
final String idAnimalColumn = "id_animal";
final String dataColumn = "data";
final String descricaoColumn = "descricao";

class ObservacaoHelper {
  static final ObservacaoHelper _instance = ObservacaoHelper.internal();

  factory ObservacaoHelper() => _instance;

  ObservacaoHelper.internal();

  Database _observacaoDataBase;

  Future<Database> get db async {
    if (_observacaoDataBase != null) {      
      return _observacaoDataBase;
    } else {
      _observacaoDataBase = await initDb();
      return _observacaoDataBase;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "observacao_database.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS $tableName (  $idObservacaoColumn INTEGER PRIMARY KEY  ,"
          "$idAnimalColumn INTEGER, "
          "$dataColumn TEXT,"
          "$descricaoColumn TEXT)");
          print("Observacao dataBase was created");
    });
  }

  Future<Observacao> saveObservacao(Observacao observacao) async {
    Database dbObservacao = await db;
    observacao.idObservacao = await dbObservacao.insert(tableName, observacao.toMap());
    return observacao;
  }

  Future<Observacao> getObservacao(int id) async {
    Database dbObservacao = await db;
    List<Map> maps = await dbObservacao.query(tableName,
        columns: [idObservacaoColumn, idAnimalColumn, dataColumn, descricaoColumn],
        where: "$idObservacaoColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Observacao.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteObservacao(int id) async {
    Database dbObservacao = await db;
    return await dbObservacao
        .delete(tableName, where: "$idObservacaoColumn = ?", whereArgs: [id]);
  }

  Future<int> updateObservacao(Observacao observacao) async {
    Database dbObservacao = await db;
    return await dbObservacao.update(tableName, observacao.toMap(),
        where: "$idObservacaoColumn = ?", whereArgs: [observacao.idObservacao]);
  }

  Future<List> getAllObservacaos() async {
    Database dbObservacao = await db;
    List listMap = await dbObservacao.rawQuery("SELECT * FROM $tableName");
    List<Observacao> listObservacao = List();
    for (Map m in listMap) {
      listObservacao.add(Observacao.fromMap(m));
    }
    return listObservacao;
  }

  Future<int> getNumber() async {
    Database dbObservacao = await db;
    return Sqflite.firstIntValue(
        await dbObservacao.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future close() async {
    Database dbObservacao = await db;
    dbObservacao.close();
  }

}
