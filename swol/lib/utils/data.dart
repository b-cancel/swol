import 'package:swol/workout.dart';

List<Workout> _workouts;

workoutsInit()async{
  //TODO: read save workouts from file
  await Future.delayed(Duration(seconds: 1), (){});

  _workouts = new List<Workout>();

  //test additions
  _workouts.add(Workout(
    name: "Bench Press",
    timeStamp: DateTime(
      2018, 7, 6,
    ),
    url: "",
    wait: Duration(seconds: 1, milliseconds: 500),
  ));
  _workouts.add(Workout(
    name: "Bicep Curls",
    timeStamp: DateTime(
      2018, 9, 6,
    ),
    url: "",
    wait: Duration(seconds: 1, milliseconds: 750),
  ));
  _workouts.add(Workout(
    name: "Jumping",
    timeStamp: DateTime(
      2018, 6, 6,
    ),
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