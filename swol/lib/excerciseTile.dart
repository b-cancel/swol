import 'package:flutter/material.dart';
import 'package:swol/helpers/main.dart';
import 'package:swol/utils/data.dart';
import 'package:swol/workout.dart';

class ExcerciseTile extends StatelessWidget {
  ExcerciseTile({
    @required this.excerciseID,
  });

  final int excerciseID;

  @override
  Widget build(BuildContext context) {
    Excercise thisExcercise = getExcercises().value[excerciseID];

    //calculations
    Duration timeSince = DateTime.now().difference(thisExcercise.lastTimeStamp);
    bool never = (timeSince > Duration(days: 365 * 100));

    //subtitle gen
    Widget subtitle;
    if(never){
      subtitle = Container(
        alignment: Alignment.topLeft,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 4,
          ),
          decoration: new BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: new BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Text(
            "NEW",
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    else{
      subtitle = Text(formatDuration(timeSince));
    }

    //build our widget given that search term
    return ListTile(
      onTap: (){
        print("timestamp: " + thisExcercise.lastTimeStamp.toString());
        //-----
        print("name: " +  thisExcercise.name.toString() + " => " + excerciseID.toString());
        print("url: " + thisExcercise.url.toString());
        print("note: " + thisExcercise.note.toString());
        //-----
        print("recovery: " + thisExcercise.recoveryPeriod.toString());
        print("rep target: " + thisExcercise.repTarget.toString());
        print("prediction ID: " + thisExcercise.predictionID.toString());
        print("set target: " + thisExcercise.lastSetTarget.toString());
      },
      title: Text(thisExcercise.name),
      subtitle: subtitle,
      trailing: Icon(Icons.chevron_right),
    );
  }
}