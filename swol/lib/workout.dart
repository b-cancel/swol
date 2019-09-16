import 'dart:convert';

class Workout{
  String name;
  int functionID;
  DateTime timeStamp;
  String url;
  int weight;
  int reps;
  Duration wait;
  int sets;

  Workout({
    this.name,
    this.functionID: 4,
    this.timeStamp,
    this.url: "",
    this.weight: 0,
    this.reps: 0,
    this.wait: Duration.zero,
    this.sets: 0,
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
  }

  String toJson(Workout w){
    return json.encode(w);
  }
}