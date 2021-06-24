//dart
import 'dart:convert';
import 'dart:io';

//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/shared/functions/safeSave.dart';
import 'package:swol/other/otherHelper.dart';

//class that 
//1. grabs exercises from storage
//2. places exercises to storage
class ExerciseData{
  static int nextID;
  static File _exerciseFile;

  //main struct we are maintaining (id -> exercise)
  //NOTE: we could use hashset but its slower than a map for deletion 
  //and accessing specific items
  static Map<int, AnExercise> _exercises; 
  //NOTE: value notifier here is required since 
  //we listen to order to determine whether we need to update the list
  //NOTE: silly mistake but we need a list, hash set doesn't maintain order
  //TODO: look into perhaps using "LinkedHashSet"
  static ValueNotifier<List<int>> exercisesOrder;

  //lets us control add and removing from the list with more precision
  static Map<int,AnExercise> getExercises(){
    return _exercises;
  }

  //we need to make sure that our structure only ever has more than what storage has
  static exercisesInit() async{
    if(_exerciseFile == null){
      //get what the file reference should be
      //todo keeping this one mispelled so I can keep my workouts...
      _exerciseFile = await StringJson.nameToFileReference("excercises");

      //get access to the file
      bool exists = await _exerciseFile.exists();

      //read in file data
      String fileData;
      if(exists == false){
        await _exerciseFile.create();
        //NOTE: don't use safeSave here because 
        //1. we need this to complete before continuing
        //2. we know this file hasn't been written to before 
        //  - since this is its init function
        await _exerciseFile.writeAsString("[]");
      }

      //read in our data
      fileData = await _exerciseFile.readAsString();
      _exercises = Map<int,AnExercise>();

      //grab the contacts
      int maxID = 0;
      List<dynamic> map = json.decode(fileData);
      for(int i = 0; i < map.length; i++){
        AnExercise thisExercise = AnExercise.fromJson(map[i]);
        maxID = (thisExercise.id > maxID) ? thisExercise.id : maxID; 
        await addExercise(
          thisExercise, 
          updateOrderAndFile: false, //we update the order at the end
        );
      }
      nextID = (maxID + 1);
      updateOrder();
    }
  }

  //when we are adding all the exercises in on init
  //we dont care to update order until the end
  //and we dont care to update the file since the info came from the file
  static addExercise(AnExercise theExercise, {
    bool updateOrderAndFile: true, 
  })async{
    //give it an ID (IF needed)
    if(theExercise.id == null){
      theExercise.id = nextID;
      nextID += 1;
    }

    //add to exercises
    _exercises[theExercise.id] = theExercise;

    //NOTE: since inprogress items are to be viewed above new items
    //we do have to update order
    if(updateOrderAndFile){
      updateOrder();
      updateFile();
    }
  }

  static deleteExercise(int id){
    if(_exercises.containsKey(id)){
      _exercises.remove(id);

      //update file
      updateOrder();
      updateFile();
    }
    else print("EXERCISE DOESN'T EXIST");
  }

  //TODO: there is a better way to do this
  static updateOrder(){
    //modify to then sort
    Map<DateTime, int> dateTimeToID = new Map<DateTime, int>();
    List<int> keys = _exercises.keys.toList();
    for(int i = 0; i < keys.length; i++){
      int keyIsID = keys[i];
      AnExercise exercise = _exercises[keyIsID];
      dateTimeToID[exercise.lastTimeStamp] = keyIsID;
    }

    //sort
    List<DateTime> dates = dateTimeToID.keys.toList();
    Function compare = (DateTime a, DateTime b) => b.compareTo(a);
    dates.sort(compare);
    //NOTE: dates are now sorted

    //initialize the structure we use if needed
    if(exercisesOrder == null){
      exercisesOrder = new ValueNotifier(new List<int>());
    }

    //find the place the new id in its position
    bool allMatch = dates.length == (exercisesOrder?.value ?? 0);
    List<int> newOrder = new List<int>();
    for(int i = 0; i < dates.length; i++){
      DateTime thisDate = dates[i];
      int thisID = dateTimeToID[thisDate];
  
      //check if order matches
      //if it does we save ourselves an extra reload
      allMatch = (allMatch && thisID == exercisesOrder.value[i]);

      //add this id in case not everything matches
      newOrder.add(thisID);
    }

    //official update
    if(allMatch == false){
      exercisesOrder.value = newOrder;
    }
  }

  //should never have to update from anywhere else
  static updateFile() async {
    String newFileData = _exercisesToString();
    SafeWrite.write(_exerciseFile, newFileData);
  }

  static String _exercisesToString(){
    List<AnExercise> exercises = _exercises.values.toList();
    String string = "[";
    for(int i = 0; i < exercises.length; i++){
      String str = json.encode(exercises[i].toJson());
      string += str;
      if(i < (exercises.length - 1)) string += ",";
    }
    string += "]";
    return string;
  }
}