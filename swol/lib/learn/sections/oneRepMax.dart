//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/simple/listItem.dart';
import 'package:swol/learn/description.dart';

//widget
class OneRepMaxBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );

    TextStyle defaultStyle = TextStyle(
      fontSize: 16,
    );

    return Container(
      padding: EdgeInsets.only(
        bottom: 8,
      ),
      child: Column(
        children: <Widget>[
          SectionDescription(
            children:[
              TextSpan(
                text: "Doing a 1 Rep Max puts you at a high risk for injury!",
                style: boldStyle,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: defaultStyle,
                    children: [
                      TextSpan(
                        text: "Hitting a ",
                      ),
                      TextSpan(
                        text: "New Personal Record by peforming a One Rep Max (1RM)",
                        style: boldStyle,
                      ),
                      TextSpan(
                        text: " is a rush, and a good way to ",
                      ),
                      TextSpan(
                        text: "track your progress\n",
                        style: boldStyle,
                      )
                    ]
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: defaultStyle,
                    children: [
                      TextSpan(
                        text: "But since it puts you at a high risk for injury, ",
                      ),
                      TextSpan(
                        text: "1RM formulas",
                        style: boldStyle,
                      ),
                      TextSpan(
                        text: " were created to help you get a rough idea of ",
                      ),
                      TextSpan(
                        text: "what your 1RM should be, ",
                        style: boldStyle,
                      ),
                      TextSpan(
                        text: "based on any other set\n",
                      ),
                    ]
                  ),
                ),
                Text(
                  "However, there are some downsides\n",
                  style: defaultStyle,
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  content: RichText(
                    text: TextSpan(
                      style: defaultStyle,
                      children: [
                        TextSpan(
                          text: "Your ",
                        ),
                        TextSpan(
                          text: "Estimated 1RM gets less precise",
                          style: boldStyle,
                        ),
                        TextSpan(
                          text: " as you increase reps and/or the weight you are lifting",
                        ),
                      ]
                    ),
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  content: RichText(
                    text: TextSpan(
                      style: defaultStyle,
                      children: [
                        TextSpan(
                          text: "Some formulas can only give you an estimated 1RM if you plug in a set with ",
                        ),
                        TextSpan(
                          text: "less than 35 reps",
                          style: boldStyle,
                        ),
                      ]
                    ),
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  content: RichText(
                    text: TextSpan(
                      style: defaultStyle,
                      children: [
                        TextSpan(
                          text: "There are ",
                        ),
                        TextSpan(
                          text: "Multiple 1RM Formulas",
                          style: boldStyle,
                        ),
                        TextSpan(
                          text: " that give slightly different results, but no clear indicator of when to use which",
                        )
                      ]
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: defaultStyle,
                    children: [
                      TextSpan(
                        text: "We tried to fix all of this in ",
                      ),
                      TextSpan(
                        text: "\"The Experiment\"",
                        style: boldStyle,
                      ),
                    ]
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}