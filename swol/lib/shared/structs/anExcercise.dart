import 'package:swol/other/functions/helper.dart';
import 'package:swol/shared/methods/excerciseData.dart';

//TODO whenever we need to listen to something at any point
//use a value notifier
//for everything else provide a getter or setter that updates things properly without making us have to deal with boilerplate
//ideally we should grab all the excercises ONCE, on the excercise list page init
//afte that we should listen to changes in order and viola (Adding, removing, editing in ways that change order cause a rebuild in the list)
//everything else only cause a reload in the relevant widgets... when its relevant
//TODO: start off with listening to the recoveryperiod changing... and tempStartTime so that we can get the mini timer working
//TODO: the above tells us we should update this... and not use the weird update excercise function ive been using
class AnExcercise{
  //constants
  static const int defaultFunctionID = Functions.defaultFunctionIndex;
  static const int defaultRepTarget = 8;
  static const Duration defaultRecovery = const Duration(minutes: 1, seconds: 30);
  static const int defaultSetTarget = 4;

  //---Settings

  //NOTE: this is saved by the addExcercise function
  int id;

  //basic
  String _name;
  String get name => _name;
  set name(String newName){
    _name = newName;
    ExcerciseData.updateFile();
  }
  
  String _url;
  String get url => _url;
  set url(String newUrl){
    _url = newUrl;
    ExcerciseData.updateFile();
  }
  
  String _note;
  String get note => _note;
  set note(String newNote){
    _note = newNote;
    ExcerciseData.updateFile();
  }
  
  //other
  int _predictionID;
  int get predictionID => _predictionID;
  set predictionID(int newPredictionID){
    _predictionID = newPredictionID;
    ExcerciseData.updateFile();
  }
  
  int _repTarget;
  int get repTarget => _repTarget;
  set repTarget(int newRepTarget){
    _repTarget = newRepTarget;
    ExcerciseData.updateFile();
  }
  
  Duration _recoveryPeriod;
  Duration get recoveryPeriod => _recoveryPeriod;
  set recoveryPeriod(Duration newRecoveryPeriod){
    _recoveryPeriod = newRecoveryPeriod;
    ExcerciseData.updateFile();
  }
  
  int _setTarget;
  int get setTarget => _setTarget;
  set setTarget(int newSetTarget){
    _setTarget = newSetTarget;
    ExcerciseData.updateFile();
  }

  //---Recorded

  //NOTE: this MUST ALWAYS BE FILLED since its used to sort everything
  //and taking an alternative approach would be a pain
  DateTime _lastTimeStamp;
  DateTime get lastTimeStamp => _lastTimeStamp;
  set lastTimeStamp(DateTime newLastTimeStamp){
    _lastTimeStamp = newLastTimeStamp;
    ExcerciseData.updateFile();
    ExcerciseData.updateOrder();
  }
  
  int _lastWeight;
  int get lastWeight => _lastWeight;
  set lastWeight(int newLastWeight){
    _lastWeight = newLastWeight;
    ExcerciseData.updateFile();
  }
  
  int _lastReps;
  int get lastReps => _lastReps;
  set lastReps(int newLastReps){
    _lastReps = newLastReps;
    ExcerciseData.updateFile();
  }

  //---Temporary

  int _tempWeight;
  int get tempWeight => _tempWeight;
  set tempWeight(int newTempWeight){
    _tempWeight = newTempWeight;
    ExcerciseData.updateFile();
  }
  
  int _tempReps;
  int get tempReps => _tempReps;
  set tempReps(int newTempReps){
    _tempReps = newTempReps;
    ExcerciseData.updateFile();
  }
  
  DateTime _tempStartTime;
  DateTime get tempStartTime => _tempStartTime;
  set tempStartTime(DateTime newTempStartTime){
    _tempStartTime = newTempStartTime;
    ExcerciseData.updateFile();
  }
  
  int _tempSetCount;
  int get tempSetCount => _tempSetCount;
  set tempSetCount(int newTempSetCount){
    _tempSetCount = newTempSetCount;
    ExcerciseData.updateFile();
  }

  //build
  AnExcercise(
    //basic data
    String name, 
    String url, 
    String note,

    //other
    int predictionID,
    int repTarget,
    Duration recoveryPeriod,
    int setTarget,

    //date time
    DateTime lastTimeStamp,
  );

  AnExcercise.fromJson(Map<String,dynamic> map){
    //---Auto Set

    id = map["id"];

    //---Settings

    //basic data
    name = map["name"];
    url = map["url"];
    note = map["note"];

    //other
    predictionID = map["predictionID"];
    repTarget = map["repTarget"];
    recoveryPeriod = _stringToDuration(map["recoveryPeriod"]);
    setTarget = map["setTarget"];

    //---Recorded

    lastTimeStamp = _stringToDateTime(map["lastTimeStamp"]);
    lastWeight = map["lastWeight"];
    lastReps = map["lastReps"];

    //---Temporary

    tempWeight = map["tempWeight"];
    tempReps = map["tempReps"];
    tempStartTime = _stringToDateTime(map["tempStartTime"]);
    tempSetCount = map["tempSetCount"];
  }

  DateTime _stringToDateTime(String json){
    if(json == null || json == "null") return null;
    else return DateTime.parse(json);
  }

  Duration _stringToDuration(String json){
    if(json == null || json == "null") return null;
    else return Duration(seconds: int.parse(json));
  }

  Map<String, dynamic> toJson(){
    return {
      //---Auto Set

      "id": id,

      //---Settings

      //basic data
      "name": name,
      "url": url,
      "note": note,

      //other
      "predictionID": predictionID,
      "repTarget": repTarget,
      "recoveryPeriod": _durationToString(recoveryPeriod),
      "setTarget": setTarget,

      //---Recorded

      "lastTimeStamp": _dateTimeToString(lastTimeStamp),
      "lastWeight": lastWeight,
      "lastReps": lastReps,

      //---Temporary

      "tempWeight": tempWeight,
      "tempReps": tempReps,
      "tempStartTime": _dateTimeToString(tempStartTime),
      "tempSetCount": tempSetCount,
    };
  }

  static String _dateTimeToString(DateTime dt){
    return dt?.toIso8601String() ?? null;
  }

  static String _durationToString(Duration d){
    return d?.inSeconds.toString() ?? null;
  }
}