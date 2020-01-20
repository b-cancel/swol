//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excerciseAddition/popUps/toLearnPage.dart';
import 'package:swol/trainingTypes/trainingTypes.dart';

//title: "Recovery Time",
//subtitle: "Different training types require different recovery times",
class ExplainFunctionality extends StatelessWidget {
  const ExplainFunctionality({
    Key key,
    @required this.sectionWithInitialFocus,
  }) : super(key: key);

  final int sectionWithInitialFocus;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              child: AllTrainingTypes(
                lightMode: true,
                highlightField: 2,
                sectionWithInitialFocus: sectionWithInitialFocus,
              ),
            ),
        ),
        LearnPageSuggestion(),
      ],
    );
  }
}