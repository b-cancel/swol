import 'package:flutter/material.dart';
import 'package:swol/other/functions/helper.dart';
import 'package:swol/shared/methods/excerciseData.dart';

//TODO: there are some variables that are updated in tandem
//as in alot of variables are updated all together
//so we can update the file at the end in some cases
//perhaps by providing some alternative update method that is more tedious
//but doesn't update the file
class AnExercise{ 
  //constants
  static const int defaultFunctionID = Functions.defaultFunctionID;
  static const int defaultRepTarget = 8;
  static const Duration defaultRecovery = const Duration(minutes: 2, seconds: 30);
  static const int defaultSetTarget = 4;

  //default value notifier values
  static DateTime nullDateTime = DateTime.fromMicrosecondsSinceEpoch(0);

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
    DateTime newValue = newLastTimeStamp;
    _lastTimeStamp = newValue;
    ExcerciseData.updateFile();
    ExcerciseData.updateOrder();
  }

  DateTime _backUpTimeStamp;
  DateTime get backUpTimeStamp => _backUpTimeStamp;
  set backUpTimeStamp(DateTime newBackUpTimeStamp){
    _backUpTimeStamp = newBackUpTimeStamp;
    ExcerciseData.updateFile();
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

  //temp start time
  ValueNotifier<DateTime> _tempStartTime;
  ValueNotifier<DateTime> get tempStartTime => _tempStartTime;
  set tempStartTime(ValueNotifier<DateTime> newTempStartTime){
    DateTime newValue = newTempStartTime.value;
    _tempStartTime.value = newValue;
    ExcerciseData.updateFile();
  }
  
  int _tempSetCount;
  int get tempSetCount => _tempSetCount;
  set tempSetCount(int newTempSetCount){
    _tempSetCount = newTempSetCount;
    ExcerciseData.updateFile();
  }

  //build
  AnExercise(
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
  ){
    //variables that have notifiers 
    //that are required to have atleast a default value
    _tempStartTime = new ValueNotifier<DateTime>(nullDateTime);

    //required to pass variables
    _name = name;
    _url = url;
    _note = note;

    _predictionID = predictionID;
    _repTarget = repTarget;
    _recoveryPeriod = recoveryPeriod;
    _setTarget = setTarget;

    //NOTE: the update to the file should only happen after everything else
    this.lastTimeStamp = lastTimeStamp;
  }

  //NOTE: from here we MUST set things directly to the private variables
  AnExercise.fromJson(Map<String,dynamic> map){
    //---Auto Set

    id = map["id"];

    //---Settings

    //basic data
    _name = map["name"];
    _url = map["url"];
    _note = map["note"];

    //other
    _predictionID = map["predictionID"];
    _repTarget = map["repTarget"];
    _recoveryPeriod = _stringToDuration(map["recoveryPeriod"]);
    _setTarget = map["setTarget"];

    //---Recorded

    _backUpTimeStamp = _stringToDateTime(
      map["backUpTimeStamp"],
    );
    _lastTimeStamp = _stringToDateTime(map["lastTimeStamp"]);
    _lastWeight = map["lastWeight"];
    _lastReps = map["lastReps"];

    //---Temporary

    _tempWeight = map["tempWeight"];
    _tempReps = map["tempReps"];
    _tempStartTime = new ValueNotifier<DateTime>(
      _stringToDateTime(map["tempStartTime"])
    );
    _tempSetCount = map["tempSetCount"];
  }

  DateTime _stringToDateTime(String json){
    if(json == null || json == "null") return nullDateTime;
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

      "backUpTimeStamp": _dateTimeToString(backUpTimeStamp),
      "lastTimeStamp": _dateTimeToString(lastTimeStamp),
      "lastWeight": lastWeight,
      "lastReps": lastReps,

      //---Temporary

      "tempWeight": tempWeight,
      "tempReps": tempReps,
      "tempStartTime": _dateTimeToString(tempStartTime.value),
      "tempSetCount": tempSetCount,
    };
  }

  static String _dateTimeToString(DateTime dt){
    if(dt == nullDateTime) return null; //NOTE: legacy code
    else return dt?.toIso8601String() ?? null;
  }

  static String _durationToString(Duration d){
    return d?.inSeconds.toString() ?? null;
  }
}