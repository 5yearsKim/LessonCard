import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'config.dart';

class DBHelper {
  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, DB_NAME);
    var m_db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return m_db;
  }

  _onCreate(Database db, int version) async {
    await db.transaction((txn) async {
      txn.execute(
        '''
        CREATE TABLE card (
        target_date TEXT PRIMARY KEY,
        note TEXT
        )
        '''
      );
      txn.execute(
        '''
        create table subject (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        max_stamp INTEGER,
        color TEXT
        )
        '''
      );
      txn.execute(
        '''
        CREATE TABLE track (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          target_date TEXT,
          subject_name TEXT,
          stamp_name TEXT,
          max_stamp INTEGER,
          color TEXT,
          FOREIGN KEY(target_date) REFERENCES card(target_date)
        ) 
        '''
      );
      txn.execute(
        '''
        CREATE TABLE stamp (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          created_at TEXT,
          note TEXT
        ) 
        '''
      );
    });
  }

  insertCard(String date, String note) async {
    int cid = db.rawInsert(
      '''
      INSERT INTO card VALUES(?, ? ) 
      ''',
      [date, note]
    );
  return cid;
  }
}