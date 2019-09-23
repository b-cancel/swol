import 'dart:convert';

import 'package:flutter/widgets.dart';

class Excercise{
  //constants
  static const Duration defaultDuration = const Duration(minutes: 1, seconds: 30);
  static const int defaultRepTarget = 8;
  static const int defaultSetTarget = 3;

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
    this.lastReps,

    this.tempStartTime,
    this.tempWeight,
    this.tempReps,

    //other
    this.predictionID, //Default set by addWorkout
    this.recoveryPeriod, //Default set by addWokrout
    this.repTarget, //Default set by addWokrout
  });

  Excercise.fromJson(Map<String,dynamic> map){
    //basic data
    name = map["name"];
    url = map["url"];
    note = map["note"];

    //per excercise sets per workout
    lastTimeStamp = map["lastTimeStamp"];
    lastSetTarget = map["lastSetTarget"];

    tempTimeStamp = map["tempTimeStamp"];
    tempSetCount = map["tempSetCount"];

    //per set
    lastWeight = map["lastWeight"];
    lastReps = map["lastReps"];

    tempStartTime = map["tempStarTime"];
    tempWeight = map["tempWeight"];
    tempReps = map["tempReps"];

    //other
    predictionID = map["predictionID"];
    recoveryPeriod = map["recoveryPeriod"];
    repTarget = map["repTarget"];
  }

  String toJson(Excercise w){
    return json.encode(w);
  }
}