import 'package:flutter/material.dart';

/*
int sectionGrown;
    if(recoveryPeriod.value <= Duration(seconds: 30)) sectionGrown = 0;
    else if(recoveryPeriod.value <= Duration(seconds: 90)) sectionGrown = 1;
    else if(recoveryPeriod.value <= Duration(minutes: 5)) sectionGrown = 2;
    else sectionGrown = 3;
*/

/*
class AnimatedRecoveryTimeInfo extends StatelessWidget {
  AnimatedRecoveryTimeInfo({
    Key key,
    @required this.changeDuration,
    @required this.grownWidth,
    @required this.regularWidth,
    @required this.textHeight,
    @required this.textMaxWidth,
    @required this.selectedDuration,
    @required this.passedNameStrings,
    @required this.passedNameTaps,
    @required this.passedStartTick,
    @required this.passedEndTick,
  }) : super(key: key);

  final Duration changeDuration;
  final double grownWidth;
  final double regularWidth;
  final double textHeight;
  final double textMaxWidth;
  final ValueNotifier<Duration> selectedDuration;
  final List<String> passedNameStrings;
  final List<Function> passedNameTaps;
  final List<int> passedStartTick;
  final List<int> passedEndTick;

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
      int startTick = passedStartTick[i];
      int endTick = passedEndTick[i];

      //add name section
      nameSections.add(
        ANameSection(
          changeDuration: changeDuration, 
          grownWidth: grownWidth, 
          regularWidth: regularWidth,
          sectionGrown: sectionGrown,
          //-----
          sectionID: i, 
          sectionName: name,
        ),
      );

      //add tick section
      tickSections.add(
        AnimatedContainer(
          duration: changeDuration,
          height: 16,
          width: (sectionGrown == i) ? grownWidth : 0,
          child: (sectionGrown == i) ? TickGenerator(
            startTick: startTick,
            endTick: endTick,
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: passedNameTaps[sectionGrown],
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
      ),
    );
  }
}

class ANameSection extends StatelessWidget {
  const ANameSection({
    Key key,
    @required this.changeDuration,
    @required this.sectionGrown,
    @required this.sectionID,
    @required this.grownWidth,
    @required this.regularWidth,
    @required this.sectionName,
  }) : super(key: key);

  final Duration changeDuration;
  final int sectionGrown;
  final int sectionID;
  final double grownWidth;
  final double regularWidth;
  final String sectionName;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: changeDuration,
      width: (sectionGrown == sectionID) ? grownWidth : regularWidth,
      child: (sectionGrown == sectionID) ? Center(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                ),
                child: Icon(
                  Icons.info,
                  color: Theme.of(context).accentColor,
                ),
              ),
              Text(
                sectionName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )
      : Container(),
    );
  }
}

class TickGenerator extends StatefulWidget {
  TickGenerator({
    @required this.startTick,
    @required this.endTick,
    this.selectedDuration,
  });

  final int startTick;
  final int endTick;
  final ValueNotifier<Duration> selectedDuration;

  @override
  _TickGeneratorState createState() => _TickGeneratorState();
}

class _TickGeneratorState extends State<TickGenerator> {
  maybeSetState(){
    if(mounted){
      setState(() {});
    }
  }

  @override
  void initState() {
    widget.selectedDuration.addListener(maybeSetState);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.selectedDuration.removeListener(maybeSetState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double tickWidth = 3;

    Widget spacer = Expanded(
      child: Container(),
    );

    int selected = widget.selectedDuration.value.inSeconds;

    //generate ticks
    List<Widget> ticks = new List<Widget>();
    int tickCount = ((widget.endTick - widget.startTick) ~/ 5) + 1;
    for(int i = 0; i < tickCount; i++){
      int thisTick = widget.startTick + (i * 5);
      bool highlight = (thisTick == selected);
      bool bigTick = ((thisTick % 60) == 0);

      //add tick
      ticks.add(
        Container(
          width: 0,
          child: OverflowBox(
            minWidth: tickWidth,
            maxWidth: tickWidth,
            child: Container(
              height: (bigTick) ? 16 : 8,
              width: tickWidth,
              color: (highlight) 
              ? Theme.of(context).accentColor
              : Theme.of(context).backgroundColor,
            ),
          ),
        ),
      );

      //add trailing spacer
      ticks.add(spacer);
    }

    //remove trailing spacer
    ticks.removeLast();

    //build
    return Row(
      children: ticks,
    );
  }
}
*/