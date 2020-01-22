//flutter
import 'package:flutter/material.dart';

//internal: shared
import 'package:swol/shared/widgets/simple/ourToolTip.dart';
import 'package:swol/shared/functions/trainingPopUps.dart';

//internal: other
import 'package:swol/excerciseAddition/secondary/tiny.dart';
import 'package:swol/trainingTypes/trainingTypes.dart';

//widgets
class SetTargetToTrainingTypeIndicator extends StatefulWidget {
  SetTargetToTrainingTypeIndicator({
    @required this.setTarget,
    @required this.wholeWidth,
    @required this.oneSidePadding,
  });

  final ValueNotifier<int> setTarget;
  final double wholeWidth;
  final double oneSidePadding;

  @override
  _SetTargetToTrainingTypeIndicatorState createState() => _SetTargetToTrainingTypeIndicatorState();
}

class _SetTargetToTrainingTypeIndicatorState extends State<SetTargetToTrainingTypeIndicator> {
  int section;
  ScrollController controller = new ScrollController();

  setTargetToSection(){
    if(widget.setTarget.value > 7) section = 4;
    else{
      section = widget.setTarget.value - 3;
      section = (section < 0) ? 0 : section;
    }

    WidgetsBinding.instance.addPostFrameCallback((_){
      controller.animateTo(
        (((widget.wholeWidth - (2 * widget.oneSidePadding))/4) * section),
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    //init
    setTargetToSection();

    //listener
    widget.setTarget.addListener(setTargetToSection);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.setTarget.removeListener(setTargetToSection);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double tickWidth = 4;
    double totalScreenWidth = MediaQuery.of(context).size.width - 48;
    double totalSliderWidth = (totalScreenWidth/4) * 8;

    double tickSpace = tickWidth * 9;
    double spacerSpace = totalSliderWidth - tickSpace;
    double spacerWidth = spacerSpace / 8;

    List<Widget> ticksAndStuff = new List<Widget>();
    
    //add our first tick
    ticksAndStuff.add(
      Tick(
        tickWidth: tickWidth,
        setTarget: widget.setTarget,
        value: 1,
      ),
    );

    //add spacer then tick 8 times
    for(int i = 0; i < 8; i++){
      //spacer
      ticksAndStuff.add(
        Container(
          width: spacerWidth,
        ),
      );

      //tick
      ticksAndStuff.add(
        Tick(
          tickWidth: tickWidth,
          setTarget: widget.setTarget,
          value: (i+2),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: Container(
        height: 108, //manually set
        width: totalSliderWidth,
        child: Stack(
          children: <Widget>[
            ListView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: controller,
              children: [
                Stack(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: ticksAndStuff,
                    ),
                    Theme(
                      //light so that our pop ups work properly
                      data: ThemeData.light(), 
                      child: ThePills(
                        setTarget: widget.setTarget, 
                        totalScreenWidth: totalScreenWidth,
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: NoMoreThan6Sets(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NoMoreThan6Sets extends StatelessWidget {
  const NoMoreThan6Sets({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        showToolTip(
          context, 
          "Any More than 6 sets\nmight do you more harm than good",
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColorDark,
              width: 2,
            )
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 4,
          ),
          child: Icon(
            Icons.warning,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ),
    );
  }
}

class ThePills extends StatelessWidget {
  const ThePills({
    Key key,
    @required this.setTarget,
    @required this.totalScreenWidth,
  }) : super(key: key);

  final ValueNotifier<int> setTarget;
  final double totalScreenWidth;

  @override
  Widget build(BuildContext context) {
    //total screenwidth is the right size (1/4 of it is a section)
    return Container(
      //seven sections in between since there are 9 clicks
      width: (totalScreenWidth/4) * 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Pill(
            setTarget: setTarget,
            actives: [4,5,6], 
            sectionSize: totalScreenWidth/4,
            name: "Strength Training",
            onTap: makeStrengthTrainingPopUp(context, 4),
            leftMultiplier: 2.75,
            rightMultiplier: 2.75,
          ),
          Pill(
            setTarget: setTarget,
            actives: [3,4,5], 
            sectionSize: totalScreenWidth/4,
            name: "Hypertrophy Training",
            onTap: makeHypertrophyTrainingPopUp(context, 4),
            leftMultiplier: 1.75,
            rightMultiplier: 3.75,
          ),
          Pill(
            setTarget: setTarget,
            actives: [1,2,3], //+1
            sectionSize: totalScreenWidth/4,
            name: "Endurance Training",
            onTap: makeEnduranceTrainingPopUp(context, 4),
            leftMultiplier: 0,
            rightMultiplier: 5.75,
          ),
        ],
      ),
    );
  }
}

class ScrollableTrainingTypes extends StatelessWidget {
  ScrollableTrainingTypes({
    this.showStrength: true,
    this.showHypertrophy: true,
    this.showEndurance: true,
    this.highlightField: -1,
  });

  final bool showEndurance;
  final bool showHypertrophy;
  final bool showStrength;
  final int highlightField;

  @override
  Widget build(BuildContext context) {
    List<int> sections = new List<int>();
    if(showEndurance) sections.add(0);
    if(showHypertrophy) sections.add(1);
    if(showStrength) sections.add(2);

    return TrainingTypeSections(
      lightMode: true,
      highlightField: highlightField,
      sections: [sections],
      sectionID: new ValueNotifier(0),
    );
  }
}