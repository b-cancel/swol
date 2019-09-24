import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:swol/functions/helper.dart';

class Excercise{
  //constants
  static const Duration defaultRecovery = const Duration(minutes: 1, seconds: 30);
  static const int defaultRepTarget = 8;
  static const int defaultSetTarget = 3;
  static const int defaultFunctionID = defaultFunctionIndex;

  //static (used to assign ID)
  static int nextID;

  //NOTE: this is set after by the addExcercise function
  int id;

  //basic
  String name;
  String url;
  String note;

  //per excercise sets per workout
  DateTime lastTimeStamp;
  int lastSetTarget;

  DateTime tempTimeStamp;
  int tempSetCount;

  //per set
  int lastWeight;
  int lastReps;

  DateTime tempStartTime;
  int tempWeight;
  int tempReps;

  //other
  int predictionID;
  Duration recoveryPeriod;
  int repTarget;

  //build
  Excercise({
    //basic data
    @required this.name,
    this.url: "",
    this.note: "",

    //per excercise sets per workout
    @required this.lastTimeStamp, //default set by addWorkout
    this.lastSetTarget, //default set by addWorkout

    this.tempTimeStamp,
    this.tempSetCount,

    //per set
    this.lastWeight,
    this.lastReps: defaultSetTarget,

    this.tempStartTime,
    this.tempWeight,
    this.tempReps,

    //other
    this.predictionID, //Default set by addWorkout
    this.recoveryPeriod: defaultRecovery, //Default set by addWokrout
    this.repTarget: defaultRepTarget, //Default set by addWokrout
  });

  Excercise.fromJson(Map<String,dynamic> map){
    //basic data
    name = map["name"];
    url = map["url"];
    note = map["note"];

    //per excercise sets per workout
    lastTimeStamp = _stringToDateTime(map["lastTimeStamp"]);
    lastSetTarget = map["lastSetTarget"];

    tempTimeStamp = _stringToDateTime(map["tempTimeStamp"]);
    tempSetCount = map["tempSetCount"];

    //per set
    lastWeight = map["lastWeight"];
    lastReps = map["lastReps"];

    tempStartTime = _stringToDateTime(map["tempStartTime"]);
    tempWeight = map["tempWeight"];
    tempReps = map["tempReps"];

    //other
    predictionID = map["predictionID"];
    recoveryPeriod = _stringToDuration(map["recoveryPeriod"]);
    repTarget = map["repTarget"];
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
      //basic data
      "name": name,
      "url": url,
      "note": note,

      //per excercise sets per workout
      "lastTimeStamp": _dateTimeToString(lastTimeStamp),
      "lastSetTarget": lastSetTarget,

      "tempTimeStamp": _dateTimeToString(tempTimeStamp),
      "tempSetCount": tempSetCount,

      //per set
      "lastWeight": lastWeight,
      "lastReps": lastReps,

      "tempStartTime": _dateTimeToString(tempStartTime),
      "tempWeight": tempWeight,
      "tempReps": tempReps,

      //other
      "predictionID": predictionID,
      "recoveryPeriod": _durationToString(recoveryPeriod),
      "repTarget": repTarget,
    };
  }

  String _dateTimeToString(DateTime dt){
    return dt?.toIso8601String() ?? null;
  }

  String _durationToString(Duration d){
    return d?.inSeconds.toString() ?? null;
  }

  static String excercisesToString(List<Excercise> excercises){
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