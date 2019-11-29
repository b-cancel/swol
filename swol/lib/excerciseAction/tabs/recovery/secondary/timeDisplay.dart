//flutter
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:swol/excerciseAction/tabs/recovery/secondary/triangle.dart';

//utility (max is 9:59 but we indicate we are maxed out with 9:99)
List<String> durationToCustomDisplay(Duration duration){
  String only1stDigit = "0";
  String always2Digits = "00";

  if(duration > Duration.zero){
    //seperate minutes
    int minutes = duration.inMinutes;

    //9 minutes or less have passed (still displayable)
    if(minutes <= 9){
      only1stDigit = minutes.toString(); //9 through 0

      //remove minutes so only seconds left
      duration = duration - Duration(minutes: minutes);

      //seperate seconds
      int seconds = duration.inSeconds;
      always2Digits = seconds.toString(); //0 through 59

      //anything less than 10
      if(always2Digits.length < 2){ //0 -> 9
        always2Digits = "0" + always2Digits;
      }
      //ELSE: 10 -> 59
    }
    else{
      only1stDigit = "9";
      always2Digits = "99";
    }
  }

  return [only1stDigit, always2Digits];
}

//showing time in a semi nice format for both timer and stopwatch widgets
class TimeDisplay extends StatelessWidget {
  const TimeDisplay({
    Key key,
    @required this.textContainerSize,
    @required this.topNumber,
    this.topArrowUp,
    @required this.bottomLeftNumber,
    @required this.bottomRightNumber,
    this.showBottomArrow: false,
    @required this.isTimer,
    this.showIcon: false,
  }) : super(key: key);

  final double textContainerSize;
  final String topNumber;
  final bool topArrowUp;
  final String bottomLeftNumber;
  final String bottomRightNumber;
  final bool showBottomArrow;
  final bool isTimer;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    Widget topTriangle = (topArrowUp == null) ? Container()
    : Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: topArrowUp ? TriangleUp() : TriangleDown(),
      ),
    );

    return Transform.translate(
      //need because the icon throws off the balance of the design
      offset: Offset(0, -((48.0 + 16.0) / 3)),
      child: Container(
        padding: EdgeInsets.all(24),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Opacity(
                opacity: showIcon ? 1.0 : 0.0,
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
                    (topArrowUp == true) ? topTriangle : EmptyContainer(),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        topNumber,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    (topArrowUp == false) ? Padding(
                      padding: EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: topTriangle,
                    ) : EmptyContainer(),
                  ],
                ),
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
                          EditIcon(
                            text: bottomLeftNumber,
                          ),
                          EditIcon(
                            invisible: true,
                            showArrow: showBottomArrow,
                            text: bottomRightNumber,
                          )
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

class EmptyContainer extends StatelessWidget {
  const EmptyContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0,
      width: 0,
      child: Container(),
    );
  }
}

class EditIcon extends StatelessWidget {
  const EditIcon({
    this.invisible: false,
    this.showArrow: false,
    @required this.text,
    Key key,
  }) : super(key: key);

  final bool invisible;
  final bool showArrow;
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
                  child: Text(text),
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