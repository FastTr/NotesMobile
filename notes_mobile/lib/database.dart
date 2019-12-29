import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:notes_mobile/note.dart';
import 'package:sqflite/sqflite.dart';

class NoteDatabaseProvider {
  NoteDatabaseProvider._();

  static final NoteDatabaseProvider db = NoteDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "notes.db");
    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute(" CREATE TABLE Notes (" 
      "id integer primary key AUTOINCREMENT,"
      "noteTitle TEXT,"
      "noteContent TEXT" 
      ")");
    });
  }

  addNoteToDatabase(Note note) async {
    final db = await database;
    var raw = await db.insert("Notes", note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);
    return raw;
  }


  Future<List<Note>> getAllNotes() async {
    final db = await database;
    var response = await db.query("Notes");
    List<Note> list = response.map((c) => Note.fromMap(c)).toList();
    
    for (Note n in list) {
      print("TITLE: ${n.noteTitle} --- CONTENT: ${n.noteContent}");
    }

    return list;
  }

}

