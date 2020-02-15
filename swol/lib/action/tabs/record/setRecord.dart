//flutter
import 'package:flutter/material.dart';

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
                  BottomButtons(
                    excercise: excercise,
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