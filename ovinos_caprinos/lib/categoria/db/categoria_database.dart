import 'dart:async';
import 'package:ovinos_caprinos/categoria/class/categoria.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = "Categoria";
final String idCategoriaColumn = "id_categoria";
final String especieIdColumn = "id_especie";
final String descricaoColumn = "descricao";

class CategoriaHelper {
  static final CategoriaHelper _instance = CategoriaHelper.internal();

  factory CategoriaHelper() => _instance;

  CategoriaHelper.internal();

  Database _categoriaDataBase;

  Future<Database> get db async {
    if (_categoriaDataBase != null) {
      return _categoriaDataBase;
    } else {
      _categoriaDataBase = await initDb();
      categoriasPadrao();
      return _categoriaDataBase;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "categoria_database.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS $tableName (  $idCategoriaColumn INTEGER PRIMARY KEY  ,"
          "$especieIdColumn INTEGER,"
          "$descricaoColumn TEXT)");
      print("Categoria dataBase was created");
    });
  }

  Future<Categoria> saveCategoria(Categoria categoria) async {
    Database dbCategoria = await db;
    categoria.id = await dbCategoria.insert(tableName, categoria.toMap());
    return categoria;
  }

  Future<Categoria> getCategoria(int id) async {
    Database dbCategoria = await db;
    List<Map> maps = await dbCategoria.query(tableName,
        columns: [idCategoriaColumn, especieIdColumn, descricaoColumn],
        where: "$idCategoriaColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Categoria.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteCategoria(int id) async {
    Database dbCategoria = await db;
    return await dbCategoria
        .delete(tableName, where: "$id = ?", whereArgs: [id]);
  }

  Future<int> updateCategoria(Categoria categoria) async {
    Database dbCategoria = await db;
    return await dbCategoria.update(tableName, categoria.toMap(),
        where: "$idCategoriaColumn = ?", whereArgs: [categoria.id]);
  }

  Future<List> getAllCategorias() async {
    Database dbCategoria = await db;
    List listMap = await dbCategoria.rawQuery("SELECT * FROM $tableName");
    List<Categoria> listCategoria = List();
    for (Map m in listMap) {
      listCategoria.add(Categoria.fromMap(m));
    }
    return listCategoria;
  }

  Future<int> getNumber() async {
    Database dbCategoria = await db;
    return Sqflite.firstIntValue(
        await dbCategoria.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future close() async {
    Database dbCategoria = await db;
    dbCategoria.close();
  }

  Future categoriasPadrao() async {
    int a = await getNumber();
    if (a == 0) {
      saveCategoria(
          new Categoria(id: null, especieId: 1, descricao: "Não Selecionado"));
      saveCategoria(new Categoria(id: null, especieId: 1, descricao: "Cria"));
      saveCategoria(new Categoria(id: null, especieId: 1, descricao: "Recria"));
      saveCategoria(
          new Categoria(id: null, especieId: 1, descricao: "Terminação"));
      saveCategoria(new Categoria(id: null, especieId: 1, descricao: "Matriz"));
      saveCategoria(
          new Categoria(id: null, especieId: 1, descricao: "Reprodutor"));
    }
  }
}
