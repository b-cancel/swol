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
    @required this.sectionWithInitialFocus,
  }) : super(key: key);

  final int sectionWithInitialFocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.red,
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