//dart
import 'dart:convert';

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_picker/flutter_picker.dart';
import 'package:swol/shared/methods/vibrate.dart';

//you only need to get so precise
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

//widget
class RecoveryTimePicker extends StatefulWidget {
  RecoveryTimePicker({
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
  _RecoveryTimePickerState createState() => _RecoveryTimePickerState();
}

class _RecoveryTimePickerState extends State<RecoveryTimePicker> {
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
    //TODO: fix this if problem
    //Color textColor = (widget.darkTheme) ? Theme.of(context).primaryTextTheme.headline6.color : Colors.black;
    Color textColor = (widget.darkTheme) ? Colors.white : Colors.black;

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
        //haptics
        Vibrator.vibrateOnce(
          duration: Duration(milliseconds: 250),
        );

        //grab minutes and seconds
        List selections = picker.getSelectedValues();
        int newMinutes = int.parse(selections[0]);
        int newSeconds = int.parse(selections[1]);

        //seconds affects minutes
        minutesSeconds = separateMinutesAndSeconds(widget.duration.value);

        //update duration
        widget.duration.value = Duration(
          minutes: newMinutes, 
          seconds: newSeconds,
        );
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