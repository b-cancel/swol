//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/trainingTypeTables/trainingTypes.dart';
import 'package:swol/shared/widgets/simple/toLearnPage.dart';
import 'package:swol/shared/methods/theme.dart';

//widget
class ExplainFunctionality extends StatelessWidget {
  const ExplainFunctionality({
    Key? key,
    required this.trainingName,
    required this.sectionWithInitialFocus,
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
                textScaleFactor: MediaQuery.of(
                  context,
                ).textScaleFactor,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Each type of training gives you the best results" +
                          " if you work within its ",
                    ),
                    TextSpan(
                      style: bold,
                      text: "Break Time Range\n\n",
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
                      text: "You should wait between ",
                    ),
                    TextSpan(
                      style: bold,
                      text: trainingTypeToMin(trainingName),
                    ),
                    TextSpan(
                      text: " and ",
                    ),
                    TextSpan(
                      style: bold,
                      text: trainingTypeToMax(trainingName),
                    ),
                    TextSpan(
                      text: " before moving on to your next set\n",
                    ),
                    //-------------------------
                  ],
                ),
              ),
              Visibility(
                visible: trainingName.length > 0,
                child: RichText(
                  textScaleFactor: MediaQuery.of(
                    context,
                  ).textScaleFactor,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Since you are current doing ",
                      ),
                      TextSpan(
                        style: bold,
                        text: trainingName + " Training\n",
                      ),
                      TextSpan(
                        text: "You should wait between ",
                      ),
                      TextSpan(
                        style: bold,
                        text: trainingTypeToMin(trainingName),
                      ),
                      TextSpan(text: " and "),
                      TextSpan(
                        style: bold,
                        text: trainingTypeToMax(trainingName),
                      ),
                      TextSpan(
                        text: " before moving on to your next set\n",
                      ),
                    ],
                  ),
                ),
              ),
              RichText(
                textScaleFactor: MediaQuery.of(
                  context,
                ).textScaleFactor,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: "The "),
                    TextSpan(style: bold, text: "Break Time Ranges"),
                    TextSpan(
                      text: " for all training types are below for reference\n",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Theme(
          data: MyTheme.dark,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
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

String durationToTrainingType(Duration duration) {
  //NOTE: If you aren't taking a break longer than 15 seconds
  //you aren't doing endurance training
  //exceptions current covered
  //although they really should be covered by using asserts
  //instead of just cuz I know and have read the code
  if (duration <= Duration(minutes: 1)) {
    if (duration < Duration(seconds: 15)) {
      return "";
    } else {
      return "Endurance";
    }
  } else if (duration <= Duration(minutes: 2)) {
    return "Hypertrohpy";
  } else if (duration <= Duration(minutes: 3)) {
    return "Hyp/Str";
  } else {
    return "Strength";
  }
}

//should never be passed on empty string
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

//should never be passed on empty string
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
