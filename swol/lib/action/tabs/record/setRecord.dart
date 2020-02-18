//flutter
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swol/action/popUps/error.dart';

//internal: action
import 'package:swol/action/tabs/record/field/advancedField.dart';
import 'package:swol/action/tabs/record/body/calibration.dart';
import 'package:swol/action/tabs/record/body/adjustment.dart';
import 'package:swol/action/shared/cardWithHeader.dart';
import 'package:swol/action/bottomButtons/button.dart';
import 'package:swol/action/page.dart';

//internal: shared
import 'package:swol/shared/widgets/simple/conditional.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/methods/theme.dart';

//TODO: on set init AND on resume we focus on first (if there is anything to focus on obvi)
//TODO: this includes pop ups

//TODO: the set should also be shown the revert button
//TODO: make sure that we refocus on the problematic field

//widget
class SetRecord extends StatelessWidget {
  SetRecord({
    @required this.excercise,
    @required this.statusBarHeight,
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
  });

  final AnExcercise excercise;
  final double statusBarHeight;
  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;

  //build
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double appBarHeight = 56; //constant according to flutter docs
    double spaceToRedistribute =
        fullHeight - appBarHeight - statusBarHeight;

    //determine what page we are showing
    bool calibrationRequired = excercise.lastWeight == null;
    Function backAction;
    if(calibrationRequired ==false){
      backAction = () {
        ExcercisePage.pageNumber.value = 0;
      };
    }

    //calc sets passed for bottom buttons
    int setsPassed = excercise.tempSetCount.value;
    bool timerNotStarted = excercise.tempStartTime.value == AnExcercise.nullDateTime;
    if(timerNotStarted) setsPassed += 1;

    //color for bottom buttons
    bool lastSetOrBefore = setsPassed <= excercise.setTarget.value;
    Color buttonsColor =  lastSetOrBefore ? Theme.of(context).accentColor : Theme.of(context).cardColor;

    //widget
    Widget recordSetFields = CardWithHeader(
      header: "Record Set",
      aLittleSmaller: true,
      child: RecordFields(
        heroAnimDuration: heroAnimDuration,
      ),
    );

    Widget buttonsOnBottom = Theme(
      data: MyTheme.light,
      child: SetRecordButtonsWithWhiteContext(
        buttonsColor: buttonsColor, 
        excercise: excercise, 
        timerNotStarted: timerNotStarted, 
        backAction: backAction,
      ),
    );

    if(calibrationRequired){
      /*
      Conditional(
                  condition: calibrationRequired,
                  ifTrue: Padding(
                    padding: EdgeInsets.only(
                      bottom: 48,
                    ),
                    child: CalibrationCard(),
                  ),
                  ifFalse: 
                ),
      */

      /*
      Visibility(
                  visible: calibrationRequired,
                  child: 
                ),
      */
      //clipping so "hero" doesn't show up in the other page
      return ClipRRect(
        child: ListView(
          children: <Widget>[
            Container(
              height: spaceToRedistribute,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  CalibrationCard(),
                  Container(
                    height: 48.0,
                    child:  Shimmer.fromColors(
                      direction: ShimmerDirection.ltr,
                      baseColor: Theme.of(context).primaryColor,
                      highlightColor: Theme.of(context).cardColor,
                      child: Icon(
                        MaterialCommunityIcons.getIconData("chevron-double-up"),
                        size: 36,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  recordSetFields,
                  Expanded(
                    child: Container()
                  ),
                  buttonsOnBottom,
                ],
              ),
            ),
          ],
        ),
      );
    }
    else{
      //clipping so "hero" doesn't show up in the other page
      return ClipRRect(
        child: ListView(
          children: <Widget>[
            Container(
              height: spaceToRedistribute,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: MakeFunctionAdjustment(
                      topColor: buttonsColor,
                      heroUp: heroUp,
                      heroAnimDuration: heroAnimDuration,
                      heroAnimTravel: heroAnimTravel,
                      excercise: excercise,
                    ),
                  ),
                  recordSetFields,
                  buttonsOnBottom,
                ],
              ),
            ),
          ],
        ),
      );
    }

    
  }
}

class SetRecordButtonsWithWhiteContext extends StatelessWidget {
  const SetRecordButtonsWithWhiteContext({
    Key key,
    @required this.buttonsColor,
    @required this.excercise,
    @required this.timerNotStarted,
    @required this.backAction,
  }) : super(key: key);

  final Color buttonsColor;
  final AnExcercise excercise;
  final bool timerNotStarted;
  final Function backAction;

  @override
  Widget build(BuildContext context) {
    return BottomButtons(
      color: buttonsColor,
      excercise: excercise,
      forwardAction: (){
        maybeError(
          context, 
          excercise,
        );
      },
      forwardActionWidget: Text(
        timerNotStarted ? "Take Set Break" : "Return To Break",
      ),
      backAction: backAction,
    );
  }
}