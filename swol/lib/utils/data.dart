import 'package:swol/workout.dart';

//main struct we are maintaining
List<Workout> _workouts;

workoutsInit()async{
  if(_workouts == null){
    //TODO: read save workouts from file
    await Future.delayed(Duration(seconds: 1), (){});

    _workouts = new List<Workout>();

    //test additions
    addWorkout(Workout(
      name: "Bench Press",
      timeStamp: DateTime(
        2018, 7, 6,
      ),
      url: "",
      wait: Duration(seconds: 1, milliseconds: 500),
      weight: 160,
      reps: 5,
    ));
    /*
    addWorkout(Workout(
      name: "Some New Workout",
      timeStamp: DateTime(
        1899, 9, 6,
      ),
      url: "",
      wait: Duration(seconds: 1, milliseconds: 750),
    ));
    */
    addWorkout(Workout(
      name: "Bicep Curls",
      timeStamp: DateTime(
        2018, 9, 6,
      ),
      url: "",
      wait: Duration(seconds: 1, milliseconds: 750),
      weight: 20,
      reps: 15,
    ));
    addWorkout(Workout(
      name: "Bicep Curls2",
      timeStamp: DateTime(
        2018, 9, 5,
      ),
      url: "",
      wait: Duration(seconds: 1, milliseconds: 750),
      weight: 20,
      reps: 15,
    ));
    addWorkout(Workout(
      name: "Bicep Curls3",
      timeStamp: DateTime(
        2018, 9, 13,
      ),
      url: "",
      wait: Duration(seconds: 1, milliseconds: 750),
      weight: 20,
      reps: 15,
    ));
    addWorkout(Workout(
      name: "Bicep Curls4",
      timeStamp: DateTime(
        2017, 9, 6,
      ),
      url: "",
      wait: Duration(seconds: 1, milliseconds: 750),
      weight: 20,
      reps: 15,
    ));
    addWorkout(Workout(
      name: "Jumping",
      timeStamp: DateTime(
        2018, 6, 6,
      ),
      url: "",
      wait: Duration(seconds: 1, milliseconds: 250),
      weight: 180,
      reps: 25,
    ));
  }
}

List<Workout> getWorkouts(){
  return _workouts;
}

//TODO: im sure there is a better way of doing this
//1. heap
//2. retain map instead of build each time
//3. etc...
addWorkout(Workout theWorkout){
  //add to workouts
  _workouts.add(theWorkout);

  //sort
  Map<DateTime, Workout> timeSinceToWorkout = new Map<DateTime, Workout>();
  for(int i = 0; i < _workouts.length; i++){
    Workout workout = _workouts[i];
    timeSinceToWorkout[workout.timeStamp] = workout;
  }
  List<DateTime> sortedTimeSinces = timeSinceToWorkout.keys.toList();
  sortedTimeSinces.sort();

  //apply sort
  _workouts.clear();
  for(int i = 0; i < sortedTimeSinces.length; i++){
    DateTime key = sortedTimeSinces[i];
    Workout workout = timeSinceToWorkout[key];
    _workouts.add(workout);
  }
}