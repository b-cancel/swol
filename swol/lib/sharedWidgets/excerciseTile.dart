//flutter
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//plugin
import 'package:page_transition/page_transition.dart';
import 'package:swol/excercise/defaultDateTimes.dart';

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
      String oneRepMax = "160";
      String error = "5";
      subtitle = Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(oneRepMax),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2.0,
              ),
              child: PlusMinusIcon(),
            ),
            Text(error),
          ],
        ),
      );
    }

    //right trailing icon
    Widget trailing;
    
    //if in progress set the proper icon
    if(LastTimeStamp.isInProgress(thisExcercise.lastTimeStamp)){
      if(thisExcercise.tempStartTime != null){
        //TODO test below
        Duration timeSinceBreakStarted = DateTime.now().difference(thisExcercise.tempStartTime);
        if(timeSinceBreakStarted > thisExcercise.recoveryPeriod){
          trailing = Icon(
            FontAwesomeIcons.hourglassEnd, //time done ticking
            color: Colors.red,
          );
        }
        else trailing = Icon(FontAwesomeIcons.hourglassHalf); //time ticking
      }
      else trailing = Icon(FontAwesomeIcons.hourglassStart); //time may tick again
    }
    else{
      if(tileInSearch){
        if(LastTimeStamp.isNew(thisExcercise.lastTimeStamp)){
          trailing = ListTileChipShell(
            chip: MyChip(
              chipString: 'NEW',
            ),
          );
        }
        else{
          if(LastTimeStamp.isHidden(thisExcercise.lastTimeStamp)){
            trailing = ListTileChipShell(
              chip: MyChip(
                chipString: 'HIDDEN',
              ),
            );
          }
          else{
            trailing = Text(
              DurationFormat.format(
                DateTime.now().difference(thisExcercise.lastTimeStamp),
                showMinutes: false,
                showSeconds: false,
                showMilliseconds: false,
                showMicroseconds: false,
                short: true,
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
        print("id:" + excerciseID.toString());
        print("time stamp: " + thisExcercise.lastTimeStamp.toString());
        print("name: " +  thisExcercise.name.toString());
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

class PlusMinusIcon extends StatelessWidget {
  const PlusMinusIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 16;

    return Container(
      height: size,
      width: size,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                FontAwesomeIcons.percentage,
                color: Colors.white.withOpacity(0.75),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: size/2,
              width: size/2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: ClipOval(
                      child: Container(
                        color: Theme.of(context).cardColor,
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: size/2,
              width: size/2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 4.0,
                    ),
                    child: ClipOval(
                      child: Container(
                        color: Theme.of(context).cardColor,
                        child: Icon(
                          FontAwesomeIcons.minus,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListTileChipShell extends StatelessWidget {
  const ListTileChipShell({
    Key key,
    @required this.chip,
  }) : super(key: key);

  final Widget chip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          chip,
        ],
      ),
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