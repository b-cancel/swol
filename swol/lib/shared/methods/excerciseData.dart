//dart
import 'dart:convert';
import 'dart:io';

//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/functions/safeSave.dart';
import 'package:swol/other/otherHelper.dart';

//class that 
//1. grabs excercises from storage
//2. places excercises to storage
class ExcerciseData{
  static File _excerciseFile;

  //main struct we are maintaining (id -> excercise)
  //NOTE: we could use hashset but its slower than a map for deletion 
  //and accessing specific items
  static Map<int, AnExcercise> _excercises; 
  //NOTE: value notifier here is required since 
  //we listen to order to determine whether we need to update the list
  //NOTE: silly mistake but we need a list, hash set doesn't maintain order
  //TODO: look into perhaps using "LinkedHashSet"
  static ValueNotifier<List<int>> excercisesOrder;

  //lets us control add and removing from the list with more precision
  static Map<int,AnExcercise> getExcercises(){
    return _excercises;
  }

  //we need to make sure that our structure only ever has more than what storage has
  static excercisesInit() async{
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
      _excercises = Map<int,AnExcercise>();

      //grab the contacts
      List<dynamic> map = json.decode(fileData);
      for(int i = 0; i < map.length; i++){
        await addExcercise(
          AnExcercise.fromJson(map[i]), 
          updateOrderAndFile: false, //we update the order at the end
        );
      }
      _updateOrder();
    }
  }

  //when we are adding all the excercises in on init
  //we dont care to update order until the end
  //and we dont care to update the file since the info came from the file
  static addExcercise(AnExcercise theWorkout, {
    bool updateOrderAndFile: true, 
  })async{
    //give it an ID (IF needed)
    if(theWorkout.id == null){
      theWorkout.id = AnExcercise.nextID;
      AnExcercise.nextID += 1;
      SharedPrefsExt.setNextID(AnExcercise.nextID);
    }

    //add to workouts
    _excercises[theWorkout.id] = theWorkout;

    //NOTE: since inprogress items are to be viewed above new items
    //we do have to update order
    if(updateOrderAndFile){
      _updateOrder();
      _updateFile();
    }
  }

  static deleteExcercise(int id){
    if(_excercises.containsKey(id)){
      _excercises.remove(id);
      excercisesOrder.value.remove(id);

      //update file
      _updateFile();
    }
    else print("EXCERCISE DOESN'T EXIST");
  }

  /*
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
      _excercises[id].lastTimeStamp = lastTimeStamp;
      _updateOrder();
    }

    if(name != null){
      //TODO: figure out how this is working
      //It should cause things to reload but I'm not sure where its doing it
      _excercises[id].name = name;
    }

    if(note != null){
      _excercises[id].note = note;
    }

    if(url != null){
      _excercises[id].url = url;
    }

    if(predictionID != null){
      _excercises[id].predictionID = predictionID;
    }

    if(repTarget != null){
      _excercises[id].repTarget = repTarget;
    }

    if(recoveryPeriod != null){
      _excercises[id].recoveryPeriod = recoveryPeriod;
    }

    if(setTarget != null){
      _excercises[id].setTarget = setTarget;
    }

    if(lastWeight != null){
      _excercises[id].lastWeight = lastWeight;
    }

    if(lastReps != null){
      _excercises[id].lastReps = lastReps;
    }

    if(tempWeight != null || tempWeightCanBeNull){
      _excercises[id].tempWeight = tempWeight;
    }

    if(tempReps != null || tempRepsCanBeNull){
      _excercises[id].tempReps = tempReps;
    }

    if(tempStartTime != null || tempStartTimeCanBeNull){
      _excercises[id].tempStartTime = tempStartTime;
    }

    if(tempSetCount != null || tempSetCountCanBeNull){
      _excercises[id].tempSetCount = tempSetCount;
    }

    //update file
    _updateFile();
  }
  */

  static _updateOrder(){
    //modify to then sort
    Map<DateTime, int> dateTimeToID = new Map<DateTime, int>();
    List<int> keys = _excercises.keys.toList();
    for(int i = 0; i < keys.length; i++){
      int keyIsID = keys[i];
      AnExcercise excercise = _excercises[keyIsID];
      dateTimeToID[excercise.lastTimeStamp] = keyIsID;
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
  static _updateFile() async {
    String newFileData = AnExcercise.excercisesToString(
      _excercises.values.toList()
    );
    SafeWrite.write(_excerciseFile, newFileData);
  }
}