import 'package:flutter/material.dart';

//internal
import 'package:swol/utils/vibrate.dart';

//plugins
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:intl/intl.dart' as intl;

//NOTE: in both cases things start from 1
class CustomSlider extends StatelessWidget {
  const CustomSlider({
    @required this.value,
    @required this.lastTick,
    this.hideTicks: false,
    Key key,
  }) : super(key: key);

  final ValueNotifier<int> value;
  final int lastTick;
  final bool hideTicks;

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
        (hideTicks) ?  Container()
        : Container(
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
            bottom: 14.75, //TODO: adjust for final product
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
                  //TODO: have the icon change depending on what excercise mode you are on
                  //NOTE: the above is a super minor improvement 
                  //and more of an unoticible flex / waste of time than anything
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
              double val = lowerValue;
              if(val.toInt() != value.value){
                Vibrator.vibrate(
                  duration: Duration(milliseconds: 150),
                );
                value.value = val.toInt();
              }
            },
          ),
        ),
      ],
    );
  }
}

class CustomSliderWarning extends StatelessWidget {
  const CustomSliderWarning({
    Key key,
    @required this.repTarget,
    this.alwaysHaveSpace: false,
  }) : super(key: key);

  final ValueNotifier<int> repTarget;
  final alwaysHaveSpace;

  final String lowEnd = "Your chances of injury are high"
  + "\nMake sure your form is flawless at all times";

  final String superHighEnd = "You may quickly overwork your tendons"
  + "\nMake sure your body is very conditioned";

  final String highEnd = "You may overwork your tendons"
  + "\nMake sure your body is conditioned";

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repTarget,
      builder: (context, child){
        String warning = "";
        if(repTarget.value <= 5){
          warning = lowEnd;
        }
        else if(repTarget.value >= 21){
          warning = superHighEnd;
        }
        else if(repTarget.value >= 13){
          warning = highEnd;
        }

        //output warning if necessary
        if(warning == "" && alwaysHaveSpace == false) return Container();
        else{
          return Opacity(
            opacity: (warning == "") ? 0 : 1,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      right: 8,
                    ),
                    child: Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Text(
                          (alwaysHaveSpace) ? superHighEnd : warning,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.transparent,
                          ),
                        ),
                        Text(
                          (warning == "") ? superHighEnd : warning,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}