//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';

//internal: basic
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/other/durationFormat.dart';

//internal: link
import 'package:swol/excerciseAction/excercisePage.dart';

class ExcerciseTile extends StatelessWidget {
  ExcerciseTile({
    @required this.excerciseID,
    this.listDisplay,
  });

  final int excerciseID;
  //If this is displayed in the list then we dont have to show alot of info
  final bool listDisplay;

  @override
  Widget build(BuildContext context) {
    AnExcercise thisExcercise = ExcerciseData.getExcercises().value[excerciseID];

    //calculations
    Duration timeSince = DateTime.now().difference(thisExcercise.lastTimeStamp);

    //subtitle gen
    Widget subtitle;
    if(timeSince < Duration.zero) subtitle = null;
    else if(timeSince > Duration(days: 365 * 100)) subtitle = null;
    else{
      subtitle = Text(DurationFormat.format(timeSince));
    }

    //if not display
    if(listDisplay == false && subtitle == null){
      if(timeSince < Duration.zero){
        subtitle = MyChip(
          chipString: "Hidden",
        );
      }
      else{
        subtitle = MyChip(
          chipString: 'New',
        );
      }
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

        Navigator.push(
          context, 
          PageTransition(
            type: PageTransitionType.rightToLeft, 
            child: ExcercisePage(
              excerciseID: excerciseID,
            ),
          ),
        );
      },
      title: Text(thisExcercise.name),
      subtitle: subtitle,
      trailing: Icon(Icons.chevron_right),
    );
  }
}

class MyChip extends StatelessWidget {
  const MyChip({
    Key key,
    @required this.chipString,
    this.inverse: false,
  }) : super(key: key);

  final String chipString;
  final bool inverse;

  @override
  Widget build(BuildContext context) {
    Color chipColor = (inverse) ? Theme.of(context).primaryColorDark : Theme.of(context).accentColor;
    Color textColor = (inverse) ? Theme.of(context).accentColor : Theme.of(context).primaryColorDark;

    return Container(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 4,
        ),
        decoration: new BoxDecoration(
          color: chipColor,
          borderRadius: new BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Text(
          chipString,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}