import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'moviedb.dart';

class DatabaseHelper {

  static final _databaseName = "movies.db";
  static final _databaseVersion = 1;

  static final table = 'favourite_table';
  static final watch_table='watch_table';
  static final latest_table='latest_table';
  static final columnId = '_id';
  static final columnTitle = 'title';
  static final columnDate = 'release_date';
  static final columnMT='media_type';
  static final columnOverV='overview';
  static final columnBPath='backdrop_path';
  static final columnPPath='poster_path';
  static final columnVote='vote_average';
  static final watched='watched_status';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnMT TEXT NOT NULL,
            $columnOverV TEXT NOT NULL,
            $columnBPath TEXT NOT NULL,
            $columnPPath TEXT NOT NULL,
            $columnVote DOUBLE NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $watch_table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnMT TEXT NOT NULL,
            $columnOverV TEXT NOT NULL,
            $columnBPath TEXT NOT NULL,
            $columnPPath TEXT NOT NULL,
            $columnVote DOUBLE NOT NULL,
            $watched TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $watch_table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnMT TEXT NOT NULL,
            $columnOverV TEXT NOT NULL,
            $columnBPath TEXT NOT NULL,
            $columnPPath TEXT NOT NULL,
            $columnVote DOUBLE NOT NULL,
            $watched TEXT NOT NULL
          )
          ''');
  }


  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> insertWatched(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(watch_table, row);
  }

  Future<int> insertLatest(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(latest_table, row);
  }

  Future<bool> findLatest(int id) async {
    Database db = await instance.database;
    var dbclient = await db;

    int count = Sqflite.firstIntValue(await dbclient.rawQuery("SELECT COUNT(*) FROM $latest_table WHERE $columnId=$id"));

    if (count==0){
      return false;
    }
    return true;
  }

  Future<int> deleteLatest(int id) async {
    Database db = await instance.database;
    return await db.delete(latest_table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<bool> findWatched(int id) async {
    Database db = await instance.database;
    var dbclient = await db;

    int count = Sqflite.firstIntValue(await dbclient.rawQuery("SELECT COUNT(*) FROM $watch_table WHERE $columnId=$id"));

    if (count==0){
      return false;
    }
    return true;
  }
  Future<bool> statusWatched(int id) async {
    Database db = await instance.database;
    var dbclient = await db;

    int count = Sqflite.firstIntValue(await dbclient.rawQuery("SELECT COUNT(*) FROM $watch_table WHERE watched=watched"));

    if (count==0){
      return false;
    }
    return true;
  }

  Future<bool> find(int id) async {
    Database db = await instance.database;
    var dbclient = await db;

    int count = Sqflite.firstIntValue(await dbclient.rawQuery("SELECT COUNT(*) FROM $table WHERE $columnId=$id"));

    if (count==0){
      return false;
    }
    return true;
  }


  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }
  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRowsWatched() async {
    Database db = await instance.database;
    return await db.query(watch_table);
  }
// All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRowsLatest() async {
    Database db = await instance.database;
    return await db.query(latest_table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCountWatched() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $watch_table'));
  }

  Future<List<Publish>> movies() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(table);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Publish(
        id:  maps[i][columnId],
        media_type:  maps[i][columnMT],
        title:  maps[i][columnTitle],
        backdrop_path: maps[i][columnBPath],
        overview: maps[i][columnOverV],
        poster_path: maps[i][columnPPath],
        vote_average: maps[i][columnVote],
        release_date: maps[i][columnDate],
      );
    });
  }

  Future<List<Publish>> watchedMovies() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(watch_table, where: '$watched = ?', whereArgs: ['watched']);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Publish(
        id:  maps[i][columnId],
        media_type:  maps[i][columnMT],
        title:  maps[i][columnTitle],
        backdrop_path: maps[i][columnBPath],
        overview: maps[i][columnOverV],
        poster_path: maps[i][columnPPath],
        vote_average: maps[i][columnVote],
        release_date: maps[i][columnDate],
      );
    });
  }

  Future<List<Publish>> waitingMovies() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(watch_table, where: '$watched = ?', whereArgs: ['not_watched']);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Publish(
        id:  maps[i][columnId],
        media_type:  maps[i][columnMT],
        title:  maps[i][columnTitle],
        backdrop_path: maps[i][columnBPath],
        overview: maps[i][columnOverV],
        poster_path: maps[i][columnPPath],
        vote_average: maps[i][columnVote],
        release_date: maps[i][columnDate],
      );
    });
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateWatched(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(watch_table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
  Future<int> deleteWatched(int id) async {
    Database db = await instance.database;
    return await db.delete(watch_table, where: '$columnId = ?', whereArgs: [id]);
  }
}
