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

//Start point
maybePopUpsBeforeNext(
  BuildContext context,
  {
    @required Excercise excercise,
    @required bool nextAndDone, 
}){
  maybeAreYouSurePopUp(
    context, 
    excercise: excercise, 
    nextAndDone: nextAndDone,
  );
}

//show are you sure IF the timer hasn't finished
maybeAreYouSurePopUp(
  BuildContext context,
  {
    @required Excercise excercise,
    @required bool nextAndDone, 
}){
  Function next = maybeUpdateFunctionPopUp(
    context,
    excercise: excercise,
    nextAndDone: nextAndDone,
  );

  //Are you sure
  Duration timerRuntime = DateTime.now().difference(excercise.timerStartTime);
  if(timerRuntime > excercise.lastBreak) next();
  else{
    //round to nearest 5 seconds (to avoid problems later)
    int minutes = timerRuntime.inMinutes;
    timerRuntime = timerRuntime - Duration(minutes: minutes);
    int seconds = timerRuntime.inSeconds;
    int modResult = seconds ~/ 5;

    //round up (not just truncate)
    if(seconds != (5*modResult)){
      //our seconds are not divisible by 5
      seconds = 5;
    }
    else seconds = 0;
    seconds += (5 * modResult);
    
    //create object
    Duration newTimerRuntime = Duration(
      minutes: minutes,
      seconds: seconds,
    );

    //gen text
    String updateRecoveryText;
    if(minutes == 0 && seconds == 0){
      updateRecoveryText = "Don't wait";
    }
    else{
      //some waiting will occur
      updateRecoveryText = "Wait ";

      //handle minutes
      //NOTE: will always have space before
      bool minutesPresent = (minutes != 0);
      if(minutesPresent){
        updateRecoveryText += (minutes.toString() + " minute");
        if(minutes > 1){
          updateRecoveryText += "s";
        }
      }

      if(seconds != 0){
        String secondsText = (seconds.toString() + " second");
        if(seconds > 1){
          secondsText += "s";
        }

        //react to the lack of minutes
        if(minutesPresent){
          updateRecoveryText += (" and " + secondsText);
        }
        else updateRecoveryText += secondsText;
      }
    }
    updateRecoveryText += "\nbetween sets instead";

    //show the pop up
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: Text("Skip Recovery Period?"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "If you decided to shorten your recovery period\n"
                  + "You can update your recovery period below"
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: OutlineButton(
                    onPressed: (){
                      //TODO: actually update break time
                      
                      //get rid of this pop up
                      Navigator.of(context).pop();

                      //move onto the next
                      next();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        updateRecoveryText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Otherwise it's best if you give your muscles a chance to recover",
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  //get rid of this pop up
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              RaisedButton(
                onPressed: (){
                  //get rid of this pop up
                  Navigator.of(context).pop();

                  //move onto the next
                  next();
                },
                child: Text(
                  "Confirm",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ); 
      },
    );
  }
}

//show update function pop up 
//if our temp set didn't match our expectations based on our last set
maybeUpdateFunctionPopUp(
  BuildContext context,
  {
    @required Excercise excercise,
    @required bool nextAndDone, 
}){
  print("function pop up here B");
}

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