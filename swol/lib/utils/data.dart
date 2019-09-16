import 'package:swol/workout.dart';

List<Workout> _workouts;

workoutsInit()async{
  //TODO: read save workouts from file
  await Future.delayed(Duration(seconds: 1), (){});

  _workouts = new List<Workout>();

  //test additions
  _workouts.add(Workout(
    name: "Bench Press",
    timeStamp: DateTime.fromMillisecondsSinceEpoch(0),
    url: "",
    wait: Duration(seconds: 1, milliseconds: 500),
  ));
  _workouts.add(Workout(
    name: "Bicep Curls",
    timeStamp: DateTime.fromMillisecondsSinceEpoch(50987698900),
    url: "",
    wait: Duration(seconds: 1, milliseconds: 750),
  ));
  _workouts.add(Workout(
    name: "Jumping",
    timeStamp: DateTime.fromMillisecondsSinceEpoch(7000000),
    url: "",
    wait: Duration(seconds: 1, milliseconds: 250),
  ));
}

List<Workout> getWorkouts(){
  return _workouts;
}

addWorkout(String name){
  _workouts.add(Workout(
    name: name,
  ));
}