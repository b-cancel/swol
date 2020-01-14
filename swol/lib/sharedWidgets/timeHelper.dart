//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:carousel_slider/carousel_slider.dart';

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

//TODO: complete the update of the below
//guides the users and instructs them all at once with minimal UI
//used 2 times, both in add excercise... 
//1. recovery time info
//2. rep target info
//in change recovery time... recovery time info

//the slide width is as large as its going to be... so perhaps consider passing it
//TODO: check that slider width is accurate
//set first to the width of the phone (which is roughly how large it should be)
//then make sure its contained within the box its in (of untold or told width)
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

  //textHeight: 16
  //textMaxWidth: 28

/*
  setSectionGrown(){
    /*
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

    
    carousel.animateToPage(
      sectionGrown, 
      duration: Duration(milliseconds: 250), 
      curve: Curves.easeInOut,
    );
    */
  }

  @override
  void initState() {
    //set initial section grown
    //setSectionGrown();

    /*
    //listen to changes to update section grown
    widget.selectedDuration.addListener((){
      setSectionGrown();
      if(mounted){
        setState(() {});
      }
    });
    */
    
    super.initState();
  }
  */

  @override
  Widget build(BuildContext context) {
    double thisWidth = MediaQuery.of(context).size.width;
    double chosenHeight = 250.0; //TODO: set actual value
    /*
    //create
    List<Widget> nameSections = new List<Widget>();
    List<Widget> tickSections = new List<Widget>();
    List<Widget> endSections = new List<Widget>();
    for(int i = 0; i < .length; i++){
      //add name section
      nameSections.add(
        
      );

      //add tick section
      tickSections.add(
        Container(
          height: 16,
          width: widget.grownWidth,
          child: TickGenerator(
            startTick: widget.ranges[i].startSeconds,
            endTick: widget.ranges[i].endSeconds,
            selectedDuration: widget.selectedDuration,
            bigTickNumber: widget.bigTickNumber,
            darkTheme: widget.darkTheme,
          ),
        ),
      );

      //add range section
      Widget left = Container(       
        width: MediaQuery.of(context).size.width - 48,
        alignment: Alignment.centerLeft,
        child: Opacity(
          opacity: (sectionGrown == i) ? 1 : 0,
          child: widget.ranges[i].left,
        )
      );

      Widget right = Container(       
        width: MediaQuery.of(context).size.width - 48,
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
    */

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
      //scrollPhysics: NeverScrollableScrollPhysics(), //TODO: uncomment
      //-----unrefined
      //initialPage: 1,
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
                    sectionName: aRange.name,
                    sectionTap: aRange.onTap,
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
      
      
      //carousel,
      
      
      /*
      
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
      */
    );
  }
}

class ANameSection extends StatelessWidget {
  const ANameSection({
    Key key,
    @required this.sectionName,
    @required this.sectionTap,
  }) : super(key: key);

  final String sectionName;
  final Function sectionTap;

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
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