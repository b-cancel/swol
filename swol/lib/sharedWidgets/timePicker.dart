import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

const List<int> secondOptions = [
   0, 5, 10, 15, 20, 25,
   30, 35, 40, 45, 50, 55
];

//NOTE: the max time we really care for is 5 minutes
//but adding a 5 to the minutes means we get really close to 6
//so we simply remove the 5 and let those that take long breaks just get close
//which consequently simplifies our UI
const Times = '''
[
    [0, 1, 2, 3, 4],
    [
      0, 5, 10, 15, 20, 25,
      30, 35, 40, 45, 50, 55
    ]
]
''';

class TimePicker extends StatefulWidget {
  TimePicker({
    @required this.duration,
    this.darkTheme: true,
    this.numberSize: 48,
    this.height: 100,
    this.colenSize: 16,
    this.colenSpacing: 16,
  });

  final ValueNotifier<Duration> duration;
  final bool darkTheme;
  final double numberSize;
  final double height;
  final double colenSize;
  final double colenSpacing;

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  List<int> separateMinutesAndSeconds(Duration duration){
    int minutes = duration.inMinutes;
    duration = duration - Duration(minutes: minutes);
    int seconds = duration.inSeconds;
    return [minutes,seconds];
  }

  @override
  Widget build(BuildContext context) {
    //var prep
    List<int> minutesSeconds = separateMinutesAndSeconds(widget.duration.value);

    //delimeter color
    Color delimeterColor = (widget.darkTheme) ? Colors.white : Colors.black;
    Color textColor = (widget.darkTheme) ? Theme.of(context).primaryTextTheme.title.color : Colors.black;

    print("selected " +  secondOptions.indexOf(minutesSeconds[1]).toString());

    //build
    return Picker(
      hideHeader: true,
      looping: true, //not that many options
      backgroundColor: Colors.transparent,
      containerColor: Colors.transparent,
      delimiter: [
        PickerDelimiter(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.colenSpacing,
              ),
              height: widget.numberSize,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: widget.colenSize,
                    height: widget.colenSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: delimeterColor,
                    ),
                  ),
                  Container(
                    width: widget.colenSize,
                    height: widget.colenSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: delimeterColor,
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
      ],
      height: widget.height,
      selecteds: [minutesSeconds[0], secondOptions.indexOf(minutesSeconds[1])],
      onSelect: (Picker picker, int index, List<int> ints){
        //grab minutes and seconds
        List selections = picker.getSelectedValues();
        int newMinutes = int.parse(selections[0]);
        int newSeconds = int.parse(selections[1]);

        //seconds affects minutes
        minutesSeconds = separateMinutesAndSeconds(widget.duration.value);
        int oldMinutes = minutesSeconds[0];
        int oldSeconds = minutesSeconds[1];

        bool minutesAdjustedBySeconds = false;

        /*
        TODO: everything below would work if the picker would reload
        //minutes DOWN ?
        if(oldSeconds == 0 && newSeconds == 55){ 
          newMinutes = (newMinutes == 0) ? 0 : newMinutes-1;
          minutesAdjustedBySeconds = true;
        }

        //minutes UP ?
        if(oldSeconds == 55 && newSeconds == 0){ 
          newMinutes = (newMinutes == 4) ? 4 : newMinutes+1;
          minutesAdjustedBySeconds = true;
        }
        */

        print(newMinutes.toString() + " : " + newSeconds.toString());

        //update duration
        widget.duration.value = Duration(
          minutes: newMinutes, 
          seconds: newSeconds,
        );

        if(minutesAdjustedBySeconds){
          print("TRUE");
          if(mounted){
            setState((){});
          }
        }
      },
      adapter: PickerDataAdapter<String>(
        pickerdata: new JsonDecoder().convert(Times),
        isArray: true,
      ),
      textStyle: TextStyle(
        color: textColor,
      ),
      selectedTextStyle: TextStyle(
        color: textColor,
        fontSize: widget.numberSize,
      ),
      itemExtent: widget.numberSize,
    ).makePicker();
  }
}

class MinsSecsBelowTimePicker extends StatelessWidget {
  const MinsSecsBelowTimePicker({
    Key key,
    @required this.showS,
    this.darkTheme: true,
  }) : super(key: key);

  final bool showS;
  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: (darkTheme) ? Colors.white : Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  "MINUTE"
                  + ((showS) ? "S" : " "),
                ),
              ),
            ),
          ),
          Container(
            //spacing of columns + width of dots
            width: (16 * 2) + 16.0,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text("SECONDS"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}