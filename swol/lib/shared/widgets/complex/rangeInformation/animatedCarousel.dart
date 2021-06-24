//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:carousel_slider/carousel_slider.dart';
import 'package:swol/action/page.dart';

//internal
import 'package:swol/shared/widgets/complex/RangeInformation/trainingNameButton.dart';
import 'package:swol/shared/widgets/complex/RangeInformation/ticks.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/structs/range.dart';

//guides the users and instructs them all at once with minimal UI
//used 2 times, both in add exercise...
//1. recovery time info
//2. rep target info
//in change recovery time... recovery time info
class AnimatedRangeInformation extends StatefulWidget {
  AnimatedRangeInformation({
    Key? key,
    required this.selectedDuration,
    required this.ranges,
    this.bigTickNumber: 30,
    this.darkTheme: true,
    this.hideNameButtons: false,
  }) : super(key: key);

  final ValueNotifier<Duration> selectedDuration;
  final List<Range> ranges;
  final int bigTickNumber;
  final bool darkTheme;
  final bool hideNameButtons;

  @override
  _AnimatedRangeInformationState createState() =>
      _AnimatedRangeInformationState();
}

class _AnimatedRangeInformationState extends State<AnimatedRangeInformation> {
  var carousel;
  late CarouselController carouselController;
  int? sectionGrown;

  setSectionGrown({bool jump: false}) {
    for (int i = 0; i < widget.ranges.length; i++) {
      if (i == (widget.ranges.length - 1)) {
        sectionGrown = i;
      } else {
        Duration thisDuration = Duration(seconds: widget.ranges[i].endSeconds);
        if (widget.selectedDuration.value <= thisDuration) {
          sectionGrown = i;
          break;
        }
      }
    }

    if (jump) {
      carouselController.jumpToPage(sectionGrown!);
    } else {
      carouselController.animateToPage(
        sectionGrown!,
        duration: ExercisePage.transitionDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    //set initial section grown
    WidgetsBinding.instance?.addPostFrameCallback((_) {
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
    double chosenHeight = 36.0 + (widget.darkTheme ? 24 : 0.0);

    //create carousel seperately so we can control it
    carousel = CarouselSlider(
      carouselController: carouselController,
      options: CarouselOptions(
        height: chosenHeight, //overrides aspect ratio
        //we don't want to have a hint at the other sections
        //hinting would require too much space
        //and the current UI expresses that there are other sections already
        viewportFraction: 1.0,
        //not needed since we control the carousel with the controller
        enableInfiniteScroll: false,
        //user should never be able to scroll this themeselves
        scrollPhysics: NeverScrollableScrollPhysics(),
      ),
      //-----unrefined
      items: widget.ranges.map((aRange) {
        return Builder(
          builder: (BuildContext context) {
            return Stack(
              children: <Widget>[
                //---Tick Sections
                Positioned(
                  top: 0,
                  child: Container(
                    height: widget.darkTheme ? 16 : 36,
                    width: thisWidth,
                    child: RangeTicks(
                      startTick: aRange.startSeconds,
                      endTick: aRange.endSeconds,
                      selectedDuration: widget.selectedDuration,
                      bigTickNumber: widget.bigTickNumber,
                      darkTheme: widget.darkTheme,
                    ),
                  ),
                ),
                //---Name Sections
                Visibility(
                  visible: (widget.hideNameButtons == false),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: widget.darkTheme ? 24.0 : 0,
                    ),
                    child: TrainingNameButton(
                      width: thisWidth,
                      sectionName: aRange.name,
                      sectionTap: aRange.onTap,
                    ),
                  ),
                ),
                //---End Sections
                DefaultTextStyle(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: (widget.darkTheme ? 24.0 : 0.0),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          left: 0,
                          child: aRange.left,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: aRange.right,
                        )
                      ],
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
    return FittedBox(
      fit: BoxFit.contain,
      child: Theme(
        data: MyTheme.dark,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: chosenHeight,
          child: carousel,
        ),
      ),
    );
  }
}
