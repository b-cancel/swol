//flutter
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swol/excerciseAction/tabs/record/advancedField.dart';
import 'package:swol/excerciseAction/tabs/record/changeFunction.dart';

//internal
import 'package:swol/excerciseAction/tabs/suggest/suggestion/setDisplay.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/cardWithHeader.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/bottomButtons.dart';
import 'package:swol/other/functions/helper.dart';
import 'package:swol/shared/functions/goldenRatio.dart';
import 'package:swol/shared/structs/anExcercise.dart';

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
    @required this.excercise,
    @required this.backToSuggestion,
    @required this.setBreak,
    @required this.statusBarHeight,
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
  });

  final AnExcercise excercise;
  final Function backToSuggestion;
  final Function setBreak;
  final double statusBarHeight;
  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double appBarHeight = 56; //constant according to flutter docs
    double spaceToRedistribute = fullHeight - appBarHeight - statusBarHeight;

    return Container(
      width: fullHeight,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomButtons(
              excercise: excercise,
              forwardAction: setBreak,
              forwardActionWidget: Text(
                "Take Set Break",
              ),
              backAction: backToSuggestion,
            ),
          ),
          Positioned(
            top: 0,
            child: SetRecordCardBottom(
              excercise: excercise,
              rawSpaceToRedistribute: spaceToRedistribute,
              heroUp: heroUp,
              heroAnimDuration: heroAnimDuration,
              heroAnimTravel: heroAnimTravel,
            ),
          ),
        ],
      ),
    );
  }
}

class SetRecordCardBottom extends StatelessWidget {
  SetRecordCardBottom({
    Key key,
    @required this.excercise,
    @required this.rawSpaceToRedistribute,
    this.removeBottomButtonSpacing: true,
    this.extraSpacing: 24,
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
  }) : super(key: key);

  final AnExcercise excercise;
  final double rawSpaceToRedistribute;
  final double extraSpacing;
  final bool removeBottomButtonSpacing;
  //optional
  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;

  @override
  Widget build(BuildContext context) {
    double spaceToRedistribute = rawSpaceToRedistribute;

    //make instinct based removals since all the UI is semi contected
    spaceToRedistribute -= extraSpacing;
    if (removeBottomButtonSpacing) {
      //NOTE: 64 is the height of the bottom buttons
      spaceToRedistribute -= 64;
    }

    //card radius
    Radius cardRadius = Radius.circular(24);
    Color distanceColor = Theme.of(context).cardColor; 
    int id = 0;
    if(id == 1) distanceColor = Colors.red.withOpacity(0.33);
    else if(id == 2) distanceColor = Colors.red.withOpacity(0.66);
    else if(id == 3) distanceColor = Colors.red;

    //return
    return Container(
      //The extra padding that just looked right
      height: spaceToRedistribute - 12,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 24,
            color: Theme.of(context).accentColor,
          ),
          Stack(
            children: <Widget>[
              Positioned.fill(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: SetDisplay(
                  useAccent: false,
                  title: "Goal Set",
                  lastWeight: 124,
                  lastReps: 23,
                  heroUp: heroUp,
                  heroAnimDuration: heroAnimDuration,
                  heroAnimTravel: heroAnimTravel,
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "24",
                          style: GoogleFonts.robotoMono(
                            color: distanceColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 96,
                            wordSpacing: 0,
                          ),
                        ),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                FontAwesomeIcons.percentage,
                                color: distanceColor,
                                size: 42,
                              ),
                              Text(
                                "higher",
                                style: TextStyle(
                                  fontSize: 42,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: Offset(0, -16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            "than calculated by the",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        ChangeFunction(
                          excercise: excercise,
                          middleArrows: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          CardWithHeader(
            header: "Record Set",
            aLittleSmaller: true,
            child: RecordFields(),
          ),
        ],
      ),
    );
  }
}
