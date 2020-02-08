import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/excerciseAction/toolTips.dart';
import 'package:swol/shared/functions/goldenRatio.dart';

class RecordFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //-32 is for 16 pixels of padding from both sides
    double screenWidth = MediaQuery.of(context).size.width - 32;
    List<double> goldenBS = measurementToGoldenRatioBS(screenWidth);
    double iconSize = goldenBS[1];
    List<double> golden2BS = measurementToGoldenRatioBS(iconSize);
    iconSize = golden2BS[1];

    BorderSide noBorder = BorderSide(width: 0);
    double borderSize = 3;
    BorderSide accentBorder = BorderSide(width: borderSize, color: Theme.of(context).accentColor);
    BorderSide regularBorder = BorderSide(width: borderSize, color: Theme.of(context).primaryColorLight);

    //build
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.all(16),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text("345"),
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                TappableIcon(
                  iconSize: iconSize, 
                  borderSize: borderSize,
                  icon: Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                    ),
                    child: Icon(
                      FontAwesomeIcons.dumbbell,
                    ),
                  ),
                  isLeft: true,
                ),
                TappableIcon(
                  iconSize: iconSize, 
                  borderSize: borderSize,
                  icon: Icon(Icons.repeat),
                  isLeft: false,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.all(16),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text("26"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TappableIcon extends StatelessWidget {
  const TappableIcon({
    Key key,
    @required this.iconSize,
    @required this.borderSize,
    @required this.icon,
    @required this.isLeft,
  }) : super(key: key);

  final double iconSize;
  final double borderSize;
  final Widget icon;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    Radius tinyCurve = Radius.circular(12);
    Radius normalCurve = Radius.circular(24);
    Radius bigCurve = Radius.circular(48);

    return GestureDetector(
      onTap: (){
        if(isLeft) showWeightToolTip(context);
        else showRepsToolTip(context);
      },
      child: Container(
        padding: EdgeInsets.only(
          right: isLeft ?  8 : 0,
          left: isLeft ? 0 : 8,
          bottom: isLeft ? 4 : 0,
          top: isLeft ? 0 : 4,
        ),
        child: Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: isLeft ? tinyCurve : Radius.zero,
              bottomLeft: isLeft ? Radius.zero : tinyCurve,
            ),
            border: Border.all(color: Theme.of(context).accentColor, width: borderSize),
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(
                    borderSize * (isLeft ? -1 : 1), 
                  0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topRight: isLeft ? tinyCurve : Radius.zero,
                        bottomLeft: isLeft ? Radius.zero : tinyCurve,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: isLeft ? 2 : 0,
                    right: isLeft ? 0 : 2,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: icon,
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