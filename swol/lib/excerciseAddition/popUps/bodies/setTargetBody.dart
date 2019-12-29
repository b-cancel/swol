//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excerciseAddition/popUps/toLearnPage.dart';
import 'package:swol/sharedWidgets/trainingTypes/trainingTypes.dart';

class SetTargetPopUpBody extends StatelessWidget {
  const SetTargetPopUpBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "Select a ",
                ),
                TextSpan(
                  text: "set target",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )
                ),
                TextSpan(
                  text: " for the ",
                ),
                TextSpan(
                  text: "training type",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )
                ),
                TextSpan(
                  text: " you are working towards"
                ),
              ]
            ),
          ),
        ),
        Theme(
          data: ThemeData.dark(),
          child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: AllTrainingTypes(
                lightMode: true,
                highlightField: 4,
              ),
            ),
        ),
        LearnPageSuggestion(),
      ],
    );
  }
}