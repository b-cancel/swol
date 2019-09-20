import 'dart:convert';

class Excercise{
  //basic
  String name;
  String url;
  String note;
  //manual update
  DateTime lastTimeStamp;
  Duration lastBreak;
  int lastWeight;
  int lastReps;
  //updates on its own or manually
  int predictionID;
  bool autoUpdatePrediction;
  int setTarget;
  bool autoUpdateSetTarget;
  //for during workout
  DateTime timerStartTime;
  int tempWeight;
  int tempReps;
  int tempSets;

  //build
  Excercise({
    //basic data
    this.name,
    this.url: "",
    this.note: "",
    //manual update
    this.lastTimeStamp,
    this.lastBreak: const Duration(minutes: 1, seconds: 45), //balance between INC mass and strength
    this.lastWeight: 0,
    this.lastReps: 0,
    //updates on its own or manually
    this.predictionID: 4, //for slightly above average joe
    this.autoUpdatePrediction: true, //let us help
    this.setTarget: 3, //good staart point
    this.autoUpdateSetTarget : true, //let us help
    //for during workout
    this.timerStartTime,
    this.tempWeight,
    this.tempReps,
    this.tempSets,
  });

  Excercise.fromJson(Map<String,dynamic> map){
    //basic data
    name = map["name"];
    url = map["url"];
    note = map["note"];
    //manual update
    lastTimeStamp = map["lastTimeStamp"];
    lastBreak = map["lastBreak"];
    lastWeight = map["lastWeight"];
    lastReps = map["lastReps"];
    //updates on its own or manually
    predictionID = map["predictionID"];
    autoUpdatePrediction = map["autoUpdatePrediction"];
    setTarget = map["setTarget"];
    autoUpdateSetTarget = map["autoUpdateSetTarget"];
    //for during workout
    timerStartTime = map["timerStartTime"];
    tempWeight = map["tempWeight"];
    tempReps = map["tempReps"];
    tempSets = map["tempSets"];
  }

  String toJson(Excercise w){
    return json.encode(w);
  }
}