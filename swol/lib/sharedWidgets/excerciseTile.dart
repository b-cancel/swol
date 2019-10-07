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

    Duration timeSince = DateTime.now().difference(thisExcercise.lastTimeStamp);
    Widget subtitle = (tileInSearch) 
    ?  MyChip(
      chipString: 'New',
    ) 
    : null;

    //adjust if its an archived excercise or a regular one
    if((timeSince > Duration(days: 365 * 100)) == false){
      //its PROBABLY NOT NEW 
      //NOTE: its entirely possible that it is tho by the person adding it and then immediately archiving it

      //TODO: confirm that its not new
      bool notNew = true;
      
      if(notNew){
        //TODO: actual calculate 1 rep max based on previous data 
        //TODO: and perhaps express accuracy of calculation based on distance from 1 rep max
        int oneRepMax = 160;

        //subtitle gen
        subtitle = Text(oneRepMax.toString() + " 1RM");

        if(timeSince < Duration.zero){ //hidden item
          subtitle = Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (tileInSearch) 
              ?  MyChip(
                chipString: 'Hidden',
              ) 
              : Container(),
              subtitle,
            ],
          );
        }
        //ELSE... regular item only need the calculated 1 rep max
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