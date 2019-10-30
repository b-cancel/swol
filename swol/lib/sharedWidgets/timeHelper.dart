import 'package:flutter/material.dart';

class SliderToolTipButton extends StatelessWidget {
  const SliderToolTipButton({
    @required this.buttonText,
    @required this.tooltipText,
    Key key,
  }) : super(key: key);

  final String buttonText;
  final String tooltipText;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipText,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        onPressed: (){
          print(tooltipText);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                right: 8.0,
              ),
              child: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(buttonText)
          ],
        ),
      ),
    );
  }
}

class Range{
  final String name;
  final Widget left;
  final Widget right;
  final Function onTap;
  final int startSeconds;
  final int endSeconds;

  Range({
    @required this.name,
    @required this.left,
    @required this.right,
    @required this.onTap,
    @required this.startSeconds,
    @required this.endSeconds,
  });
}

class AnimatedRecoveryTimeInfo extends StatefulWidget {
  AnimatedRecoveryTimeInfo({
    Key key,
    @required this.changeDuration,
    @required this.grownWidth,
    @required this.textHeight,
    @required this.textMaxWidth,
    @required this.selectedDuration,
    @required this.ranges,
  }) : super(key: key);

  final Duration changeDuration;
  final double grownWidth;
  final double textHeight;
  final double textMaxWidth;
  final ValueNotifier<Duration> selectedDuration;
  final List<Range> ranges;

  @override
  _AnimatedRecoveryTimeInfoState createState() => _AnimatedRecoveryTimeInfoState();
}

class _AnimatedRecoveryTimeInfoState extends State<AnimatedRecoveryTimeInfo> {
  int sectionGrown;

  setSectionGrown(){
    for(int i = 0; i < widget.ranges.length; i++){
      if(i == (widget.ranges.length - 1)) sectionGrown = i;
      else{
        Duration thisDuration = Duration(seconds: widget.ranges[i].endSeconds);
        if(widget.selectedDuration.value <= thisDuration){
          sectionGrown = i;
          break;
        }
      }
    }
  }

  @override
  void initState() {
    //set initial section grown
    setSectionGrown();

    //listen to changes to update section grown
    widget.selectedDuration.addListener((){
      setSectionGrown();
      if(mounted){
        setState(() {});
      }
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //quick maths
    double sub = -(widget.textMaxWidth * 2);
    double sizeWhenGrown = widget.grownWidth + sub;
    double sizeWhenShrunk = 0 + sub;
    if(sizeWhenShrunk.isNegative){
      sizeWhenShrunk = 0;
    }

    //create
    List<Widget> nameSections = new List<Widget>();
    List<Widget> tickSections = new List<Widget>();
    List<Widget> endSections = new List<Widget>();
    for(int i = 0; i < widget.ranges.length; i++){
      //add name section
      nameSections.add(
        ANameSection(
          changeDuration: widget.changeDuration, 
          grownWidth: widget.grownWidth,
          sectionGrown: sectionGrown,
          //-----
          sectionID: i, 
          sectionName: widget.ranges[i].name,
        ),
      );
      
      /*
      //grab single data
      String name = widget.passedNameStrings[i];
      int startTick = widget.passedStartTick[i];
      int endTick = widget.passedEndTick[i];

      //add name section
      nameSections.add(
        ANameSection(
          changeDuration: widget.changeDuration, 
          grownWidth: widget.grownWidth, 
          regularWidth: widget.regularWidth,
          sectionGrown: sectionGrown,
          //-----
          sectionID: i, 
          sectionName: name,
        ),
      );
      */

      //add tick section
      /*
      tickSections.add(
        AnimatedContainer(
          duration: widget.changeDuration,
          height: 16,
          width: (sectionGrown == i) ? widget.grownWidth : 0,
          child: (sectionGrown == i) ? TickGenerator(
            startTick: startTick,
            endTick: endTick,
            selectedDuration: widget.selectedDuration,
          ) : Container(),
        ),
      );
      */

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
        onTap: widget.ranges[sectionGrown].onTap,
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
    @required this.sectionName,
  }) : super(key: key);

  final Duration changeDuration;
  final int sectionGrown;
  final int sectionID;
  final double grownWidth;
  final String sectionName;

  @override
  Widget build(BuildContext context) {
    bool selected = (sectionGrown == sectionID);
    return AnimatedContainer(
      duration: changeDuration,
      width:  selected ? grownWidth : 0,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                right: 8,
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
    );
  }
}

/*
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