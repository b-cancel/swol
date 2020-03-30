//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal
import 'package:swol/shared/widgets/complex/trainingTypeTables/trainingTypes.dart';
import 'package:swol/shared/widgets/simple/oneOrTheOtherIcon.dart';
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';
import 'package:swol/shared/widgets/simple/toLearnPage.dart';
import 'package:swol/shared/methods/theme.dart';

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
        headerIcon = Transform.translate(
          offset: Offset(0, -1),
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Icon(
              FontAwesomeIcons.weight, 
              color: iconColor,
            ),
          ),
        ); 
      break;
      case FitIcons.Hypertrophy: 
      //adjustments required for oddly sized icon
        headerIcon = Transform.translate(
          offset: Offset(-3, -1),
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Icon(
              FontAwesomeIcons.dumbbell, 
              color: iconColor,
            ),
          ),
        );
      break;
      case FitIcons.Strength: 
        //adjustments required for oddly sized icon
        headerIcon = Transform.translate(
          offset: Offset(0, -1),
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Icon(
              FontAwesomeIcons.weightHanging, 
              color: iconColor,
            ),
          ),
        ); 
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
          backgroundColor: Colors.black,
        );
      break;
    }

    //show pop up
    showCustomHeaderIconPopUp(
      context,
      [
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
          ),
        ),
      ],
      [
        Theme(
          data: MyTheme.dark,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 8,
            ),
            child: ScrollableTrainingTypes(
              showEndurance: showEndurance,
              showHypertrophy: showHypertrophy,
              showStrength: showStrength,
              highlightField: highlightField,
            ),
          ),
        ),
        SuggestToLearnPage(),
      ],
      headerIcon,
      isDense: true,
      headerBackground: Colors.black,
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
      cardBackground: false,
      highlightField: highlightField,
      sections: [sections],
      sectionID: new ValueNotifier(0),
    );
  }
}