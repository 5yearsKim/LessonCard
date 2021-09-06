import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'config.dart';

class DBHelper {
  late final Database db;

  DBHelper() {
    initDb(); 
  }

  initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, DB_NAME);
    db = await openDatabase(path, version: 1, onCreate: _onCreate);
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

  // Card
  insertCard(String date, String note) async {
    int cid = await db.rawInsert(
      '''
      INSERT INTO card VALUES(?, ?)
      ON CONFLICT DO NOTHING
      ''',
      [date, note]
    );

    return cid;
  }

  listCard() async {
    var data = await db.rawQuery(
      '''
      SELECT * FROM card; 
      '''
    );
    return data;
  }

  listTrack(targetDate) async {
    var data = await db.rawQuery(
      '''
      SELECT * FROM track WHERE target_date=? 
      ''',
      [targetDate]
    );
    return data;
  }
  // Track
  insertTrack(String targetDate, String subjectName, String stampName, int maxStamp, String color) async {
    int tid = await db.rawInsert(
      '''
      INSERT INTO track (target_date, subject_name, stamp_name, max_stamp, color)
      VALUES (?, ?, ?, ?, ?) 
      ''',
      [targetDate, subjectName, stampName, maxStamp, color]
    );
    return tid;
  }
}