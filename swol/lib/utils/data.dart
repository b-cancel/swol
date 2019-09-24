import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swol/functions/helper.dart';
import 'package:swol/utils/safeSave.dart';
import 'package:swol/workout.dart';

File _excerciseFile;

//main struct we are maintaining
ValueNotifier<List<Excercise>> excercises;

excercisesInit()async{
  if(_excerciseFile == null){
    //get what the file reference should be
    _excerciseFile = await nameToFileReference("excercises");

    //get access to the file
    bool exists = await _excerciseFile.exists();

    //read in file data
    String fileData;
    if(exists == false){
      await _excerciseFile.create();
      //NOTE: don't use safeSave here because 
      //1. we need this to complete before continuing
      //2. we know this file hasn't been written to before 
      //  - since this is its init function
      await _excerciseFile.writeAsString("[]");
    }
    //read in our data
    fileData = await _excerciseFile.readAsString();
    excercises = ValueNotifier(new List<Excercise>());

    //grab the contacts
    //_excerciseFile = json.decode(fileData);
    List<dynamic> map = json.decode(fileData);
    
    for(int i = 0; i < map.length; i++){
      Excercise ex = Excercise.fromJson(map[i]);
      excercises.value.add(ex);
    }
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

  //update file
  _updateFile();
}

//should never have to update from anywhere else
_updateFile() async {
  //save all this in the file
  String newFileData = Excercise.excercisesToString(excercises.value);

  //write the data
  safeSave(_excerciseFile, newFileData);
}