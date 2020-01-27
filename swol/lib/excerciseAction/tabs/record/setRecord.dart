//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//plugins
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swol/excerciseAction/tabs/recovery/recovery.dart';

//internal
import 'package:swol/excerciseAction/tabs/sharedWidgets/bottomButtons.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggestion/setDisplay.dart';
import 'package:swol/shared/functions/goldenRatio.dart';

//TODO: because of the cursor, the tooltip menu, and other stuff 
//TODO: we need to actually get close to guessing what the text size should be
//TODO: for this we first switch to mono space font and do a test on each character get the size and width of each
//TODO: and how this realtes or changes as font size does
//TODO: so that then for any screen size AND quantity of characters we can guess the width
//TODO: then to make up for the difference that are smaller we use fitted box
//TODO: we also have to convert the whole thing into a list view that contains a container of the size of the max height
//TODO: this will allow the keyboard to scroll the fields into position when they are being editing 
//TODO: or preferably I think use Scrollable.ensureVisible

//TODO: use directionality widget to switch start direction "directionality" 

class SetRecord extends StatelessWidget {
  SetRecord({
    @required this.excerciseID,
    @required this.backToSuggestion,
    @required this.setBreak,
    @required this.statusBarHeight,
  });

  final int excerciseID;
  final Function backToSuggestion;
  final Function setBreak;
  final double statusBarHeight;

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double appBarHeight = 56; //constant according to flutter docs
    double spaceToRedistribute = fullHeight - appBarHeight - statusBarHeight ;

    return Container(
      width: fullHeight,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomButtons(
              forwardAction: setBreak,
              forwardActionWidget: Text(
                "Take Set Break",
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              backAction: backToSuggestion,
            ),
          ),
          Positioned(
            top: 0,
            child: SetRecordCardBottom(
              rawSpaceToRedistribute: spaceToRedistribute,
            ),
          ),
        ],
      ),
    );
  }
}

class SetRecordCardBottom extends StatelessWidget {
  const SetRecordCardBottom({
    Key key,
    @required this.rawSpaceToRedistribute,
    this.removeBottomButtonSpacing: true,
    this.extraSpacing: 24,
  }) : super(key: key);

  final double rawSpaceToRedistribute;
  final double extraSpacing;
  final bool removeBottomButtonSpacing;

  @override
  Widget build(BuildContext context) {
    double spaceToRedistribute = rawSpaceToRedistribute;

    //make instinct based removals since all the UI is semi contected
    spaceToRedistribute -= extraSpacing;
    if(removeBottomButtonSpacing){
      //NOTE: 64 is the height of the bottom buttons
      spaceToRedistribute -= 64;
    }

    //card radius
    Radius cardRadius = Radius.circular(24);

    //return
    return Container(
      //The extra padding that just looked right
      height: spaceToRedistribute - 12,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PreviousCardCorners(
            cardRadius: cardRadius,
            child: Hero(
              tag: 'goalSet',
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: cardRadius,
                    bottomLeft: cardRadius,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: SetDisplay(
                  title: "Goal Set",
                  lastWeight: 124,
                  lastReps: 23,
                ),
              ),
            ),
          ),
          Flexible(
            flex: smallNumber,
            child: Container(),
          ),
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
          ),
          Flexible(
            flex: largeNumber,
            child: Container(),
          ),
          //actualCard,
        ],
      ),
    );
  }
}