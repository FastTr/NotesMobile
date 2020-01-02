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
    // if (_database != null) {
    //   return _database;
    // }

    _database = await getDatabaseInstance();
    return _database;
  }
  
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    print("made it");
    db.execute("ALTER TABLE Notes ADD COLUMN dayNoteMade TEXT;");
  }

  Future<Database> getDatabaseInstance() async {
    print("HERE");
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "notes.db");

    return await openDatabase(path, version: 5, onUpgrade: _onUpgrade, onCreate: (Database db, int version) async {

        await db.execute(" CREATE TABLE Notes (" 
        "id integer primary key AUTOINCREMENT,"
        "noteTitle TEXT,"
        "noteContent TEXT,"
        ")");

    });    
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    var response = await db.query("Notes");
    print(response.length);
    List<Note> list = response.map((c) => Note.fromMap(c)).toList();
    
    for (Note n in list) {
      print("TITLE: ${n.noteTitle} --- CONTENT: ${n.noteContent} --- TIME: ${n.timeNoteMade} --- DATE: ${n.dateNoteMade}");
    }

    return list;
  }

  void deleteAllNotes() async {
    final db = await database;
    db.delete("Notes");
  }

  // change to void or keep return type?
  addNoteToDatabase(Note note) async {
    final db = await database;
    var raw = await db.insert("Notes", note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);
    return raw;
  }

  updateExistingNote(Note note) async {
    final db = await database;
    var response = await db.update("Notes", note.toMap(), where: "id = ?", whereArgs: [note.id]);
    print("UPDATED");
    return response;
  }

  void deleteNoteWithId(int id) async {
    final db = await database;
    db.delete("Notes", where: "id = ?", whereArgs: [id]);
  }





}

