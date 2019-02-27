import 'package:flutter/material.dart';
import 'package:note_keeper_app/screens/note_detail.dart';
import 'package:note_keeper_app/models/note.dart';
import 'package:note_keeper_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count=0;


  @override
  Widget build(BuildContext context) {

    if(noteList==null){
      noteList=List<Note>();
      updateListView();
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('NoteKeeper'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          navigateToDetail(Note('','',2),'Add Note');
        },
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorToColor(this.noteList[position].prior),
              child: Icon(Icons.keyboard_arrow_right),
            ),
            title: Text(
              this.noteList[position].title,
              style: titleStyle,
            ),
            subtitle: Text(this.noteList[position].date),
            trailing: GestureDetector(child: Icon(Icons.delete, color: Colors.grey),
            onTap: (){
              _delete(context, this.noteList[position]);
            },),
            onTap: () {


              navigateToDetail(this.noteList[position],'Add Note');
            },
          ),
        );
      },
    );
  }

  Color getPriorToColor(int prior){
    switch(prior){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;

    }
  }

  void _delete(BuildContext context,Note note) async{
    int result = await databaseHelper.deleteNote(note.id);
    if(result!=0){
      _showSnackBar(context, "Note deleted!!!");
      updateListView();
    }

  }

  void  _showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetail(note, 'Edit Note');
    }));

    if(result ==true){
      updateListView();
    }
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
       Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
       noteListFuture.then((noteList){
         setState(() {
           this.noteList = noteList;
           this.count = noteList.length;

         });
       });
    });
  }

}
