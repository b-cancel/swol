//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/pages/learn/sections/definitions/definition.dart';
import 'package:swol/pages/learn/description.dart';

//widget
class DefinitionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionDescription(
          children: [
            TextSpan(
              text: "Some definitions to ",
            ),
            TextSpan(
              text: "clarify what is being referred to",
              style: TextStyle(
                fontWeight: FontWeight.w900,
              )
            ),
            TextSpan(
              text: " throughout the app",
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 0.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Text("Terms used throughout the app"),
              //-------------------------Repetition
              ADefinition(
                word: "Rep",
                definition: [
                  TextSpan(
                    text: "Reps",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " is an abbreviation of repetitions. "
                    + "It refers to the amount of ",
                  ),
                  TextSpan(
                    text: "times you were able to lift",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " a particular weight ",
                  ),
                  TextSpan(
                    text: "before taking a break",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                extra: [
                  TextSpan(
                    text: "The time between each ",
                  ),
                  TextSpan(
                    text: "Rep",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " in a ",
                  ),
                  TextSpan(
                    text: "Set ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "should be",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: " at most ",
                  ),
                  TextSpan(
                    text: "3",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " seconds, but ",
                  ),
                  TextSpan(
                    text: "can be",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: " at most ",
                  ),
                  TextSpan(
                    text: "10",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " seconds",
                  ),
                ],
              ),
              //-------------------------Set
              ADefinition(
                word: "Set",
                definition: [
                  TextSpan(
                    text: "A set includes both the ",
                  ),
                  TextSpan(
                    text: "weight and the amount of times you were able to lift",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " that particular weight (reps)",
                  ),
                ],
                extra: [
                  TextSpan(
                    text: "You need ",
                  ),
                  TextSpan(
                    text: "at least one set before",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " your muscles are warm and ready to ",
                  ),
                  TextSpan(
                    text: "work at their peak",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              //-------------------------Exercise
              ADefinition(
                word: "Exercise",
                definition: [
                  TextSpan(
                    text: "An exercise is a type of movement.",
                  ),
                ],
                extra: [
                  TextSpan(
                    text: "Multiple sets",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " should be done ",
                  ),
                  TextSpan(
                    text: "per exercise",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ", since the first is a warm up.",
                  ),
                ],
              ),
              //-------------------------Workout
              ADefinition(
                word: "Workout",
                definition: [
                  TextSpan(
                    text: "A workout is a list of exercises done one after the other with a gap of ",
                  ),
                  TextSpan(
                    text: "at most",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " 1 hour and a half between each."
                  ),
                ],
              ),
              //-------------------------One Rep Max
              ADefinition(
                word: "1 Rep Max",
                definition: [
                  TextSpan(
                    text: "Your ",
                  ),
                  TextSpan(
                    text: "1 Rep Max",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " is the "
                  ),
                  TextSpan(
                    text: "maximum",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " amount of ",
                  ),
                  TextSpan(
                    text: "weight",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " that you can lift for a ",
                  ),
                  TextSpan(
                    text: "single rep",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                lessBottomPadding: true,
                extra: null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}