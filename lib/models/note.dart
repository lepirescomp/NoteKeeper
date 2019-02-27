class Note{
  int _id;
  String _title;
  String _desc;
  String _date;
  int _prior;


  Note(this._title,this._date,this._prior,[this._desc]);
  Note.withId(this._id,this._title,this._date,this._prior,[this._desc]);

  int get prior => _prior;

  String get date => _date;

  String get desc => _desc;

  String get title => _title;

  int get id => _id;

  set prior(int value) {
    if(value>=1 && value<=2) {
      _prior = value;
    }
  }

  set date(String value) {
    _date = value;
  }

  set desc(String value) {
    _desc = value;
  }

  set title(String value) {
    if(value.length<=255) {
       _title = value;
    }
  }

  Map<String, dynamic> toMap(){
    var map =Map<String, dynamic>();
    if(id!=null){
      map['id']=_id;
    }
    map['title'] = _title;
    map['desc'] = _desc;
    map['prior'] = _prior;
    map['date'] = _date;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map){
    this._id=map['id'];
    this._title=map['title'];
    this._desc=map['desc'];
    this._prior=map['prior'];
    this._date=map['date'];
  }



}