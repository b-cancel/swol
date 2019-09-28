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

class TimePicker extends StatelessWidget {
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
  Widget build(BuildContext context) {
    //var prep
    Duration editedDuration =  duration.value;
    int minutes = editedDuration.inMinutes;
    editedDuration = editedDuration - Duration(minutes: minutes);
    int seconds = editedDuration.inSeconds;

    //delimeter color
    Color delimeterColor = (darkTheme) ? Colors.white : Colors.black;
    Color textColor = (darkTheme) ? Theme.of(context).primaryTextTheme.title.color : Colors.black;

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
                horizontal: colenSpacing,
              ),
              height: numberSize,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: colenSize,
                    height: colenSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: delimeterColor,
                    ),
                  ),
                  Container(
                    width: colenSize,
                    height: colenSize,
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
      height: height,
      selecteds: [minutes, secondOptions.indexOf(seconds)],
      onSelect: (Picker picker, int index, List<int> ints){
        List selections = picker.getSelectedValues();
        minutes = int.parse(selections[0]);
        seconds = int.parse(selections[1]);
        duration.value = Duration(
          minutes: minutes, 
          seconds: seconds,
        );
      },
      adapter: PickerDataAdapter<String>(
        pickerdata: new JsonDecoder().convert(Times),
        isArray: true,
      ),
      //---still being messed
      textStyle: TextStyle(
        color: textColor,
      ),
      selectedTextStyle: TextStyle(
        color: textColor,
        fontSize: numberSize,
      ),
      itemExtent: numberSize,
    ).makePicker();
  }
}