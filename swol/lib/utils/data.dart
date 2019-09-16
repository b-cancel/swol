import 'package:swol/workout.dart';

List<Workout> _workouts;

workoutsInit()async{
  //TODO: read save workouts from file
  await Future.delayed(Duration(seconds: 1), (){});

  _workouts = new List<Workout>();
}

List<Workout> getWorkouts(){
  return _workouts;
}

addWorkout(String name){
  _workouts.add(Workout(
    name: name,
  ));
}