//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal
import 'package:swol/shared/widgets/simple/oneOrTheOtherIcon.dart';
import 'package:swol/shared/widgets/simple/ourLearnPopUp.dart';
import 'package:swol/shared/widgets/simple/toLearnPage.dart';
import 'package:swol/trainingTypes/trainingTypes.dart';

//TODO: combine this with the sliders
//since they are technically used in more places than just add excercise
//1. suggest page uses rep target slider
//2. NOT recovery page, since to change the time we are using a whole seperate bit of UI
//    the seperate bit of UI, WILL NOT have a pop up, because it will be a pop up itself

//enum to make it easier to pass the "Icon"
enum FitIcons {Endurance, Hypertrophy, HypAndStr, Strength}

//short cuts
Function makeEnduranceTrainingPopUp(
  BuildContext context, 
  int highlightField,
){
  return _makeTrainingTypePopUp(
    context: context,
    title: "Endurance Training",
    showEndurance: true,
    highlightField: highlightField,
    iconID: FitIcons.Endurance,
  );
}

Function makeHypertrophyTrainingPopUp(
  BuildContext context, 
  int highlightField,
){
  return _makeTrainingTypePopUp(
    context: context,
    title: "Hypertrophy Training",
    showHypertrophy: true,
    highlightField: highlightField,
    iconID: FitIcons.Hypertrophy,
  );
}

Function makeHypertrophyStrengthTrainingPopUp(
  BuildContext context, 
  int highlightField,
){
  return _makeTrainingTypePopUp(
    context: context,
    title: "Hypertrophy/Strength",
    showHypertrophy: true,
    showStrength: true,
    highlightField: highlightField,
    iconID: FitIcons.HypAndStr,
  );
}

Function makeStrengthTrainingPopUp(
  BuildContext context, 
  int highlightField,
){
  return _makeTrainingTypePopUp(
    context: context,
    title: "Strength Training",
    showStrength: true,
    highlightField: highlightField,
    iconID: FitIcons.Strength,
  );
}

//the dad function
Function _makeTrainingTypePopUp({
    @required BuildContext context,
    @required String title,
    @required FitIcons iconID,
    //0,1,2,3(hypertrophy/strength)
    bool showStrength: false,
    bool showHypertrophy: false,
    bool showEndurance: false,
    int highlightField: -1,
}){
  return (){
    Color iconColor = Colors.white;
    Widget headerIcon;
    switch(iconID){
      case FitIcons.Endurance: 
        headerIcon = Icon(FontAwesomeIcons.weight, color: iconColor); 
      break;
      case FitIcons.Hypertrophy: headerIcon = Transform.translate(
          offset: Offset(-3, 0),
          child: Icon(FontAwesomeIcons.dumbbell, color: iconColor),
        );
      break;
      case FitIcons.Strength: 
        headerIcon = Icon(FontAwesomeIcons.weightHanging, color: iconColor); 
      break;
      default: 
        headerIcon = OneOrTheOtherIcon(
          one: Transform.translate(
            offset: Offset(-3, 0),
            child: Icon(
              FontAwesomeIcons.dumbbell,
              color: iconColor,
            ),
          ),
          other: Icon(
            FontAwesomeIcons.weightHanging,
            color: iconColor,
          ),
          iconColor: iconColor,
          backgroundColor: Colors.blue,
        );
      break;
    }

    //show pop up
    showLearnPopUp(
      context,
      Container(
        width: 56,
        height: 56,
        child: FittedBox(
          fit: BoxFit.fill,
          child: headerIcon,
        ),
      ),
      [
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
        Theme(
          data: ThemeData.dark(),
          child: ScrollableTrainingTypes(
            showEndurance: showEndurance,
            showHypertrophy: showHypertrophy,
            showStrength: showStrength,
            highlightField: highlightField,
          ),
        ),
        SuggestToLearnPage(),
      ],
      isDense: true,
    );
  };
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