import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swol/functions/helper.dart';
import 'package:swol/utils/safeSave.dart';
import 'package:swol/workout.dart';

File _excerciseFile;

//main struct we are maintaining (id -> excercise)
//this is the best action to take since this is the type of update we will be doing the most of usually
ValueNotifier<Map<int, Excercise>> _excercises;
//TODO: should also update when any excercise changes their timeStamp
ValueNotifier<List<int>> excercisesOrder;

ValueNotifier<Map<int, Excercise>> getExcercises(){
  return _excercises;
}

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
    _excercises = ValueNotifier(new Map<int, Excercise>());

    //grab the contacts
    List<dynamic> map = json.decode(fileData);
    for(int i = 0; i < map.length; i++){
      addExcercise(
        Excercise.fromJson(map[i]), 
        updateOrder: false, //we update the order at the end
        updateFile: false, //we got this data from the file
      );
    }
    _updateOrder();
  }
}

//TODO: im sure there is a better way of doing this
//1. heap
//2. retain map instead of build each time
//3. etc...
addExcercise(Excercise theWorkout, {bool updateOrder: true, bool updateFile: true}){
  //give it an ID (IF needed)
  if(theWorkout.id == null){
    theWorkout.id = Excercise.nextID;
    print("new index: " + theWorkout.id.toString());
    Excercise.nextID += 1;
  }

  //add to workouts
  _excercises.value[theWorkout.id] = theWorkout;
  if(updateOrder) _updateOrder();

  //update file
  _updateFile(updateFile);
}

deleteExcercise(int id, {bool updateFile: true}){
  if(_excercises.value.containsKey(id)){
    _excercises.value.remove(id);
    excercisesOrder.value.remove(id);

    //update file
    _updateFile(updateFile);
  }
  else print("EXCERCISE DOESN'T EXIST");
}

updateExcercise(
  int id, {
    DateTime lastTimeStamp, 
    String url,
    int predictionID,
    int repTarget,
    bool updateFile: true,
}){
  //update timestamp if desired
  if(lastTimeStamp != null){
    _excercises.value[id].lastTimeStamp = lastTimeStamp;
    _updateOrder();
  }

  if(url != null){
    _excercises.value[id].url = url;
  }

  if(predictionID != null){
    _excercises.value[id].predictionID = predictionID;
  }

  if(repTarget != null){
    _excercises.value[id].repTarget = repTarget;
  }

  //update file
  _updateFile(updateFile);
}

_updateOrder(){
  //modify to then sort
  Map<DateTime, int> dateTimeToID = new Map<DateTime, int>();
  List<int> keys = _excercises.value.keys.toList();
  for(int i = 0; i < keys.length; i++){
    int keyIsID = keys[i];
    Excercise workout = _excercises.value[keyIsID];
    dateTimeToID[workout.lastTimeStamp] = keyIsID;
  }

  //sort
  List<DateTime> dates = dateTimeToID.keys.toList();
  dates.sort();
  //NOTE: dates are now sorted

  //initialize the structure we use if needed
  if(excercisesOrder == null){
    excercisesOrder = new ValueNotifier(new List<int>());
  }

  //find the place the new id in its position
  List<int> newOrder = new List<int>();
  for(int i = 0; i < dates.length; i++){
    DateTime thisDate = dates[i];
    int thisID = dateTimeToID[thisDate];
    newOrder.add(thisID);
  }

  //official update
  excercisesOrder.value = newOrder;
}

//should never have to update from anywhere else
_updateFile(bool updateFile) async {
  if(updateFile){
    //save all this in the file
    String newFileData = Excercise.excercisesToString(_excercises.value.values.toList());

    //write the data
    safeSave(_excerciseFile, newFileData);
  }
  //ELSE we are probably just testing something
}