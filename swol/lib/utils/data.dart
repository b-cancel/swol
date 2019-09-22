import 'package:flutter/material.dart';
import 'package:swol/workout.dart';

//main struct we are maintaining
ValueNotifier<List<Excercise>> excercises;

excercisesInit()async{
  if(excercises == null){
    //TODO: read save workouts from file
    await Future.delayed(Duration(seconds: 1), (){});

    excercises = ValueNotifier(new List<Excercise>());

    //test additions
    addExcercise(Excercise(
      name: "Shoulder Press",
      lastTimeStamp: DateTime(
        2019, 9, 15,
        20, 0
      ),
    ));
    addExcercise(Excercise(
      name: "Shoulder Press",
      lastTimeStamp: DateTime(
        2019, 9, 15,
        20, 0
      ),
    ));
    addExcercise(Excercise(
      name: "Shoulder Press",
      lastTimeStamp: DateTime(
        2019, 9, 15,
        20, 0
      ),
    ));
    addExcercise(Excercise(
      name: "Squats",
      lastTimeStamp: DateTime(
        2019, 9, 15,
        18, 30
      ),
    ));
    addExcercise(Excercise(
      name: "Tricep Dips",
      lastTimeStamp: DateTime(
        2019, 9, 17,
        11, 15
      ),
    ));
    addExcercise(Excercise(
      name: "Pull Ups",
      lastTimeStamp: DateTime(
        2019, 9, 17,
        11
      ),
    ));
    addExcercise(Excercise(
      name: "Deadlift",
      lastTimeStamp: DateTime(
        2019, 9, 15,
        17, 30
      ),
    ));
    addExcercise(Excercise(
      name: "Calf Raises",
      lastTimeStamp: DateTime(
        2019, 9, 17,
        11, 30
      ),
    ));
    addExcercise(Excercise(
      name: "Bicep Curls",
      lastTimeStamp: DateTime(
        2019, 9, 17,
        11, 20
      ),
    ));
    addExcercise(Excercise(
      name: "Ab Twists",
      lastTimeStamp: DateTime(
        2019, 9, 15,
        20, 15
      ),
    ));
    addExcercise(Excercise(
      name: "Sit Ups",
      lastTimeStamp: DateTime(
        2019, 9, 17,
        10, 
      ),
    ));
    addExcercise(Excercise(
      name: "Hammer Lifts",
      lastTimeStamp: DateTime(
        2019, 9, 17,
        9, 30
      ),
    ));
    addExcercise(Excercise(
      name: "Bop It",
      lastTimeStamp: DateTime(
        2019, 9, 17,
        9, 35
      ),
    ));
    addExcercise(Excercise(
      name: "Twist It",
      lastTimeStamp: DateTime(
        2019, 9, 17,
        9, 32
      ),
    ));
  }
}

//TODO: im sure there is a better way of doing this
//1. heap
//2. retain map instead of build each time
//3. etc...
addExcercise(Excercise theWorkout){
  //give it an ID
  theWorkout.id = Excercise.nextID;
  Excercise.nextID += 1;

  //add to workouts
  excercises.value.add(theWorkout);

  //sort
  Map<DateTime, Excercise> timeSinceToWorkout = new Map<DateTime, Excercise>();
  for(int i = 0; i < excercises.value.length; i++){
    Excercise workout = excercises.value[i];
    timeSinceToWorkout[workout.lastTimeStamp] = workout;
  }
  List<DateTime> sortedTimeSinces = timeSinceToWorkout.keys.toList();
  sortedTimeSinces.sort();

  //apply sort
  excercises.value.clear();
  for(int i = 0; i < sortedTimeSinces.length; i++){
    DateTime key = sortedTimeSinces[i];
    Excercise workout = timeSinceToWorkout[key];
    excercises.value.add(workout);
  }
}