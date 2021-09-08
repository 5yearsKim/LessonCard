import 'dart:math';

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
    // await deleteDatabase(path);
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
          order_index INTEGER,
          color TEXT,
          FOREIGN KEY(target_date) REFERENCES card(target_date)
          ON DELETE CASCADE
        ) 
        '''
      );
      txn.execute(
        '''
        CREATE TABLE stamp (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          track_id INTEGER,
          created_at TEXT,
          note TEXT,
          FOREIGN KEY(track_id) REFERENCES track(id)
          ON DELETE CASCADE
        );
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

  // Track
  listTrack(targetDate) async {
    var data = await db.rawQuery(
      '''
      SELECT * FROM track WHERE target_date=?
      ORDER BY order_index
      ''',
      [targetDate]
    );
    return data;
  }

  insertTrack(String targetDate, String subjectName, String stampName, int maxStamp, int orderIndex, String color) async {
    int tid = await db.rawInsert(
      '''
      INSERT INTO track (target_date, subject_name, stamp_name, max_stamp, order_index, color)
      VALUES (?, ?, ?, ?, ?, ?)
      ''',
      [targetDate, subjectName, stampName, maxStamp, color]
    );
    return tid;
  }

  updateTrack(int trackId, {String? subjectName, int? maxStamp, int? orderIndex, String? color}) async {
    String sql = 'UPDATE track SET ';
    List<String> options = [];
    if (subjectName != null) 
      options.add('subject_name=${subjectName}');
    if (maxStamp != null)
      options.add('max_stamp = ${maxStamp}');
    if (orderIndex != null)
      options.add('order_index = ${orderIndex}');
    if (color != null)
      options.add('color = ${color}');
    if (options.isEmpty)
      return;
    sql += options.join(',');
    sql += ' WHERE id=?';
    int tid = await db.rawUpdate(sql, [trackId]);
    return tid;
  }

  deleteTrack(int trackId) async {
    int tid = await db.rawDelete(
      '''
      DELETE FROM track
      WHERE id=?
      ''',
      [trackId]
    );
    return tid;
  }

  // stamp
  listStamp(String targetDate) async {
    var data = db.rawQuery(
      '''
      SELECT target_date, stamp.id, track_id, created_at, note FROM (track inner join stamp ON track.id = stamp.track_id)
      WHERE target_date=?
      ORDER BY created_at
      ''',
      [targetDate],
    );
    return data;
  }

  listStampByTrack(int trackId) async {
    var data = db.rawQuery(
      '''
      SELECT * FROM stamp
      WHERE track_id=?
      ORDER BY created_at
      ''',
      [trackId]
    );
    return data;
  }

  insertStamp(int trackId, String note) async {
    int sid = await db.rawInsert(
      '''
      INSERT INTO stamp (track_id, created_at, note)
      VALUES (?, datetime('now'), ?)
      ''',
      [trackId, note]
    );
    return sid;
  }
}