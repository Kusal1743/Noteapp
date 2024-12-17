import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'Note.dart';

class NotesDBHandler {
  final databaseName = "notes.db";
  final tableName = "notes";

  final fieldMap = {
    "id": "INTEGER PRIMARY KEY AUTOINCREMENT",
    "title": "TEXT", // Updated from BLOB to TEXT
    "content": "TEXT", // Updated from BLOB to TEXT
    "date_created": "INTEGER",
    "date_last_edited": "INTEGER",
    "note_color": "INTEGER",
    "is_archived": "INTEGER"
  };

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    var path = await getDatabasesPath();
    var dbPath = join(path, databaseName);

    return await openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      print("Creating table $tableName");
      await db.execute(_buildCreateQuery());
    });
  }

  String _buildCreateQuery() {
    String query = "CREATE TABLE IF NOT EXISTS $tableName (";
    fieldMap.forEach((column, field) {
      query += "$column $field,";
    });
    return "${query.substring(0, query.length - 1)})";
  }
// create Note
  Future<int?> insertNote(Note note, bool isNew) async {
    final Database db = await database;
    try {
      await db.insert(
        tableName,
        isNew ? note.toMap(false) : note.toMap(true),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (isNew) {
        var result = await db.query(
          tableName,
          orderBy: "date_last_edited DESC",
          where: "is_archived = ?",
          whereArgs: [0],
          limit: 1,
        );
        return result.isNotEmpty ? result.first["id"] as int? : null;
      }
      return note.id;
    } catch (e) {
      print("Error inserting note: $e");
      return null;
    }
  }

  Future<bool> copyNote(Note note) async {
    final Database db = await database;
    try {
      await db.insert(tableName, note.toMap(false),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    } catch (e) {
      print("Error copying note: $e");
      return false;
    }
  }
//update note
  Future<bool> archiveNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;
      try {
        await db.update(
          tableName,
          note.toMap(true),
          where: "id = ?",
          whereArgs: [note.id],
        );
        return true;
      } catch (e) {
        print("Error archiving note: $e");
        return false;
      }
    }
    return false;
  }
// delete note
  Future<bool> deleteNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;
      try {
        await db.delete(tableName, where: "id = ?", whereArgs: [note.id]);
        return true;
      } catch (e) {
        print("Error deleting note: $e");
        return false;
      }
    }
    return false;
  }
//read note
  Future<List<Map<String, dynamic>>> selectAllNotes() async {
    final Database db = await database;
    try {
      return await db.query(
        tableName,
        orderBy: "date_last_edited DESC",
        where: "is_archived = ?",
        whereArgs: [0],
      );
    } catch (e) {
      print("Error selecting all notes: $e");
      return [];
    }
  }
}
