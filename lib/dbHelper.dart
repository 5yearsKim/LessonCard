import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'config.dart';

class DBHelper {
  late final Database db;

  // DBHelper() {
  //   initDb();
  // }

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
        CREATE TABLE track (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          target_date TEXT,
          subject_name TEXT,
          stamp_name TEXT,
          max_stamp INTEGER,
          order_idx INTEGER,
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

  listCard() async {
    var data = await db.rawQuery(
      '''
      select card.target_date, card.note, count(track.id) as track_cnt
      from card left join track
        on card.target_date = track.target_date
      group by card.target_date
      '''
    );
    return data;
  }

  insertCard(String date, String note) async {
    print([date, note]);
    int cid = await db.rawInsert(
      '''
      INSERT OR IGNORE INTO card VALUES(?, ?)
      ''',
      [date, note]
    );
    return cid;
  }

  updateCard(String date, {String? note}) async {
    String sql = 'UPDATE card SET ';
    List<String> options = [];
    if (note!= null) 
      options.add('note=\'${note}\'');
    if (options.isEmpty)
      return;
    sql += options.join(',');
    sql += ' WHERE target_date=?';
    int cid = await db.rawUpdate(sql, [date]);
    return cid;
  }



  // Track
  listTrack(targetDate) async {
    var data = await db.rawQuery(
      '''
      SELECT * FROM track WHERE target_date=?
      ORDER BY order_idx
      ''',
      [targetDate]
    );
    return data;
  }

  insertTrack(String targetDate, String subjectName, String stampName, int maxStamp, int orderIdx, String color) async {
    int tid = await db.rawInsert(
      '''
      INSERT INTO track (target_date, subject_name, stamp_name, max_stamp, order_idx, color)
      VALUES (?, ?, ?, ?, ?, ?)
      ''',
      [targetDate, subjectName, stampName, maxStamp, orderIdx, color]
    );
    return tid;
  }

  updateTrack(int trackId, {String? subjectName, int? maxStamp, int? orderIdx, String? color, String? stampName}) async {
    String sql = 'UPDATE track SET ';
    List<String> options = [];
    if (subjectName != null) 
      options.add('subject_name=\'${subjectName}\'');
    if (maxStamp != null)
      options.add('max_stamp = ${maxStamp}');
    if (orderIdx != null)
      options.add('order_idx = ${orderIdx}');
    if (color != null)
      options.add('color = \'${color}\'');
    if (stampName != null) {
      options.add('stamp_name=\'${stampName}\'');
    }
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

  listSubjectName() async {
    var data = await db.rawQuery(
      '''
      SELECT subject_name, color, stamp_name, max_stamp
      FROM (select * from track order by target_date DESC)
      GROUP BY subject_name;
      '''
    );
    return data;
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

  listStampAll() async {
    var data = db.rawQuery(
      '''
      select subject_name, stamp.track_id, target_date, created_at 
      from (track inner join stamp on track.id = stamp.track_id)
      '''
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
      VALUES (?, datetime('now', 'localtime'), ?)
      ''',
      [trackId, note]
    );
    return sid;
  }
  
  deleteStamp(int stampId) async {
    int sid = await db.rawDelete(
      '''
      DELETE FROM stamp
      WHERE id = ?
      ''',
      [stampId],
    );
    return sid;
  }

  updateStamp(int stampId, {String? note}) async {
    String sql = 'UPDATE stamp SET ';
    List<String> options = [];
    if (note!= null) 
      options.add('note=\'${note}\'');
    if (options.isEmpty)
      return;
    sql += options.join(',');
    sql += ' WHERE id=?';
    int sid = await db.rawUpdate(sql, [stampId]);
    return sid;
  }
}