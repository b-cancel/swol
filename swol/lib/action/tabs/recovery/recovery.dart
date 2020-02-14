//flutter
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';

//internal: action
import 'package:swol/action/tabs/sharedWidgets/bottomButtons.dart';
import 'package:swol/action/tabs/recovery/secondary/breath.dart';
import 'package:swol/action/tabs/recovery/timer/liquidTime.dart';

//internal: shared
import 'package:swol/shared/structs/anExcercise.dart';

//widget
class Recovery extends StatefulWidget {
  Recovery({
    @required this.excercise,
  });

  final AnExcercise excercise;

  @override
  _RecoveryState createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery>
    with SingleTickerProviderStateMixin {
  ValueNotifier<Duration> recoveryDuration;
  ValueNotifier<bool> areYouSurePopUp;

  //function that is removable from listener
  updateRecoveryDuration() {
    widget.excercise.recoveryPeriod = recoveryDuration.value;
  }

  //init
  @override
  void initState() {
    //start the timer or allow it to continue
    if (widget.excercise.tempStartTime.value == AnExcercise.nullDateTime) {
      widget.excercise.tempStartTime =
          new ValueNotifier<DateTime>(DateTime.now());
    }

    //setup things to make recovery duration changeable
    recoveryDuration = new ValueNotifier(widget.excercise.recoveryPeriod);
    recoveryDuration.addListener(updateRecoveryDuration);
    areYouSurePopUp = new ValueNotifier<bool>(false);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    //remove listeners
    recoveryDuration.removeListener(updateRecoveryDuration);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Radius cardRadius = Radius.circular(24);

    //build
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        //everything including bottom button and spacing
        children: <Widget>[
          Stack(
            children: [
              Positioned.fill(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(cardRadius),
                  ),
                  child: Timer(
                    excercise: widget.excercise,
                    changeableTimerDuration: recoveryDuration,
                    areYouSurePopUp: areYouSurePopUp,
                    showIcon: false,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                //24 to clear button
                //extra 24 to clear curve
                bottom: 24.0, // + 24,
              ),
              child: Container(
                //color: Colors.blue,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: ToBreath(),
                  ),
                ),
              ),
            ),
          ),
          BottomButtons(
            excercise: widget.excercise,
            forwardAction: () {
              //TODO: react to "areYouSurePopUp"

              //move onto the next set
              ExcercisePage.pageNumber.value = 0;

              //zero out the tempStartTimer
              widget.excercise.tempStartTime =
                  new ValueNotifier<DateTime>(AnExcercise.nullDateTime);
            },
            forwardActionWidget: Text(
              "Next Set",
            ),
            backAction: (){
              ExcercisePage.pageNumber.value = 1;
            },
          )
        ],
      ),
    );
  }
}

class PreviousCardCorners extends StatelessWidget {
  const PreviousCardCorners({
    Key key,
    @required this.child,
    @required this.cardRadius,
  }) : super(key: key);

  final Widget child;
  final Radius cardRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 16,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).accentColor,
        ),
        Stack(
          children: <Widget>[
            child,
            //-------------------------Top Left-------------------------
            Positioned(
              top: 0,
              left: 0,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: cardRadius,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: cardRadius,
                        bottomRight: cardRadius,
                      ),
                    ),
                    height: 25,
                    width: 25,
                  ),
                ],
              ),
            ),
            //-------------------------Top Right-------------------------
            Positioned(
              top: 0,
              right: 0,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    //NOTE: in order for smooth blend
                    //notice the difference alos between 24 and 25 size
                    right: 0,
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: cardRadius,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topRight: cardRadius,
                        bottomLeft: cardRadius,
                      ),
                    ),
                    height: 25,
                    width: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}