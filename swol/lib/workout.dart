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
  bool autoUpdatePrediction;

  Workout({
    this.name,
    //oConner is right in the middle of them all
    //excluding Almazan
    this.functionID: 4,
    this.timeStamp,
    this.url: "",
    this.weight: 0,
    this.reps: 0,
    this.wait: const Duration(minutes: 1, seconds: 45),
    this.sets: 0,
    this.autoUpdatePrediction: true,
    //TODO: perhaps add a maybeSaveWeight, maybeSaveWeight 
    //to indicate that we may save that weight if the we continue to the next set after the break
    //TODO: add a timeStamp to indicate when our break started so we can keep track of multiple timers
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