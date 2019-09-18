import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

const List<int> secondOptions = [
   0, 5, 10, 15, 20, 25,
   30, 35, 40, 45, 50, 55
];

const Times = '''
[
    [0, 1, 2, 3, 4, 5],
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
  });

  final ValueNotifier<Duration> duration;
  final bool darkTheme;
  
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
      looping: false, //not that many options
      backgroundColor: Colors.transparent,
      containerColor: Colors.transparent,
      delimiter: [
        PickerDelimiter(
          child: Center(
            child: Container(
              height: 80,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: delimeterColor,
                    ),
                  ),
                  Container(
                    width: 16,
                    height: 16,
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
      height: 100,
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
      columnPadding: EdgeInsets.symmetric(
        horizontal:24,
      ),
      //---still being messed
      textStyle: TextStyle(
        color: textColor,
      ),
      selectedTextStyle: TextStyle(
        color: textColor,
        fontSize: 48,
      ),
      //textScaleFactor: 2,
      itemExtent: 48,
    ).makePicker();
  }
}