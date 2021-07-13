import 'package:flutter/material.dart';

//plugins
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:swol/shared/methods/theme.dart';

//internal
import 'package:swol/shared/methods/vibrate.dart';

//NOTE: in both cases things start from 1
class CustomSlider extends StatelessWidget {
  const CustomSlider({
    required this.value,
    required this.lastTick,
    this.isDark: true,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<int> value;
  final int lastTick;
  final bool isDark;

  onChange(int handlerIndex, dynamic lowerValue, dynamic upperValue) {
    double val = lowerValue;
    if (val.toInt() != value.value) {
      Vibrator.vibrateOnce(
        duration: Duration(milliseconds: 150),
      );
      value.value = val.toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color tickColor = MyTheme.dark.backgroundColor;

    //reusable tick widget
    double tickWidth = 3;
    double sidePadding = 34;

    Widget littleTick = Container(
      height: 8,
      width: tickWidth,
      color: tickColor,
    );

    Widget bigTick = Container(
      height: 16,
      width: tickWidth,
      color: tickColor,
    );

    Widget spacer = Expanded(
      child: Container(),
    );

    //build tick lines
    List<Widget> ticks = [];
    for (int i = 1; i <= lastTick; i++) {
      if (i % 5 == 0)
        ticks.add(bigTick);
      else
        ticks.add(littleTick);

      if (i != lastTick) {
        ticks.add(spacer);
      }
    }

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            bottom: 40 + 14,
            left: sidePadding,
            right: sidePadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: ticks,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 15 + 12,
            left: 16,
            right: 16,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 16,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: tickColor,
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 16,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: sidePadding / 2,
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.5,
            ),
            child: FlutterSlider(
              //TODO confirm this is correct
              step: FlutterSliderStep(
                step: 1,
                isPercentRange: false,
              ),
              jump: true,
              values: [value.value.toDouble()],
              min: 1,
              max: lastTick.toDouble(),
              handlerWidth: 35,
              handlerHeight: 35,
              touchSize: 50,
              handlerAnimation: FlutterSliderHandlerAnimation(
                scale: 1.25,
              ),
              handler: FlutterSliderHandler(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.black),
                    color: isDark
                        ? Theme.of(context).accentColor
                        : MyTheme.dark.scaffoldBackgroundColor,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.repeat,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                foregroundDecoration: BoxDecoration(),
              ),
              tooltip: FlutterSliderTooltip(
                //TODO: it was true
                alwaysShowTooltip: true,
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                boxStyle: FlutterSliderTooltipBox(
                  transform: Matrix4.translationValues(0, -16, 0),
                  decoration: BoxDecoration(
                      //color: Theme.of(context).backgroundColor,
                      ),
                ),
                //TODO: confirm we don't need the line below
                //numberFormat: intl.NumberFormat(),
                format: (String str) {
                  return double.parse(str).toInt().toString();
                },
              ),
              trackBar: FlutterSliderTrackBar(
                activeTrackBarHeight: 16,
                inactiveTrackBarHeight: 16,
                //NOTE: They need their own outline to cover up mid division of background
                inactiveTrackBar: BoxDecoration(
                  color: tickColor,
                  border: Border(
                    top: BorderSide(width: 2, color: Colors.black),
                    bottom: BorderSide(width: 2, color: Colors.black),
                  ),
                ),
                activeTrackBar: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  border: Border(
                    top: BorderSide(width: 2, color: Colors.black),
                    bottom: BorderSide(width: 2, color: Colors.black),
                  ),
                ),
              ),
              //NOTE: hatch marks don't work unfortunately
              onDragging: (handlerIndex, lowerValue, upperValue) {
                onChange(handlerIndex, lowerValue, upperValue);
              },
              //NOTE: primarily so tapping activates the changes
              //tapping the area runs onDragStarted and onDragCompleted
              //but we only really need one
              //and its a nice bonus that
              //when ur dragging and you finish dragging
              //you are made aware with a little vibration
              onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                onChange(handlerIndex, lowerValue, upperValue);
              },
            ),
          ),
        ),
      ],
    );
  }
}
