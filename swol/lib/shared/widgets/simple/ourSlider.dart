import 'package:flutter/material.dart';

//plugins
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:intl/intl.dart' as intl;

//internal
import 'package:swol/shared/methods/vibrate.dart';

//NOTE: in both cases things start from 1
class CustomSlider extends StatelessWidget {
  const CustomSlider({
    @required this.value,
    @required this.lastTick,
    Key key,
  }) : super(key: key);

  final ValueNotifier<int> value;
  final int lastTick;

  onChange(int handlerIndex, dynamic lowerValue, dynamic upperValue){
    double val = lowerValue;
    if(val.toInt() != value.value){
      Vibrator.vibrateOnce(
        duration: Duration(milliseconds: 150),
      );
      value.value = val.toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    //reusable tick widget
    double tickWidth = 3;
    double sidePadding = 34;

    Widget littleTick = Container(
      height: 8,
      width: tickWidth,
      color: Theme.of(context).backgroundColor,
    );

    Widget bigTick = Container(
      height: 16,
      width: tickWidth,
      color: Theme.of(context).backgroundColor,
    );

    Widget spacer = Expanded(
      child: Container(),
    );

    //build tick lines
    List<Widget> ticks = new List<Widget>();
    for(int i = 1; i <= lastTick; i++){
      if(i % 5 == 0) ticks.add(bigTick);
      else ticks.add(littleTick);

      if(i != lastTick){
        ticks.add(spacer);
      }
    }

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            bottom: 40,
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
            bottom: 14.75,
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
                    color: Theme.of(context).backgroundColor,
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
          child: FlutterSlider(
            step: 1,
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
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Icon(
                    Icons.repeat, 
                    size: 25,
                  ),
                ),
              ),
              foregroundDecoration: BoxDecoration()
            ),
            tooltip: FlutterSliderTooltip(
              alwaysShowTooltip: true,
              textStyle: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              boxStyle: FlutterSliderTooltipBox(
                decoration: BoxDecoration(
                  //color: Theme.of(context).backgroundColor,
                )
              ),
              numberFormat: intl.NumberFormat(),
            ),
            trackBar: FlutterSliderTrackBar(
              activeTrackBarHeight: 16,
              inactiveTrackBarHeight: 16,
              //NOTE: They need their own outline to cover up mid division of background
              inactiveTrackBar: BoxDecoration(
                color: Theme.of(context).backgroundColor,
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
      ],
    );
  }
}