import 'package:ouvinos_caprinos/tratamento/class/tratamento.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

final String tableName = "Tratamento";
final String idTratamentoColumn = "id_tratamento";
final String animalIdColumn = "id_animal";
final String dataColumn = "data";
final String motivoColumn = "motivo";
final String medicacaoColumn = "medicacao";
final String periodoCarenciaColumn = "periodo_carencia";
final String custoColumn = "custo";
final String anotacoesColumn = "anotacoes";

class TratamentoHelper {
  static final TratamentoHelper _instance = TratamentoHelper.internal();

  factory TratamentoHelper() => _instance;

  TratamentoHelper.internal();

  Database _tratamentoDataBase;

  Future<Database> get db async {
    if (_tratamentoDataBase != null) {
      return _tratamentoDataBase;
    } else {
      _tratamentoDataBase = await initDb();
      return _tratamentoDataBase;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "tratamento_database.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS $tableName (  $idTratamentoColumn INTEGER PRIMARY KEY  ,"
          "$animalIdColumn INTEGER,"
          "$dataColumn TEXT,"
          "$motivoColumn TEXT,"
          "$medicacaoColumn TEXT,"
          "$periodoCarenciaColumn TEXT,"
          "$custoColumn TEXT,"
          "$anotacoesColumn TEXT)");
      print("Tratamento dataBase was created");
    });
  }

  Future<Tratamento> saveTratamento(Tratamento tratamento) async {
    Database dbTratamento = await db;
    print(dbTratamento);
    tratamento.idTratamento = await dbTratamento.insert(tableName, tratamento.toMap());
    print("Tratamento Salvo");
    return tratamento;
  }

  Future<Tratamento> getTratamento(int id) async {
    Database dbTratamento = await db;
    List<Map> maps = await dbTratamento.query(tableName,
        columns: [
          idTratamentoColumn,
          animalIdColumn,
          dataColumn,
          motivoColumn,
          medicacaoColumn,
          periodoCarenciaColumn,
          custoColumn,
          anotacoesColumn
        ],
        where: "$idTratamentoColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Tratamento.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteTratamento(int id) async {
    Database dbTratamento = await db;
    return await dbTratamento
        .delete(tableName, where: "$idTratamentoColumn = ?", whereArgs: [id]);
  }

  Future<int> updateTratamento(Tratamento tratamento) async {
    Database dbTratamento = await db;
    return await dbTratamento.update(tableName, tratamento.toMap(),
        where: "$idTratamentoColumn = ?", whereArgs: [tratamento.idTratamento]);
  }

  Future<List> getAllTratamentos() async {
    Database dbTratamento = await db;
    List listMap = await dbTratamento.rawQuery("SELECT * FROM $tableName");
    List<Tratamento> listTratamento = List();
    for (Map m in listMap) {
      listTratamento.add(Tratamento.fromMap(m));
    }
    return listTratamento;
  }

  Future<int> getNumber() async {
    Database dbTratamento = await db;
    return Sqflite.firstIntValue(
        await dbTratamento.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future close() async {
    Database dbTratamento = await db;
    dbTratamento.close();
  }
}
