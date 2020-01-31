import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:swol/other/functions/helper.dart';

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

  //static (used to assign ID)
  static int nextID;

  //---Settings

  //NOTE: this is set after by the addExcercise function
  int id;

  //basic
  String name;
  String url;
  String note;

  //other
  int predictionID;
  int repTarget;
  Duration recoveryPeriod;
  int setTarget;

  //---Recorded

  //NOTE: this MUST ALWAYS BE FILLED since its used to sort everything
  //and taking an alternative approach would be a pain
  DateTime lastTimeStamp;
  int lastWeight;
  int lastReps;

  //---Temporary

  int tempWeight;
  int tempReps;
  DateTime tempStartTime;
  int tempSetCount;

  //build
  AnExcercise({
    //basic data
    @required this.name,
    @required this.url,
    @required this.note,

    //other
    @required this.predictionID,
    @required this.repTarget,
    @required this.recoveryPeriod,
    @required this.setTarget,

    //uses default but must be set
    @required this.lastTimeStamp,
  });

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

  static String excercisesToString(List<AnExcercise> excercises){
    String string = "[";
    for(int i = 0; i < excercises.length; i++){
      String str = json.encode(excercises[i].toJson());
      string += str;
      if(i < (excercises.length - 1)) string += ",";
    }
    string += "]";
    return string;
  }
}