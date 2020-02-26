//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shimmer/shimmer.dart';

//internal: action
import 'package:swol/action/tabs/record/field/advancedField.dart';
import 'package:swol/action/tabs/record/body/calibration.dart';
import 'package:swol/action/tabs/record/body/adjustment.dart';
import 'package:swol/action/shared/cardWithHeader.dart';
import 'package:swol/action/bottomButtons/button.dart';
import 'package:swol/action/popUps/error.dart';
import 'package:swol/action/page.dart';

//internal: shared
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/methods/theme.dart';

//widget
class SetRecord extends StatelessWidget {
  SetRecord({
    @required this.excercise,
    @required this.statusBarHeight,
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
    @required this.functionIDToWeightFromRT,
  });

  final AnExcercise excercise;
  final double statusBarHeight;
  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;
  final ValueNotifier<List<double>> functionIDToWeightFromRT;

  //build
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double appBarHeight = 56; //constant according to flutter docs
    double spaceToRedistribute = fullHeight - appBarHeight - statusBarHeight;

    //determine what page we are showing
    bool calibrationRequired = excercise.lastWeight == null;
    Function backAction;
    if (calibrationRequired == false) {
      backAction = () {
        ExcercisePage.pageNumber.value = 0;
      };
    }

    //calc sets passed for bottom buttons
    int setsPassed = excercise.tempSetCount ?? 0;
    bool timerNotStarted =
        excercise.tempStartTime.value == AnExcercise.nullDateTime;
    if (timerNotStarted) setsPassed += 1;

    //color for bottom buttons
    bool lastSetOrBefore = setsPassed <= excercise.setTarget;
    Color buttonsColor = lastSetOrBefore
        ? Theme.of(context).accentColor
        : Theme.of(context).cardColor;

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
        cardColor: Theme.of(context).cardColor,
        buttonsColor: buttonsColor,
        excercise: excercise,
        timerNotStarted: timerNotStarted,
        backAction: backAction,
      ),
    );

    Widget scrollingPage;
    if (calibrationRequired) {
      //clipping so "hero" doesn't show up in the other page
      scrollingPage = ListView(
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
                  child: Shimmer.fromColors(
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
                Expanded(child: Container()),
                buttonsOnBottom,
              ],
            ),
          ),
        ],
      );
    } else {
      //clipping so "hero" doesn't show up in the other page
      scrollingPage = ListView(
        children: <Widget>[
          Container(
            height: spaceToRedistribute,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: MakeFunctionAdjustment(
                    functionIDToWeightFromRT: functionIDToWeightFromRT,
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
      );
    }

    //add extra back just for looks (ClipRRect)
    return scrollingPage;
  }
}

class SetRecordButtonsWithWhiteContext extends StatelessWidget {
  const SetRecordButtonsWithWhiteContext({
    Key key,
    @required this.cardColor,
    @required this.buttonsColor,
    @required this.excercise,
    @required this.timerNotStarted,
    @required this.backAction,
  }) : super(key: key);

  final Color cardColor;
  final Color buttonsColor;
  final AnExcercise excercise;
  final bool timerNotStarted;
  final Function backAction;

  @override
  Widget build(BuildContext context) {
    //a couple of things for set break glance
    double topPadding = 24.0 + 40 + 24;

    //build
    return Stack(
      children: <Widget>[
        Container(
          height: 0,
          child: OverflowBox(
            minHeight: MediaQuery.of(context).size.height,
            maxHeight: MediaQuery.of(context).size.height,
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: topPadding,
              ),
              //NOTE: this is pretty much a place holder for the next page
              //a quick glance to once again persuade the user of continuity
              child: Container(
                  height: MediaQuery.of(context).size.height - topPadding,
                  width: MediaQuery.of(context).size.width,
                  color: cardColor,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                color: buttonsColor,
                              ),
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: (buttonsColor == Theme.of(context).accentColor)
                              ? 16
                              : 0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: TimerGlimpse(
                                excercise: excercise,
                              ),
                            ),
                          )
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
        BottomButtons(
          color: buttonsColor,
          excerciseID: excercise.id,
          forwardAction: () {
            maybeError(
              context,
              excercise,
              excercise.tempStartTime.value,
            );
          },
          forwardActionWidget: Text(
            timerNotStarted ? "Take Set Break" : "Return To Break",
          ),
          backAction: backAction,
        ),
      ],
    );
  }
}

//alert the user if neccesary
class TimerGlimpse extends StatefulWidget {
  const TimerGlimpse({
    @required this.excercise,
    Key key,
  }) : super(key: key);

  final AnExcercise excercise;

  @override
  _TimerGlimpseState createState() => _TimerGlimpseState();
}

class _TimerGlimpseState extends State<TimerGlimpse> {
  int subscribeID;

  @override
  void initState() {
    //super init
    super.initState();

    //add listener so we can give the user a proper glimpse
    subscribeID = KeyboardVisibilityNotification().addNewListener(
      onHide: (bool visible) {
        setState(() {});
      },
    );
  }

  @override
  void dispose() { 
    //remove listeners
    KeyboardVisibilityNotification().removeListener(subscribeID);

    //super dipose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //get glimpse color
    Color circleGlimpseColor;
    DateTime startTime = widget.excercise.tempStartTime.value;
    if(startTime == AnExcercise.nullDateTime){
      circleGlimpseColor = Color(0xFFBFBFBF); //same grey as timer
    }
    else{
      Duration timePassed = DateTime.now().difference(startTime);
      if(timePassed <= widget.excercise.recoveryPeriod){
        circleGlimpseColor = Theme.of(context).accentColor;
      }
      else circleGlimpseColor = Colors.red;
    }

    //build
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleGlimpseColor,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
    );
  }
}
