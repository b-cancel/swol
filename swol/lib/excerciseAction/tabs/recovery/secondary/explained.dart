//flutter
import 'package:flutter/material.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/liquidTime.dart';

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
                //Different types of trainings
                //require different set breaks
                //for the best results

                //but since you are current doing X training
                //you should take a break of atleast A
                //and of at most B

                //the break time ranges for each training type are highlighted below
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
                      text: trainingTypeToMax(trainingName) + "\n",
                    ),
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
                      text: " for all training types are below for reference",
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