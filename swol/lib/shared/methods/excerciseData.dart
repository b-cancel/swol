//dart
import 'dart:convert';
import 'dart:io';

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:shared_preferences/shared_preferences.dart';

//internal
import 'package:swol/shared/functions/safeSave.dart';
import 'package:swol/other/otherHelper.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//class that 
//1. grabs excercises from storage
//2. places excercises to storage
class ExcerciseData{
  static File _excerciseFile;

  //main struct we are maintaining (id -> excercise)
  //this is the best action to take since this is the type of update we will be doing the most of usually
  static ValueNotifier<Map<int, AnExcercise>> _excercises;
  static ValueNotifier<List<int>> excercisesOrder;

  //lets us control add and removing from the list with more precision
  static ValueNotifier<Map<int, AnExcercise>> getExcercises(){
    return _excercises;
  }

  //we need to make sure that our structure only every has more than what storage has
  static excercisesInit()async{
    if(_excerciseFile == null){
      //get what the file reference should be
      _excerciseFile = await StringJson.nameToFileReference("excercises");

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
      _excercises = ValueNotifier(new Map<int, AnExcercise>());

      //grab the contacts
      List<dynamic> map = json.decode(fileData);
      for(int i = 0; i < map.length; i++){
        await addExcercise(
          AnExcercise.fromJson(map[i]), 
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
  static addExcercise(AnExcercise theWorkout, {
    bool updateOrder: true, 
    bool updateFile: true,
  })async{
    //give it an ID (IF needed)
    if(theWorkout.id == null){
      theWorkout.id = AnExcercise.nextID;
      AnExcercise.nextID += 1;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(
        "nextID", 
        AnExcercise.nextID,
      );
    }

    //add to workouts
    _excercises.value[theWorkout.id] = theWorkout;
    if(updateOrder) _updateOrder();

    //update file
    _updateFile(updateFile);
  }

  static deleteExcercise(int id, {bool updateFile: true}){
    if(_excercises.value.containsKey(id)){
      _excercises.value.remove(id);
      excercisesOrder.value.remove(id);

      //update file
      _updateFile(updateFile);
    }
    else print("EXCERCISE DOESN'T EXIST");
  }

  static updateExcercise(
    int id, {
      //---settings
      //for sorting purposes
      DateTime lastTimeStamp, //TODO: test
      //basic 
      String name, 
      String note, 
      String url,
      //other
      int predictionID, //TODO: test
      int repTarget, //TODO: test
      Duration recoveryPeriod, //TODO: test
      int setTarget, //TODO: test
      //---recorded
      int lastWeight, //TODO: test
      int lastReps, //TODO: test

      //---Temporary
      int tempWeight, //TODO: test
      bool tempWeightCanBeNull: false, //TODO: test
      int tempReps, //TODO: test
      bool tempRepsCanBeNull: false, //TODO: test
      DateTime tempStartTime, //TODO: test
      bool tempStartTimeCanBeNull: false, //TODO: test
      int tempSetCount, //TODO: test
      bool tempSetCountCanBeNull: false, //TODO: test

      //---OTHER
      bool updateFile: true,
  }){
    //update timestamp if desired
    if(lastTimeStamp != null){
      _excercises.value[id].lastTimeStamp = lastTimeStamp;
      _updateOrder();
    }

    if(name != null){
      //TODO: figure out how this is working
      //It should cause things to reload but I'm not sure where its doing it
      _excercises.value[id].name = name;
    }

    if(note != null){
      _excercises.value[id].note = note;
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

    if(recoveryPeriod != null){
      _excercises.value[id].recoveryPeriod = recoveryPeriod;
    }

    if(setTarget != null){
      _excercises.value[id].setTarget = setTarget;
    }

    if(lastWeight != null){
      _excercises.value[id].lastWeight = lastWeight;
    }

    if(lastReps != null){
      _excercises.value[id].lastReps = lastReps;
    }

    if(tempWeight != null || tempWeightCanBeNull){
      _excercises.value[id].tempWeight = tempWeight;
    }

    if(tempReps != null || tempRepsCanBeNull){
      _excercises.value[id].tempReps = tempReps;
    }

    if(tempStartTime != null || tempStartTimeCanBeNull){
      _excercises.value[id].tempStartTime = tempStartTime;
    }

    if(tempSetCount != null || tempSetCountCanBeNull){
      _excercises.value[id].tempSetCount = tempSetCount;
    }

    //update file
    _updateFile(updateFile);
  }

  static _updateOrder(){
    //modify to then sort
    Map<DateTime, int> dateTimeToID = new Map<DateTime, int>();
    List<int> keys = _excercises.value.keys.toList();
    for(int i = 0; i < keys.length; i++){
      int keyIsID = keys[i];
      AnExcercise workout = _excercises.value[keyIsID];
      dateTimeToID[workout.lastTimeStamp] = keyIsID;
    }

    //sort
    List<DateTime> dates = dateTimeToID.keys.toList();
    Function compare = (DateTime a, DateTime b) => b.compareTo(a);
    dates.sort(compare);
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
  static _updateFile(bool updateFile) async {
    if(updateFile){
      //save all this in the file
      String newFileData = AnExcercise.excercisesToString(_excercises.value.values.toList());

      //write the data
      SafeWrite.write(_excerciseFile, newFileData);
    }
    //ELSE we are probably just testing something
  }
}