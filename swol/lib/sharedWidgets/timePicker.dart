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

class MinsSecsBelowTimePicker extends StatelessWidget {
  const MinsSecsBelowTimePicker({
    Key key,
    @required this.showS,
  }) : super(key: key);

  final bool showS;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontWeight: FontWeight.bold
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
                  + ((showS) ? "S" : ""),
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

class AnimatedRecoveryTimeInfo extends StatelessWidget {
  AnimatedRecoveryTimeInfo({
    Key key,
    @required this.changeDuration,
    @required this.sectionGrown,
    @required this.grownWidth,
    @required this.regularWidth,
    @required this.textHeight,
    @required this.textMaxWidth,
    @required this.selectedDuration,
    @required this.passedNameStrings,
    @required this.passedNameTaps,
    @required this.passedTickTypes,
    @required this.passedStartTick,
  }) : super(key: key);

  final Duration changeDuration;
  final int sectionGrown;
  final double grownWidth;
  final double regularWidth;
  final double textHeight;
  final double textMaxWidth;
  final ValueNotifier<Duration> selectedDuration;
  final List<String> passedNameStrings;
  final List<Function> passedNameTaps;
  final List<List<int>> passedTickTypes;
  final List<int> passedStartTick;

  @override
  Widget build(BuildContext context) {
    //quick maths
    double sub = -(textMaxWidth * 2);
    double sizeWhenGrown = grownWidth + sub;
    double sizeWhenShrunk = regularWidth + sub;
    if(sizeWhenShrunk.isNegative){
      sizeWhenShrunk = 0;
    }

    //create
    List<Widget> nameSections = new List<Widget>();
    List<Widget> tickSections = new List<Widget>();
    List<Widget> endSections = new List<Widget>();
    for(int i = 0; i < passedNameStrings.length; i++){
      //grab single data
      String name = passedNameStrings[i];
      Function onTapName = passedNameTaps[i];
      List<int> tickTypes =  passedTickTypes[i];
      int startTick = passedStartTick[i];

      //add name section
      nameSections.add(
        ANameSection(
          changeDuration: changeDuration, 
          grownWidth: grownWidth, 
          regularWidth: regularWidth,
          sectionGrown: sectionGrown,
          //-----
          sectionNumber: i, 
          sectionName: name,
          sectionTap: onTapName, 
        ),
      );

      //add tick section
      tickSections.add(
        AnimatedContainer(
          duration: changeDuration,
          height: 16,
          width: (sectionGrown == i) ? grownWidth : 0,
          child: (sectionGrown == i) ? TickGenerator(
            tickTypes: tickTypes,
            startTick: startTick,
            selectedDuration: selectedDuration,
          ) : Container(),
        ),
      );

      /*
      AnimatedContainer(
                    duration: changeDuration,
                    height: textHeight,                 
                    width: (sectionGrown == 0) ? textMaxWidth : 0,
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        "0s",
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: changeDuration,
                    constraints: BoxConstraints(
                      maxWidth: (sectionGrown == 0) ? sizeWhenGrown : sizeWhenShrunk,
                    ),
                  ),
                  AnimatedContainer(
                    duration: changeDuration,
                    height: textHeight,
                    width: (sectionGrown == 0 || sectionGrown == 1) ? textMaxWidth : 0,
                    alignment: (sectionGrown == 0) ? Alignment.centerRight : Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Center(
                        child: Text("3"
                        + ((sectionGrown == 0) ? "0" : "5") 
                        + "s"),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: changeDuration,
                    constraints: BoxConstraints(
                      maxWidth: (sectionGrown == 1) ? sizeWhenGrown : sizeWhenShrunk,
                    ),
                  ),
                  AnimatedContainer(
                    duration: changeDuration,
                    height: textHeight,
                    width: (sectionGrown == 1 || sectionGrown == 2) ? textMaxWidth : 0,
                    alignment: (sectionGrown == 1) ? Alignment.centerRight : Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Center(
                        child: Text("9"
                        + ((sectionGrown == 1) ? "0" : "5") 
                        + "s"),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: changeDuration,
                    constraints: BoxConstraints(
                      maxWidth: (sectionGrown == 2) ? sizeWhenGrown : sizeWhenShrunk,
                    ),
                  ),
                  AnimatedContainer(
                    duration: changeDuration,                           
                    height: textHeight,
                    width: (sectionGrown == 2) ? textMaxWidth : 0,
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Center(
                        child: Text("4:55"),
                      ),
                    ),
                  ),
      */
    }

    //build
    return Container(
      color: Colors.green,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 24.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: nameSections,
            ),
          ),
          Row(
            children: tickSections,
          ),
          DefaultTextStyle(
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: 16,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: endSections,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ANameSection extends StatelessWidget {
  const ANameSection({
    Key key,
    @required this.changeDuration,
    @required this.sectionGrown,
    @required this.sectionNumber,
    @required this.grownWidth,
    @required this.regularWidth,
    @required this.sectionTap,
    @required this.sectionName,
  }) : super(key: key);

  final Duration changeDuration;
  final int sectionGrown;
  final int sectionNumber;
  final double grownWidth;
  final double regularWidth;
  final Function sectionTap;
  final String sectionName;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: changeDuration,
      width: (sectionGrown == sectionNumber) ? grownWidth : regularWidth,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: (sectionGrown == 0) ? 16 : 0,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: sectionTap,
            child: Center(
              child: Text(
                sectionName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: (sectionGrown == 0) ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TickGenerator extends StatefulWidget {
  TickGenerator({
    @required this.tickTypes,
    this.startTick,
    this.selectedDuration,
  });

  final List<int> tickTypes;
  final int startTick;
  final ValueNotifier<Duration> selectedDuration;

  @override
  _TickGeneratorState createState() => _TickGeneratorState();
}

class _TickGeneratorState extends State<TickGenerator> {
  @override
  void initState() {
    widget.selectedDuration.addListener((){
      setState(() {});
    });

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double tickWidth = 3;

    Widget spacer = Expanded(
      child: Container(),
    );

    int tempVal = widget.startTick;
    int selected = widget.selectedDuration.value.inSeconds;

    //generate ticks
    List<Widget> ticks = new List<Widget>();
    for(int i = 0; i < widget.tickTypes.length; i++){
      int littleOnesBeforeBigOnes = widget.tickTypes[i];
      for(int tick = 0; tick < littleOnesBeforeBigOnes; tick++){
        bool highlight = (tempVal == selected);

        //add small tick
        ticks.add(
          Container(
            width: 0,
            child: OverflowBox(
              minWidth: tickWidth,
              maxWidth: tickWidth,
              child: Container(
                height: 8,
                width: tickWidth,
                color: (highlight) 
                ? Theme.of(context).accentColor
                : Theme.of(context).backgroundColor,
              ),
            ),
          ),
        );
        ticks.add(spacer);
        
        //add 5 units each time
        tempVal += 5;
      }

      //see if we should add a big tick
      if(i != (widget.tickTypes.length - 1)){
        bool highlight = (tempVal == selected);

        //add big tick
        ticks.add(
          Container(
            width: 0,
            child: OverflowBox(
              minWidth: tickWidth,
              maxWidth: tickWidth,
              child: Container(
                height: 16,
                width: tickWidth,
                color: (highlight) 
                ? Theme.of(context).accentColor
                : Theme.of(context).backgroundColor,
              ),
            ),
          ),
        );
        ticks.add(spacer);

        //add 5 units each time
        tempVal += 5;
      }
    }

    //remove trailing spacer
    ticks.removeLast();

    //build
    return Row(
      children: ticks,
    );
  }
}