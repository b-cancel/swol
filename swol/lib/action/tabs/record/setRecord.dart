//dart
import 'dart:ui';

//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:swol/action/tabs/record/body/adjustment.dart';
import 'package:swol/action/tabs/record/body/calibration.dart';

//internal: action
import 'package:swol/action/tabs/record/field/advancedField.dart';
import 'package:swol/action/shared/cardWithHeader.dart';
import 'package:swol/action/bottomButtons/button.dart';
import 'package:swol/action/page.dart';
import 'package:swol/shared/functions/goldenRatio.dart';

//internal: shared
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';

//TODO: on set init AND on resume we focus on first (if there is anything to focus on obvi)
//TODO: this includes pop ups

//TODO: the set should also be shown the revert button
//TODO: make sure that we refocus on the problematic field

//widget
class SetRecord extends StatefulWidget {
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

  @override
  _SetRecordState createState() => _SetRecordState();
}

class _SetRecordState extends State<SetRecord> {
  final TextEditingController weightCtrl = new TextEditingController();
  final FocusNode weightFN = new FocusNode();

  final TextEditingController repsCtrl = new TextEditingController();
  final FocusNode repsFN = new FocusNode();

  updateWeightNotifier() {
    ExcercisePage.setWeight.value = weightCtrl.text;
  }

  updateRepsNotifier() {
    ExcercisePage.setReps.value = repsCtrl.text;
  }

  @override
  void initState() {
    //supe init
    super.initState();

    //NOTE: set the initial values of our controllers from notifiers
    weightCtrl.text = ExcercisePage.setWeight.value;
    repsCtrl.text = ExcercisePage.setReps.value;

    //add listeners
    weightCtrl.addListener(updateWeightNotifier);
    repsCtrl.addListener(updateRepsNotifier);

    //autofocus if possible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //NOTE: if you don't wait until transition things begin to break
      Future.delayed(widget.heroAnimDuration, () {
        focusOnFirstInvalid();
      });
    });

    //attach a listener so a change in it will cause a refocus
    //done from warning, error, and notes page
    ExcercisePage.causeRefocus.addListener(focusOnFirstInvalid);
  }

  @override
  void dispose() {
    //remove listeners
    ExcercisePage.causeRefocus.removeListener(focusOnFirstInvalid);

    //remove notifiers
    weightCtrl.removeListener(updateWeightNotifier);
    repsCtrl.removeListener(updateRepsNotifier);

    //super dispose
    super.dispose();
  }

  //if both are valid nothing happens
  //NOTE: in all cases where this is used the keyboard is guaranteed to be closed
  //and its closed automatically by unfocusing so there are no weird exceptions to cover
  focusOnFirstInvalid() {
    //grab weight stuff
    bool weightEmpty = weightCtrl.text == "";
    bool weightZero = weightCtrl.text == "0";
    bool weightInvalid = weightEmpty || weightZero;

    //maybe focus on weight
    if (weightInvalid) {
      weightCtrl.clear(); //since invalid maybe 0
      FocusScope.of(context).requestFocus(weightFN);
    } else {
      //grab reps stuff
      bool repsEmtpy = repsCtrl.text == "";
      bool repsZero = repsCtrl.text == "0";
      bool repsInvalid = repsEmtpy || repsZero;

      //maybe focus on reps
      if (repsInvalid) {
        repsCtrl.clear(); //since invalid maybe 0
        FocusScope.of(context).requestFocus(repsFN);
      }
    }

    //whatever cause the refocusing
    //no longer needs it
    ExcercisePage.causeRefocus.value = false;
  }

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double appBarHeight = 56; //constant according to flutter docs
    double spaceToRedistribute =
        fullHeight - appBarHeight - widget.statusBarHeight;

    //determine what page we are showing
    bool calibrationRequired = widget.excercise.lastWeight == null;
    Function backAction;
    if(calibrationRequired ==false){
      backAction = () {
        ExcercisePage.pageNumber.value = 0;
        //TODO... anything else here?
      };
    }

    //clipping so "hero" doesn't show up in the other page
    return ClipRRect(
      child: Theme(
        data: MyTheme.dark,
        //must be in listview so that the textfield can be scrolled into place
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
                        heroUp: widget.heroUp,
                        heroAnimDuration: widget.heroAnimDuration,
                        heroAnimTravel: widget.heroAnimTravel,
                        excercise: widget.excercise,
                      ),
                    ),
                  ),
                  CardWithHeader(
                    header: "Record Set",
                    aLittleSmaller: true,
                    child: RecordFields(
                      weightController: weightCtrl,
                      weightFocusNode: weightFN,
                      repsController: repsCtrl,
                      repsFocusNode: repsFN,
                    ),
                  ),
                  Visibility(
                    visible: calibrationRequired,
                    child: Expanded(
                      child: Container()
                    ),
                  ),
                  BottomButtons(
                    excercise: widget.excercise,
                    forwardAction: () {
                      //TODO: trigger error maybe if stuff isnt valid
                      ExcercisePage.pageNumber.value = 2;
                    },
                    forwardActionWidget: Text(
                      "Take Set Break",
                    ),
                    backAction: backAction,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
