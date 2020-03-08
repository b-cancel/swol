//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_icons/flutter_icons.dart';
import 'package:bot_toast/bot_toast.dart';

//internall
import 'package:swol/action/tabs/recovery/timer/onlyEditButton.dart';
import 'package:swol/action/tabs/recovery/secondary/triangle.dart';
import 'package:swol/shared/widgets/simple/ourToolTip.dart';

//showing time in a semi nice format for both timer and stopwatch widgets
class TimeDisplay extends StatelessWidget {
  const TimeDisplay({
    Key key,
    @required this.textContainerSize,
    @required this.topNumber,
    this.topArrowUp,
    @required this.breakTime,
    @required this.timePassed,
    this.showBottomArrow: false,
    @required this.isTimer,
    this.showIcon: false,
    @required this.changeTimeWidget,
  }) : super(key: key);

  final double textContainerSize;
  final String topNumber;
  final bool topArrowUp;
  final String breakTime;
  final Duration timePassed;
  final bool showBottomArrow;
  final bool isTimer;
  final bool showIcon;
  final Widget changeTimeWidget;

  @override
  Widget build(BuildContext context) {
    //based on all the calculated variables above show the various numbers
    List<String> passedStrings = durationToCustomDisplay(timePassed);
    String passedString = passedStrings[0] +" : " +passedStrings[1]; 
    
    //calculate triangle bits
    Widget topTriangle = (topArrowUp == null) ? Container()
    : Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: topArrowUp ? TriangleUp() : TriangleDown(),
      ),
    );

    //reurn
    return Transform.translate(
      //need because the icon throws off the balance of the design
      offset: Offset(0, 0), //-((48.0 + 16.0) / 3)),
      child: Container(
        padding: EdgeInsets.all(24),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Visibility(
                visible: showIcon,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: (isTimer) ? 0 : 16,
                  ),
                  child: Icon(
                    isTimer ? Ionicons.getIconData("ios-timer") : Ionicons.getIconData("ios-stopwatch"),
                    color: Theme.of(context).primaryColor,
                    size: 48,
                  ),
                ),
              ),
              IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: topArrowUp == true ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      visible: topArrowUp == true,
                      child: topTriangle,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(24),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => showToolTip(
                            context,
                            topArrowUp ? "Extra Time Waited" : "Time Left To Wait",
                            direction: PreferDirection.topCenter,
                            showIcon: false,
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              topNumber,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: topArrowUp == false,
                      child: topTriangle,
                    ),
                  ],
                ),
              ),
              Container(
                height: 16,
              ),
              Container(
                width: textContainerSize,
                padding: EdgeInsets.symmetric(
                  horizontal: (textContainerSize / 2) / 2,
                ),
                //NOTE: we want the text here to be HALF the size
                //of the text above it
                child: Container(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            child: Stack(
                              children: <Widget>[
                                EditIcon(
                                  text: breakTime,
                                ),
                                changeTimeWidget,
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => showToolTip(
                                  context,
                                  "Total Time Waited",
                                  direction: PreferDirection.bottomCenter,
                                  showIcon: false,
                                ),
                                child: EditIcon(
                                  invisible: true,
                                  showArrow: showBottomArrow,
                                  text: passedString,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditIcon extends StatelessWidget {
  const EditIcon({
    this.invisible: false,
    this.showArrow: false,
    this.roundedRight: false,
    @required this.text,
    Key key,
  }) : super(key: key);

  final bool invisible;
  final bool showArrow;
  final bool roundedRight;
  final String text;

  @override
  Widget build(BuildContext context) {
    Color borderColor = invisible ? Colors.transparent : Theme.of(context).primaryColor;
    BorderSide borderSide = BorderSide(
      color: borderColor,
      width: 2,
    );

    //build
    return Container(
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          borderSide,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(roundedRight ? 8 : 0),
          topRight: Radius.circular(roundedRight ? 8 : 0),
        )
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            showArrow == false ? Container() 
            : Container(
              height: 6,
              child: TriangleUp(
                //anything larger than 12 makes no difference
                widthDivisor: 12, 
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: 2,
                    right: 2,
                    top: 2,
                    bottom: (showArrow) ? 0 : 2,
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                (invisible) ? Container() : Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border(
                      left: borderSide,
                    )
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 18,
                    color: borderColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}