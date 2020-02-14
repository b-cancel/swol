//dart
import 'dart:ui';

//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swol/action/page.dart';
import 'package:swol/action/shared/setDisplay.dart';

//internal: action
import 'package:swol/action/tabs/sharedWidgets/cardWithHeader.dart';
import 'package:swol/action/tabs/sharedWidgets/bottomButtons.dart';
import 'package:swol/action/shared/changeFunction.dart';
import 'package:swol/action/tabs/record/advancedField.dart';

//internal: shared
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/methods/theme.dart';

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

  updateWeightNotifier(){
    ExcercisePage.setWeight.value = weightCtrl.text;
  }

  updateRepsNotifier(){
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
    WidgetsBinding.instance.addPostFrameCallback((_){
      //NOTE: if you don't wait until transition things begin to break
      Future.delayed(widget.heroAnimDuration, (){
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
  focusOnFirstInvalid(){
    //grab weight stuff
    bool weightEmpty = weightCtrl.text == "";
    bool weightZero = weightCtrl.text == "0";
    bool weightInvalid = weightEmpty || weightZero;

    //maybe focus on weight
    if(weightInvalid){
      weightCtrl.clear(); //since invalid maybe 0
      FocusScope.of(context).requestFocus(weightFN);
    }
    else{
      //grab reps stuff
      bool repsEmtpy = repsCtrl.text == "";
      bool repsZero = repsCtrl.text == "0";
      bool repsInvalid = repsEmtpy || repsZero;

      //maybe focus on reps
      if(repsInvalid){
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
    double spaceToRedistribute = fullHeight - appBarHeight - widget.statusBarHeight;

    //color for "suggestion"
    //TODO: because we are wrapped in a white so the pop up works well
    //TODO: this distance color will be white even though it should be the dark card color
    //TODO: fix that... maybe... clean white is kinda cool to
    Color distanceColor = Theme.of(context).cardColor;
    int id = 0;
    if (id == 1)
      distanceColor = Colors.red.withOpacity(0.33);
    else if (id == 2)
      distanceColor = Colors.red.withOpacity(0.66);
    else if (id == 3) distanceColor = Colors.red;

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
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
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24),
                                  ),
                                ),
                                child: SetDisplay(
                                  useAccent: false,
                                  title: "Goal Set",
                                  lastWeight: 124,
                                  lastReps: 23,
                                  heroUp: widget.heroUp,
                                  heroAnimDuration: widget.heroAnimDuration,
                                  heroAnimTravel: widget.heroAnimTravel,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                          excercise: widget.excercise,
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
                            child: RecordFields(
                              weightController: weightCtrl,
                              weightFocusNode: weightFN,
                              repsController: repsCtrl,
                              repsFocusNode: repsFN,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Theme(
                    data: MyTheme.light,
                    child: WhiteBottomButtonsWrapper(
                      excercise: widget.excercise,
                      backToSuggestion: (){
                        ExcercisePage.pageNumber.value = 0;
                        //TODO... anything else here?
                      }
                    ),
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

//TODO: fix white wrapping so the little ugly drak blue corner doesn't show
class WhiteBottomButtonsWrapper extends StatelessWidget {
  const WhiteBottomButtonsWrapper({
    Key key,
    @required this.excercise,
    @required this.backToSuggestion,
  }) : super(key: key);

  final AnExcercise excercise;
  final Function backToSuggestion;

  @override
  Widget build(BuildContext context) {
    return BottomButtons(
      excercise: excercise,
      forwardAction: (){
        //TODO: trigger error maybe if stuff isnt valid
        ExcercisePage.pageNumber.value = 2;
      },
      forwardActionWidget: Text(
        "Take Set Break",
      ),
      backAction: backToSuggestion,
    );
  }
}