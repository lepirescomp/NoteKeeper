import 'package:flutter/material.dart';
import 'package:note_keeper_app/models/note.dart';
import 'package:note_keeper_app/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteDetailState(this.note,this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  var _list = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  TextEditingController titleControler = TextEditingController();
  TextEditingController descriptionControler = TextEditingController();
  String appBarTitle;
  Note note;

  NoteDetailState(this.note,this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleControler.text=note.title;
    descriptionControler.text=note.desc;

    // TODO: implement build
    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
            moveToLastScreen();
          }),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                  title: DropdownButton(
                      items: _list.map((String dDSItem) {
                        return DropdownMenuItem<String>(
                            value: dDSItem, child: Text(dDSItem));
                      }).toList(),
                      style: textStyle,
                      value: getPriorAsString(note.prior),
                      onChanged: (value) {
                        setState(() {

                          updatePriorAsInt(value);
                        });
                      })),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titleControler,
                  style: textStyle,
                  onChanged: (value) {

                    updateTitle();
                  },
                  decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionControler,
                  style: textStyle,
                  onChanged: (value) {

                    updateDesc();
                  },
                  decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            _save();

                          });
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            _delete();


                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen(){
    Navigator.pop(context,true);
  }

  void updatePriorAsInt(String value){
    switch(value){
      case 'High':
        note.prior=1;
        break;
      case 'Low':
        note.prior=2;
        break;
    }
  }

  String getPriorAsString(int value){
    String prior;
    switch(value){
      case 1:
        prior=_list[0];
        break;
      case 2:
        prior=_list[1];
        break;
    }
    return prior;
  }

  void updateTitle(){
    note.title= titleControler.text;
  }

  void updateDesc(){
    note.desc=descriptionControler.text;
  }


  void _save() async{
    moveToLastScreen();
    note.date= DateFormat.yMMMd().format(DateTime.now());
    int check;
    if(note.id!=null){
      await helper.updateNote(note);
    }else{
      await helper.insertNote(note);
    }

    if(check!=0){
      _showAlertDialog('Status','Not Save Successfully');
    }else{
      _showAlertDialog('Status','Problem Saving Note');
    }
  }

  void _showAlertDialog(String status,String msg){
    AlertDialog alertDialog = AlertDialog(
      title: Text(status),
      content: Text(msg),
    );
    showDialog(context: context,
    builder: (_)=> alertDialog
    );
  }


  void _delete() async{
    moveToLastScreen();
    if (note.id==null){
      _showAlertDialog("Status", "There is no note to be deleted");
      return;
    }
      int result = await helper.deleteNote(note.id);
      if(result!=0){
        _showAlertDialog("Status", "Note Deleted!!!");
      }else{
        _showAlertDialog("Status", "An error occured! :(");
      }

  }

}
