import 'package:flutter/material.dart';
import 'package:swol/excercise/excerciseStructure.dart';

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
    @required AnExcercise excercise,
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
    @required AnExcercise excercise,
    @required bool nextAndDone, 
}){
  Function next = maybeUpdateFunctionPopUp(
    context,
    excercise: excercise,
    nextAndDone: nextAndDone,
  );

  //Are you sure
  Duration timerRuntime = DateTime.now().difference(excercise.tempStartTime);
  if(timerRuntime > excercise.recoveryPeriod) next();
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "If you want to shorten your recovery\n"
                  + "You can update it below"
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom: 24,
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
    @required AnExcercise excercise,
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
  AnExcercise excercise,
  Function afterDone,
){
  int setTarget = excercise.lastSetTarget;
  int newSetTarget = excercise.tempSetCount;
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

/*
Pop up tested when tapping a form
//test all cases
bool timerComplete;
bool functionsMatch;
bool setsMatch;
if(index == 0){
  timerComplete = false;
  functionsMatch = false;
  setsMatch = false;
}
else if(index == 1){
  timerComplete = false;
  functionsMatch = false;
  setsMatch = true; //t
}
else if(index == 2){
  timerComplete = false;
  functionsMatch = true; //t
  setsMatch = false;
}
else if(index == 3){
  timerComplete = false; //f
  functionsMatch = true;
  setsMatch = true;
}
else if(index == 4){
  timerComplete = true; //t
  functionsMatch = false;
  setsMatch = false;
}
else if(index == 5){
  timerComplete = true;
  functionsMatch = false; //f
  setsMatch = true;
}
else if(index == 6){
  timerComplete = true;
  functionsMatch = true;
  setsMatch = false; //f
}
else{
  timerComplete = true;
  functionsMatch = true;
  setsMatch = true;
}

//create code given the condition
if(timerComplete){
  //guarantee the timer show up as complete

  //the timer started a minute ago
  newExcercise.tempStartTime = DateTime.now().subtract(Duration(minutes: 1));
  //it only needed to run for a second
  newExcercise.recoveryPeriod = Duration(seconds: 1);
}
else{
  //guarantee the timer show up as NOT complete
  //the timer started a minute ago
  newExcercise.tempStartTime = DateTime.now().subtract(Duration(minutes:2, seconds: 7));
  //it NEEDS to run for 1 hour
  newExcercise.recoveryPeriod = Duration(hours: 1);
}

//prep for functions match

//last data
newExcercise.lastWeight = 160;
newExcercise.lastReps = 8;

//assume they do the same quantity of reps as expected
newExcercise.tempReps = 8;

//expected 1 rep max
double expectedOneRepMax = To1RM.fromWeightAndReps(
  newExcercise.lastWeight.toDouble(), 
  newExcercise.lastReps.toDouble(), 
  newExcercise.predictionID,
);

//calculated expectedWeight
double expectedWeight = ToWeight.fromRepAnd1Rm(
  newExcercise.tempReps.toDouble(), 
  expectedOneRepMax, 
  newExcercise.predictionID,
);

//functions match
if(functionsMatch){
  newExcercise.tempWeight = expectedWeight.toInt();
}
else{
  //TODO: test both above and below (-+ 50)
  newExcercise.tempWeight = expectedWeight.toInt() + 50;
}

//sets match
if(setsMatch){
  newExcercise.tempSetCount = newExcercise.lastSetTarget;
}
else{
  //TODO: test both above and below (-+ 1)
  newExcercise.tempSetCount = newExcercise.lastSetTarget + 1;
}

//TODO: start with maybe are you sure
maybePopUpsBeforeNext(
  context,
  excercise: newExcercise,
  //TODO: test both
  nextAndDone: true,
);
*/