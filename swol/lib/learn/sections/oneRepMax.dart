import 'package:flutter/material.dart';
import 'package:swol/learn/shared.dart';

class OneRepMaxBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );
    
    /*
    children: [
            TextSpan(
              text: "There are many reasons you may want to workout\nBut ",
            ),
            TextSpan(
              text: " you should have 1 Primary Goal ",
              style: TextStyle(
                fontWeight: FontWeight.w900,
              )
            ),
          ],
    */

    return Container(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 8,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Hitting a ",
                  ),
                  TextSpan(
                    text: "New Personal Record",
                    style: boldStyle,
                  ),
                  TextSpan(
                    text: " is a rush and a good way to ",
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
                children: [
                  TextSpan(
                    text: "But doing a ",
                  ),
                  TextSpan(
                    text: "one rep max (1RM)",
                    style: boldStyle,
                  ),
                  TextSpan(
                    text: " puts you at a ",
                  ),
                  TextSpan(
                    text: "high risk for injury!\n",
                    style: boldStyle,
                  )
                ]
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "So ",
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
                    text: "based on any other set, ",
                  ),
                  TextSpan(
                    text: "without",
                    style: boldStyle,
                  ),
                  TextSpan(
                    text: " putting you at a ",
                  ),
                  TextSpan(
                    text: "high risk for injury\n",
                    style: boldStyle,
                  ),
                ]
              ),
            ),
            Text("However, there are some downsides\n"),
            ListItem(
              circleColor: Theme.of(context).accentColor,
              content: RichText(
                text: TextSpan(
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
                  children: [
                    TextSpan(
                      text: "The formulas can only give you an estimated 1RM if you plug in a set with ",
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
    );
  }
}