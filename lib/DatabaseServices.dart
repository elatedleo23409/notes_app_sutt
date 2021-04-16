import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Notemodel {
  final String title;
  final String content;
  Notemodel({this.title, this.content});
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }
}

class Databaseservices {
  Future<Database> database;
  void notes() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE notetable(title TEXT, content TEXT)");
      },
      version: 1,
    );
  }

  Future<void> insertNote(Notemodel note) async {
    final Database db = await database;
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Notemodel>> notetable() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');

    return List.generate(maps.length, (i) {
      return Notemodel(
        title: maps[i]['title'],
        content: maps[i]['content'],
      );
    });
  }
}
