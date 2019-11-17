import 'package:flutter/material.dart';
import 'package:swol/excerciseAddition/informationPopUps.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';
import 'package:swol/sharedWidgets/trainingTypes/trainingTypes.dart';

class ExplainFunctionality extends StatelessWidget {
  const ExplainFunctionality({
    Key key,
    @required this.sectionWithInitialFocus,
  }) : super(key: key);

  final int sectionWithInitialFocus;

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Recovery Time",
      subtitle: "Different training types require different recovery times",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: "Wait until your body finishes\n"),
                  TextSpan(
                    text: "Flushing",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " the right ammount of ",
                  ),
                  TextSpan(
                    text: "Acid Build Up\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "for the type of training you are doing\n"
                  ),
                  TextSpan(
                    text: "Then move onto your next set"
                  )
                ],
              ),
            ),
          ),
          Theme(
            data: ThemeData.dark(),
            child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: ScrollableTrainingTypes(
                  lightMode: true,
                  highlightField: 2,
                  sectionWithInitialFocus: sectionWithInitialFocus,
                ),
              ),
          ),
          LearnPageSuggestion(),
        ],
      ),
    );
  }
}