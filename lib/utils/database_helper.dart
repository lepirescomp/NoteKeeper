import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper_app/models/note.dart';

class DatabaseHelper{
    static DatabaseHelper _databaseHelper;//singleton
    static Database _database;

    String notetable='note_table';
    String colId ='id';
    String colTitle= 'title';
    String colDesc = 'desc';
    String colPrior = 'prior';
    String colDate ='date';

    DatabaseHelper._createInstance();

    factory DatabaseHelper(){

      if(_databaseHelper==null) {
        _databaseHelper = DatabaseHelper._createInstance();
      }

      return _databaseHelper;
    }


    Future<Database> get database async{
      if(_database==null){
        _database = await initializeDatabase();
      }
      return _database;
    }


    void _createDb(Database db, int newVersion) async{
      await db.execute('CREATE TABLE $notetable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,'
          '$colDesc TEXT, $colPrior INTEGER, $colDate TEXT)');
    }

    Future<Database> initializeDatabase() async{
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path +'notes.db';
      
      var notesDatabase= await openDatabase(path, version:1, onCreate: _createDb);

      return notesDatabase;
    }



     Future<List<Map<String,dynamic>>>  getNoteMaplist() async{
      Database db = await this.database;

      var result = await db.query(notetable, orderBy: '$colPrior ASC');
      return result;
    }


    Future<int> insertNote(Note note) async{
      Database db = await this.database;
      var result = await db.insert(notetable, note.toMap());
      return result;
    }

    Future<int> updateNote(Note note) async{
      Database db = await this.database;
      var result = await db.update(notetable, note.toMap(),where: '$colId = ?',whereArgs: [note.id]);
      return result;
    }

    Future<int> deleteNote(int id) async{
      Database db = await this.database;
      var result = await db.rawDelete('DELETE FROM $notetable WHERE $colId = $id');
      return result;
    }


    Future<int> getCount() async{
      Database db = await this.database;
      List<Map<String,dynamic>> x= await db.rawQuery('SELECT COUNT (*) FROM $notetable');
      int result = Sqflite.firstIntValue(x);
      return result;
    }

    Future<List<Note>> getNoteList() async{
      var noteMapList = await getNoteMaplist();
      int count = noteMapList.length;

      List<Note> noteList = List<Note>();

      for(int i =0;i<count;i++){
        noteList.add(Note.fromMapObject(noteMapList[i]));
      }

      return noteList;


    }




}