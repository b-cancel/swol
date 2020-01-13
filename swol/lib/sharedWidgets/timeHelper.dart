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

    int index = -1; //added to before return so that starts at 0
    carousel = CarouselSlider(
      initialPage: 1,
      height: 400.0,
      items: widget.ranges.map((range) {
        return Builder(
          builder: (BuildContext context) {
            index++; //starts at 0

            return Container(
              color: Colors.red,
              height: 16,
              child: Container(),
            );

            /*
            return Stack(
              children: <Widget>[
                //---Name Sections
                (widget.darkTheme == false) ? Container()
                : Padding(
                  padding: EdgeInsets.only(
                    top: 24.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ANameSection(
                        grownWidth: widget.grownWidth,
                        sectionName: range.name,
                        sectionTap: widget.ranges[sectionGrown].onTap,
                      ),
                    ],
                  ),
                ),
              ],
            );
            */
          },
        );
      }).toList(),
    );

    //build
    return Theme(
      data: ThemeData.dark(),
      child: Container(),
      
      
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
    @required this.grownWidth,
    @required this.sectionName,
    @required this.sectionTap,
  }) : super(key: key);

  final double grownWidth;
  final String sectionName;
  final Function sectionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: grownWidth,
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