//flutter
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//plugin
import 'package:page_transition/page_transition.dart';

//internal: basic
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/other/durationFormat.dart';

//internal: link
import 'package:swol/excerciseAction/excercisePage.dart';

//widget
class ExcerciseTile extends StatelessWidget {
  ExcerciseTile({
    @required this.excerciseID,
    this.tileInSearch: false,
    @required this.navSpread,
  });

  final int excerciseID;
  //If this is displayed in the list then we dont have to show alot of info
  final bool tileInSearch;
  final ValueNotifier<bool> navSpread;

  @override
  Widget build(BuildContext context) {
    AnExcercise thisExcercise = ExcerciseData.getExcercises().value[excerciseID];

    //calcualted 1 rep max if possible
    Widget subtitle;
    if(thisExcercise.lastWeight != null){
      //TODO: actually grab 1 rep max and calculate the std deviation given all the formulas results
      subtitle = Text("160 +/- 5");
    }

    //right trailing icon
    Widget trailing;

    //if in progress set the proper icon
    bool inProgress = (thisExcercise.tempSetCount > 0 || thisExcercise.tempStartTime != null);
    if(inProgress){
      if(thisExcercise.tempStartTime != null){
        //TODO test below
        Duration timeSinceBreakStarted = DateTime.now().difference(thisExcercise.tempStartTime);
        if(timeSinceBreakStarted > thisExcercise.recoveryPeriod){
          trailing = Icon(
            Icons.alarm,
            color: Colors.red,
          );
        }
        else trailing = Icon(Icons.alarm);
      }
      else trailing = Icon(FontAwesomeIcons.hourglassHalf);
    }
    else{
      if(tileInSearch){
        if(thisExcercise.lastTimeStamp == null){
          trailing = MyChip(
            chipString: 'New',
          );
        }
        else{
          Duration timeSinceLastTime = DateTime.now().difference(thisExcercise.lastTimeStamp);
          if(timeSinceLastTime > Duration(days: 365 * 100)){
            trailing = MyChip(
              chipString: 'Hidden',
            );
          }
          else{
            trailing = Text(
              DurationFormat.format(
                timeSinceLastTime,
                showMinutes: false,
                showSeconds: false,
                showMilliseconds: false,
                showMicroseconds: false,
                short: false,
              ),
            );
          }
        }
      }
      else trailing = Icon(Icons.chevron_right);
    }

    //build our widget given that search term
    return ListTile(
      onTap: (){
        //-----
        print("name: " +  thisExcercise.name.toString() + " => " + excerciseID.toString());
        print("url: " + thisExcercise.url.toString());
        print("note: " + thisExcercise.note.toString());
        //-----
        print("prediction ID: " + thisExcercise.predictionID.toString());
        print("rep target: " + thisExcercise.repTarget.toString());
        print("recovery: " + thisExcercise.recoveryPeriod.toString());
        print("set target: " + thisExcercise.setTarget.toString());

        //pop search page
        if(tileInSearch){
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        }

        //travel to page
        navSpread.value = true;
        Navigator.push(
          context, 
          PageTransition(
            type: PageTransitionType.rightToLeft, 
            child: ExcercisePage(
              excerciseID: excerciseID,
              navSpread: navSpread,
            ),
          ),
        );
      },
      title: Text(thisExcercise.name),
      subtitle: subtitle,
      trailing: trailing,
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
      child: Padding(
        padding: EdgeInsets.only(
          right: 4,
        ),
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
      ),
    );
  }
}