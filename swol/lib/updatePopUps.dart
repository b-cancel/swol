import 'package:flutter/material.dart';

import 'workout.dart';

//When pressing "next set" or "done with excercise"
//-------------------------
//  maybeAreYouSure [dimissible]
//  IF pop up open (timer not done)
//    IF no -> close
//    ELSE -> TO NEXT
//  ELSE
//  -> TO NEXT
//-------------------------
//NEXT: maybeUpdateFunction [dimissible]
//  IF pop up open (not matching expectations)
//    IF update -> update, TO NEXT
//    ELSE -> TO NEXT
//  ELSE -> TO NEXT
//-------------------------
//NEXT: maybeUpdateSets [dimissible]
//  IF pop up open (pressed "done" and sets don't match)
//    IF update -> update


//NOTE: run after the user completes their sets for a workout
//IF their sets don't match their target sets
//RETURNS: whether or not pop up came up
//update set count?
bool maybeUpdateSetTarget(
  BuildContext context, 
  Excercise excercise,
  Function afterDone,
){
  int setTarget = excercise.setTarget;
  int newSetTarget = excercise.tempSets;
  if(setTarget == newSetTarget) return false;
  else{
    String content = "You were aiming for " + setTarget.toString() + " sets\n";
    if(newSetTarget < setTarget){
      //BELOW expectations
      content += "But you only completed " + newSetTarget.toString() + " sets\n";
    }
    else{
      //ABOVE 
      content += "But you completed " + newSetTarget.toString() + " set\n";
    }
    content += "\nWould you like to update your Set Target?";

    //build
    showDialog<void>(
      context: context,
      //NOTE: althought they MUST answer the question
      //they may have accidentally clicked that they wanted to finish with this workout
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: Text("Update Set Target?"),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  afterDone();
                  Navigator.of(context).pop();
                },
                child: Text("Keep As Is"),
              ),
              RaisedButton(
                onPressed: (){
                  //TODO: update setTarget = newSetTarget
                  afterDone();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )
        ); 
      },
    );

    //the pop up came up
    return true;
  }
}