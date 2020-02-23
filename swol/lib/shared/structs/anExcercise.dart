import 'package:flutter/material.dart';
import 'package:swol/other/functions/helper.dart';
import 'package:swol/shared/methods/excerciseData.dart';

//TODO: there are some variables that are updated in tandem
//as in alot of variables are updated all together
//so we can update the file at the end in some cases
//perhaps by providing some alternative update method that is more tedious
//but doesn't update the file
class AnExcercise{ 
  //constants
  static const int defaultFunctionID = Functions.defaultFunctionIndex;
  static const int defaultRepTarget = 8;
  static const Duration defaultRecovery = const Duration(minutes: 1, seconds: 30);
  static const int defaultSetTarget = 4;

  //default value notifier values
  static DateTime nullDateTime = DateTime.fromMicrosecondsSinceEpoch(0);
  static int nullInt = 0;

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
  ValueNotifier<DateTime> _lastTimeStamp;
  ValueNotifier<DateTime> get lastTimeStamp => _lastTimeStamp;
  set lastTimeStamp(ValueNotifier<DateTime> newLastTimeStamp){
    DateTime newValue = newLastTimeStamp.value;
    _lastTimeStamp.value = newValue;
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
  
  DateTime _tempStartTime;
  DateTime get tempStartTime => _tempStartTime;
  set tempStartTime(DateTime newTempStartTime){
    DateTime newValue = newTempStartTime;
    _tempStartTime = newValue;
    ExcerciseData.updateFile();
  }
  
  ValueNotifier<int> _tempSetCount;
  ValueNotifier<int> get tempSetCount => _tempSetCount;
  set tempSetCount(ValueNotifier<int> newTempSetCount){
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
  ){
    //NOTE: for all notifier variables we must first create them with some default

    //required to pass variables
    _name = name;
    _url = url;
    _note = note;

    _predictionID = predictionID;
    _repTarget = repTarget;
    _recoveryPeriod = recoveryPeriod;
    _setTarget = setTarget;

    //required to have a null value
    _tempSetCount = new ValueNotifier<int>(nullInt);

    //NOTE: the update to the file should only happen after everything else
    _lastTimeStamp = new ValueNotifier<DateTime>(nullDateTime);
    this.lastTimeStamp = ValueNotifier<DateTime>(lastTimeStamp);
  }

  //NOTE: from here we MUST set things directly to the private variables
  AnExcercise.fromJson(Map<String,dynamic> map){
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
    _lastTimeStamp = new ValueNotifier<DateTime>(
      _stringToDateTime(map["lastTimeStamp"])
    );
    _lastWeight = map["lastWeight"];
    _lastReps = map["lastReps"];

    //---Temporary

    _tempWeight = map["tempWeight"];
    _tempReps = map["tempReps"];
    _tempStartTime = _stringToDateTime(map["tempStartTime"]);
    var tsc = map["tempSetCount"];
    _tempSetCount = new ValueNotifier<int>(
      tsc == null ? nullInt : tsc,
    );
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
      "lastTimeStamp": _dateTimeToString(lastTimeStamp.value),
      "lastWeight": lastWeight,
      "lastReps": lastReps,

      //---Temporary

      "tempWeight": tempWeight,
      "tempReps": tempReps,
      "tempStartTime": _dateTimeToString(tempStartTime),
      "tempSetCount": tempSetCount.value,
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