import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/Task.dart';

class DatabaseHelper {
  static final int completedFlag = 1;
  static final int notCompletedFlag = 2;

  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'tasks_table';

  static final columnId = '_id';
  static final columnTitle = 'title';
  static final columnStatus = 'status';

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
    String path = join(await getDatabasesPath(), _databaseName);
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
            $columnStatus INTEGER NOT NULL
          )
          ''');
  }


}
