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
    double borderSize = 3;

    //build
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          RecordField(
            isLeft: true,
            text: "256",
            borderSize: borderSize,
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
          RecordField(
            isLeft: false,
            text: "8",
            borderSize: borderSize,
          ),
        ],
      ),
    );
  }
}

class RecordField extends StatelessWidget {
  RecordField({
    @required this.isLeft,
    @required this.text,
    @required this.borderSize,
  });

  final bool isLeft;
  final String text;
  final double borderSize;

  @override
  Widget build(BuildContext context) {
    Radius normalCurve = Radius.circular(24);

    return Expanded(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  //set 
                  topRight: isLeft ? Radius.zero : normalCurve,
                  bottomLeft: isLeft ? normalCurve : Radius.zero,
                  //not so set
                  topLeft: isLeft ? normalCurve : Radius.zero,
                  bottomRight: isLeft ? Radius.zero : normalCurve,
                ),
                border: Border.all(
                  color: isLeft ? Theme.of(context).accentColor : Theme.of(context).primaryColorLight, 
                  width: borderSize,
                ),
              ),
              padding: EdgeInsets.all(16),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(text),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                top: isLeft ? borderSize : borderSize * 3 + 8,
                bottom: isLeft ? borderSize * 3 + 8 : borderSize,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: isLeft ? BorderSide(
                            color: Theme.of(context).cardColor, 
                            width: borderSize,
                          ) : BorderSide(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: isLeft == false ? BorderSide(
                            color: Theme.of(context).cardColor, 
                            width: borderSize,
                          ) : BorderSide(),
                        )
                      ),
                    )
                  ),
                ],
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
            border: Border.all(
              color: isLeft ? Theme.of(context).accentColor : Theme.of(context).primaryColorLight, 
              width: borderSize,
            ),
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
                    left: isLeft ? 0 : 4,
                    right: isLeft ? 4 : 0,
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