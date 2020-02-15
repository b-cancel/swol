//flutter
import 'package:flutter/material.dart';
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
        //TODO... anything else here?
      };
    }

    //calc sets passed for bottom buttons
    int setsPassed = excercise.tempSetCount.value;
    bool timerNotStarted = excercise.tempStartTime.value == AnExcercise.nullDateTime;
    if(timerNotStarted) setsPassed += 1;

    //color for bottom buttons
    bool lastSetOrBefore = setsPassed <= excercise.setTarget.value;
    Color buttonsColor =  lastSetOrBefore ? Theme.of(context).accentColor : Theme.of(context).cardColor;

    //clipping so "hero" doesn't show up in the other page
    return ClipRRect(
      child: ListView(
        children: <Widget>[
          Container(
            height: spaceToRedistribute,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Conditional(
                  condition: calibrationRequired,
                  ifTrue: Padding(
                    padding: EdgeInsets.only(
                      bottom: 48,
                    ),
                    child: CalibrationCard(),
                  ),
                  ifFalse: Expanded(
                    child: MakeFunctionAdjustment(
                      heroUp: heroUp,
                      heroAnimDuration: heroAnimDuration,
                      heroAnimTravel: heroAnimTravel,
                      excercise: excercise,
                    ),
                  ),
                ),
                CardWithHeader(
                  header: "Record Set",
                  aLittleSmaller: true,
                  child: RecordFields(
                    heroAnimDuration: heroAnimDuration,
                  ),
                ),
                Visibility(
                  visible: calibrationRequired,
                  child: Expanded(
                    child: Container()
                  ),
                ),
                Theme(
                  data: MyTheme.light,
                  child: BottomButtonsWrappedInWhite(
                    buttonsColor: buttonsColor, 
                    excercise: excercise, 
                    timerNotStarted: timerNotStarted, 
                    backAction: backAction,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomButtonsWrappedInWhite extends StatelessWidget {
  const BottomButtonsWrappedInWhite({
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
        timerNotStarted ? "Take Set Break" : "Return To Timer",
      ),
      backAction: backAction,
    );
  }
}