import 'dart:convert';

const int defaultYear = 1800;

class Workout{
  String name;
  int functionID;
  DateTime timeStamp;
  String url;
  int weight;
  int reps;
  Duration wait;
  int sets;
  bool autoUpdatePrediction;

  Workout({
    this.name,
    //oConner
    this.functionID: 5,
    this.timeStamp,
    this.url: "",
    this.weight: 0,
    this.reps: 0,
    this.wait: const Duration(minutes: 1, seconds: 45),
    this.sets: 0,
    this.autoUpdatePrediction: true,
  });

  Workout.fromJson(Map<String,dynamic> map){
    name = map["name"];
    functionID = map["functionID"];
    timeStamp = map["timeStamp"];
    url = map["url"];
    weight = map["weight"];
    reps = map["reps"];
    wait = map["wait"];
    sets = map["sets"];
    autoUpdatePrediction = map["autoUpdatePrediction"];
  }

  String toJson(Workout w){
    return json.encode(w);
  }
}