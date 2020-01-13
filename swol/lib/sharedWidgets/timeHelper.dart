import 'package:flutter/material.dart';

class TickGenerator extends StatefulWidget {
  TickGenerator({
    @required this.startTick,
    @required this.endTick,
    @required this.bigTickNumber,
    this.selectedDuration,
    this.darkTheme,
  });

  final int startTick;
  final int endTick;
  final int bigTickNumber;
  final ValueNotifier<Duration> selectedDuration;
  final bool darkTheme;

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
      bool bigTick = ((thisTick % widget.bigTickNumber) == 0);

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
              : (widget.darkTheme) ? Theme.of(context).backgroundColor : Colors.grey.withOpacity(0.5),
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

class SliderTipButton extends StatelessWidget {
  const SliderTipButton({
    @required this.buttonText,
    this.tipText,
    Key key,
  }) : super(key: key);

  final String buttonText;
  final String tipText;

  @override
  Widget build(BuildContext context) {
    Widget mainButton = Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: (tipText == null) ? Colors.transparent : Theme.of(context).primaryColorDark,
          width: 2,
        )
      ),
      padding: EdgeInsets.symmetric(
        horizontal: (tipText == null) ? 0 : 4,
        vertical: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          (tipText == null) ? Container()
          : Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ),
            child: Icon(
              Icons.info,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          Text(buttonText)
        ],
      ),
    );
    
    if(tipText == null) return mainButton;
    else{
      //TODO: remove this... instead use the other tooltip thingy
      return Tooltip(
        message: tipText,
        waitDuration: Duration(milliseconds: 100),
        preferBelow: false,
        child: mainButton,
      );
    }
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
    this.bigTickNumber: 30,
    this.darkTheme: true,
  }) : super(key: key);

  final Duration changeDuration;
  final double grownWidth;
  final double textHeight;
  final double textMaxWidth;
  final ValueNotifier<Duration> selectedDuration;
  final List<Range> ranges;
  final int bigTickNumber;
  final bool darkTheme;

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
          sectionTap: widget.ranges[sectionGrown].onTap,
        ),
      );

      //add tick section
      tickSections.add(
        AnimatedContainer(
          duration: widget.changeDuration,
          height: 16,
          width: (sectionGrown == i) ? widget.grownWidth : 0,
          child: (sectionGrown == i) ? TickGenerator(
            startTick: widget.ranges[i].startSeconds,
            endTick: widget.ranges[i].endSeconds,
            selectedDuration: widget.selectedDuration,
            bigTickNumber: widget.bigTickNumber,
            darkTheme: widget.darkTheme,
          ) : Container(),
        ),
      );

      //add range section
      Widget left = AnimatedContainer(
        duration: widget.changeDuration,         
        width: (sectionGrown == i) ? MediaQuery.of(context).size.width - 48: 0,
        alignment: Alignment.centerLeft,
        child: Opacity(
          opacity: (sectionGrown == i) ? 1 : 0,
          child: widget.ranges[i].left,
        )
      );

      Widget right = AnimatedContainer(
        duration: widget.changeDuration,         
        width: (sectionGrown == i) ? MediaQuery.of(context).size.width - 48: 0,
        alignment: Alignment.centerRight,
        child: Opacity(
          opacity: (sectionGrown == i) ? 1 : 0,
          child: widget.ranges[i].right,
        ),
      );

      //usually left OVER right
      if(i != (widget.ranges.length-1)){
        endSections.add(
          Stack(
            children: <Widget>[
              right,
              left,
            ],
          ),
        );
      }
      else{
        endSections.add(
          Stack(
            children: <Widget>[
              left,
              right,
            ],
          ),
        );
      }
    }

    //build
    return Theme(
      data: ThemeData.dark(),
      child: Stack(
        children: <Widget>[
          //---Name Sections
          (widget.darkTheme == false) 
          ? Container()
          : Padding(
            padding: EdgeInsets.only(
              top: 24.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: nameSections,
            ),
          ),
          //---Tick Sections
          Padding(
            padding: const EdgeInsets.only(
              bottom: 24.0,
            ),
            child: Row(
              children: tickSections,
            ),
          ),
          //---End Sections
          (widget.darkTheme == false) 
          ? Container()
          : DefaultTextStyle(
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: 24,
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
    @required this.sectionID,
    @required this.grownWidth,
    @required this.sectionName,
    @required this.sectionTap,
  }) : super(key: key);

  final Duration changeDuration;
  final int sectionGrown;
  final int sectionID;
  final double grownWidth;
  final String sectionName;
  final Function sectionTap;

  @override
  Widget build(BuildContext context) {
    bool selected = (sectionGrown == sectionID);
    return AnimatedContainer(
      duration: changeDuration,
      width:  selected ? grownWidth : 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: sectionTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
          ),
        ),
      ),
    );
  }
}