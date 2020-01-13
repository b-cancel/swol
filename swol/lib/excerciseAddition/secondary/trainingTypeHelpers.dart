//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal from addition
import 'package:swol/excerciseAddition/popUps/toLearnPage.dart';
import 'package:swol/excerciseAddition/secondary/tiny.dart';

//internal from shared
import 'package:swol/sharedWidgets/excerciseListTile/oneRepMaxChip.dart';
import 'package:swol/sharedWidgets/trainingTypes/trainingTypes.dart';

class TrainingTypeIndicator extends StatefulWidget {
  TrainingTypeIndicator({
    @required this.setTarget,
  });

  final ValueNotifier<int> setTarget;

  @override
  _TrainingTypeIndicatorState createState() => _TrainingTypeIndicatorState();
}

class _TrainingTypeIndicatorState extends State<TrainingTypeIndicator> {
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
        (((MediaQuery.of(context).size.width-48)/4) * section),
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
    widget.setTarget.addListener((){
      setTargetToSection();
    });

    //super init
    super.initState();
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
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Tooltip(
                  message: "You shouldn't do anymore than 6 sets",
                  waitDuration: Duration(milliseconds: 100),
                  preferBelow: false,
                  child: Container(
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
              ),
            )
          ],
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
    return Column(
      children: <Widget>[
        Pill(
          setTarget: setTarget,
          actives: [4,5,6], 
          sectionSize: totalScreenWidth/4,
          name: "Strength Training",
          onTap: makeTrainingTypePopUp(
            context: context,
            title: "Strength Training",
            showStrength: true,
            highlightfield: 4,
            iconID: FitIcons.Strength,
          ),
          leftMultiplier: 2.5,
          rightMultiplier: 2.5,
        ),
        Pill(
          setTarget: setTarget,
          actives: [3,4,5], 
          sectionSize: totalScreenWidth/4,
          name: "Hypertrophy Training",
          onTap: makeTrainingTypePopUp(
            context: context,
            title: "Hypertrophy Training",
            showHypertrophy: true,
            highlightfield: 4,
            iconID: FitIcons.Hypertrophy,
          ),
          leftMultiplier: 1.5,
          rightMultiplier: 3.5,
        ),
        Pill(
          setTarget: setTarget,
          actives: [1,2,3], //+1
          sectionSize: totalScreenWidth/4,
          name: "Endurance Training",
          onTap: makeTrainingTypePopUp(
            context: context,
            title: "Endurance Training",
            showEndurance: true,
            highlightfield: 4,
            iconID: FitIcons.Endurance,
          ),
          leftMultiplier: 0,
          rightMultiplier: 5.5,
        ),
      ],
    );
  }
}

enum FitIcons {Endurance, Hypertrophy, HypAndStr, Strength}

makeTrainingTypePopUp({
    @required BuildContext context,
    @required String title,
    @required FitIcons iconID,
    //0,1,2,3(hypertrophy/strength)
    bool showStrength: false,
    bool showHypertrophy: false,
    bool showEndurance: false,
    int highlightfield: -1,
}){
  return (){
    //unfocus so whatever was focused before doesnt annoying scroll us back
    FocusScope.of(context).unfocus();

    Color c = Colors.white;

    //create header "icon"
    Widget header;
    switch(iconID){
      case FitIcons.Endurance: header = Icon(FontAwesomeIcons.weight, color: c); break;
      case FitIcons.Hypertrophy: header = Transform.translate(
          offset: Offset(-3, 0),
          child: Icon(FontAwesomeIcons.dumbbell, color: c),
        );
      break;
      case FitIcons.Strength: header = Icon(FontAwesomeIcons.weightHanging, color: c); break;
      default: header = OneOverOther(
        one: Transform.translate(
          offset: Offset(-3, 0),
          child: Icon(
            FontAwesomeIcons.dumbbell,
            color: c,
          ),
        ),
        other: Icon(
          FontAwesomeIcons.weightHanging,
          color: c,
        ),
        iconColor: c,
        backgroundColor: Colors.blue,
      );
      break;
    }

    header = ClipOval(
      child: Container(
        color: Colors.blue,
        //NOTE: 28 is the max
        padding: EdgeInsets.all(24),
        child: Container(
          height: 56,
          width: 56,
          child: FittedBox(
            fit: BoxFit.fill,
            child: header,
          ),
        ),
      ),
    );

    //show awesome dialog
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: true,
      animType: AnimType.SCALE,
      customHeader: header,
      isDense: true, //is dense true is slightly larger
      body: Theme(
        data: ThemeData.dark(),
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
              ScrollableTrainingTypes(
                lightMode: true,
                showEndurance: showEndurance,
                showHypertrophy: showHypertrophy,
                showStrength: showStrength,
                highlightField: highlightfield,
              ),
              LearnPageSuggestion(
                bottomPadding: false,
              ),
            ],
          ),
        ),
      ),
    ).show();
  };
}