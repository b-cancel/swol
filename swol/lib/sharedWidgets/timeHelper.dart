//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:carousel_slider/carousel_slider.dart';
import 'package:swol/sharedWidgets/tickGenerator.dart';

//struct
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

//guides the users and instructs them all at once with minimal UI
//used 2 times, both in add excercise... 
//1. recovery time info
//2. rep target info
//in change recovery time... recovery time info
class AnimatedRecoveryTimeInfo extends StatefulWidget {
  AnimatedRecoveryTimeInfo({
    Key key,
    @required this.changeDuration,
    @required this.selectedDuration,
    @required this.ranges,
    this.bigTickNumber: 30,
    this.darkTheme: true,
  }) : super(key: key);

  final Duration changeDuration;
  final ValueNotifier<Duration> selectedDuration;
  final List<Range> ranges;
  final int bigTickNumber;
  final bool darkTheme;

  @override
  _AnimatedRecoveryTimeInfoState createState() => _AnimatedRecoveryTimeInfoState();
}

class _AnimatedRecoveryTimeInfoState extends State<AnimatedRecoveryTimeInfo> {
  var carousel;
  int sectionGrown;

  setSectionGrown({bool jump: false}){
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

    if(jump) carousel.jumpToPage(sectionGrown);
    else{
      carousel.animateToPage(
        sectionGrown, 
        duration: Duration(milliseconds: 250), 
        curve: Curves.easeInOut,
      );
    }
    
  }

  @override
  void initState() {
    //set initial section grown
    WidgetsBinding.instance.addPostFrameCallback((_){
      setSectionGrown(jump: true);
    });

    //listen to changes to update section grown
    widget.selectedDuration.addListener(setSectionGrown);
    
    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.selectedDuration.removeListener(setSectionGrown);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double thisWidth = MediaQuery.of(context).size.width;
    //36 for the button, 24 for the ticks
    double chosenHeight = 36.0 + 24;

    //create carousel seperately so we can control it
    carousel = CarouselSlider(
      //TODO: correct this to be as small as possible
      height: chosenHeight, //overrides aspect ratio
      //we don't want to have a hint at the other sections
      //hinting would require too much space
      //and the current UI expresses that there are other sections already
      viewportFraction: 1.0,
      //not needed since we control the carousel with the controller
      enableInfiniteScroll: false,
      //user should never be able to scroll this themeselves
      scrollPhysics: NeverScrollableScrollPhysics(),
      //-----unrefined
      items: widget.ranges.map((aRange) {
        return Builder(
          builder: (BuildContext context) {
            return Stack(
              children: <Widget>[
                //---Name Sections
                (widget.darkTheme == false) ? Container()
                : Padding(
                  padding: EdgeInsets.only(
                    top: 24.0,
                  ),
                  child: ANameSection(
                    width: thisWidth,
                    sectionName: aRange.name,
                    sectionTap: aRange.onTap,
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
                    padding: const EdgeInsets.only(
                      top: 24.0,
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            child: aRange.left,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            child: aRange.right,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //---Tick Sections
                Positioned(
                  top: 0,
                  child: Container(
                    height: 16,
                    width: thisWidth,
                    child: TickGenerator(
                      startTick: aRange.startSeconds,
                      endTick: aRange.endSeconds,
                      selectedDuration: widget.selectedDuration,
                      bigTickNumber: widget.bigTickNumber,
                      darkTheme: widget.darkTheme,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }).toList(),
    );

    //build
    return Theme(
      data: ThemeData.dark(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: chosenHeight,
        child: carousel,
      ),
    );
  }
}

class ANameSection extends StatelessWidget {
  const ANameSection({
    Key key,
    @required this.width,
    @required this.sectionName,
    @required this.sectionTap,
  }) : super(key: key);

  final double width;
  final String sectionName;
  final Function sectionTap;

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: 8,
            ),
            child: Icon(
              Icons.info,
              size: 16,
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
    );

    return Container(
      width: width,
      height: 32,
      alignment: Alignment.topCenter,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(24.0),
          side: BorderSide(color: Colors.white),
        ),
        padding: EdgeInsets.all(0),
        //everything transparent
        color: Colors.transparent,
        splashColor: Colors.transparent,
        disabledColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        //only when touched
        highlightColor: Theme.of(context).accentColor,
        colorBrightness: Brightness.dark,
        onPressed: sectionTap,
        child: content,
      ),
    );
  }
}