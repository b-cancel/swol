//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excerciseAddition/popUps/toLearnPage.dart';
import 'package:swol/learn/sections/experiment.dart';

class PredictionFormulasPopUpBody extends StatelessWidget {
  const PredictionFormulasPopUpBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "Select the formula that you ",
                ),
                TextSpan(
                  text: "beleive",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " will predict your ",
                ),
                TextSpan(
                  text: "ability",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " for this excercise\n"
                ),
              ]
            ),
          ),
        ),
        Theme(
          data: ThemeData.dark(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: FunctionCardTable(
                context: context,
                isDark: false,
              ),
            ),
          ),
        ),
        LearnPageSuggestion(),
      ],
    );
  }
}