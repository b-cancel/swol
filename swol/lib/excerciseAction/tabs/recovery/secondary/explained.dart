//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/trainingTypeTables/trainingTypes.dart';
import 'package:swol/shared/widgets/simple/toLearnPage.dart';
import 'package:swol/shared/methods/theme.dart';

//widget
class ExplainFunctionality extends StatelessWidget {
  const ExplainFunctionality({
    Key key,
    @required this.trainingName,
    @required this.sectionWithInitialFocus,
  }) : super(key: key);

  final String trainingName;
  final int sectionWithInitialFocus;

  @override
  Widget build(BuildContext context) {
    TextStyle bold = TextStyle(
      fontWeight: FontWeight.bold,
    );

    //return
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Each type of training gives you the best results if you work within its ",
                    ),
                    TextSpan(
                      style: bold,
                      text: "Break Time Range\n\n"
                    ),
                    //-------------------------
                    TextSpan(
                      text: "Since you are current doing ",
                    ),
                    TextSpan(
                      style: bold,
                      text: trainingName + " Training\n",
                    ),
                    TextSpan(
                      text: "You should wait between "
                    ),
                    TextSpan(
                      style: bold,
                      text: trainingTypeToMin(trainingName),
                    ),
                    TextSpan(
                      text: " and "
                    ),
                    TextSpan(
                      style: bold,
                      text: trainingTypeToMax(trainingName),
                    ),
                    TextSpan(
                      text: " before moving on to your next set\n"
                    )
                    //-------------------------
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children:[
                    TextSpan(
                      text: "The "
                    ),
                    TextSpan(
                      style: bold,
                      text: "Break Time Ranges"
                    ),
                    TextSpan(
                      text: " for all training types are below for reference\n",
                    ),
                  ]
                ) 
              )
            ],
          ),
        ),
        Theme(
          data: MyTheme.dark,
          child: Padding(
            padding: EdgeInsets.only(
              top: 8,
              bottom: 16.0,
            ),
            child: AllTrainingTypes(
              highlightField: 2,
              sectionWithInitialFocus: sectionWithInitialFocus,
            ),
          ),
        ),
        SuggestToLearnPage(),
      ],
    );
  }
}

String durationToTrainingType(Duration duration, {bool zeroIsEndurance: true}) {
  if (duration < Duration(minutes: 1)) {
    if (zeroIsEndurance)
      return "Endurance";
    else {
      if (duration < Duration(seconds: 15)) {
        return "";
      } else
        return "Endurance";
    }
  } else if (duration < Duration(minutes: 2))
    return "Hypertrohpy";
  else if (duration < Duration(minutes: 3))
    return "Hyp/Str";
  else
    return "Strength";
}

String trainingTypeToMin(String training) {
  if (training == "Endurance")
    return "15 seconds";
  else if (training == "Hypertrohpy")
    return "1 minute";
  else if (training == "Hyp/Str")
    return "2 minutes";
  else
    return "3 minutes";
}

String trainingTypeToMax(String training) {
  if (training == "Endurance")
    return "1 minutes";
  else if (training == "Hypertrohpy")
    return "2 minutes";
  else if (training == "Hyp/Str")
    return "3 minutes";
  else
    return "5 minutes";
}