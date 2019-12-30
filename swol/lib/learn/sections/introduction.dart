import 'package:flutter/material.dart';
import 'package:swol/learn/shared.dart';

class IntroductionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String tab = "\t\t\t\t\t";
    String newLine = "\n";
    TextStyle defaultStyle = TextStyle(
      fontSize: 16,
    );

    return Column(
      children: <Widget>[
        SectionDescription(
          children: [
            TextSpan(
              text: "Swol is an app that helps beginners ",
            ),
            TextSpan(
              text: "get into weightlifting as quick as possible",
              style: TextStyle(
                fontWeight: FontWeight.w900,
              )
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(
            bottom: 8,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              children: <Widget>[
                //-------------------------Introduction-------------------------
                RichText(
                  text: TextSpan(
                    style: defaultStyle,
                    children: [
                      TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                        text:  tab + "It does not focus on tracking progress; it focuses on creating a habit.\t"
                      ),
                      TextSpan(
                        text: " What matters is that you do the best that you can now; the results will come on their own." + newLine,
                      ),
                    ]
                  ),
                ),
                //-------------------------At Your Own Risk-------------------------
                RichText(
                  text: TextSpan(
                    style: defaultStyle,
                    children: [
                      TextSpan(
                        text: tab + "In order to help you, "
                      ),
                      TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                        text: "\twe have many suggestions but\t"
                      ),
                      TextSpan(
                        text: " it's your responsibility to stay safe. "
                        +"We are not liable for any harm that you may cause yourself or others. "
                      ),
                      TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                        text: "\tFollow our suggestions at your own risk.\t" + newLine,
                      ),
                    ]
                  ),
                ),
                //-------------------------Is Experiment-------------------------
                RichText(
                  text: TextSpan(
                    style: defaultStyle,
                    children: [
                      TextSpan(
                        text: tab + "Additionally, be aware that "
                      ),
                      TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                        text: "\tpart of our app is experimental.\t"
                      ),
                      TextSpan(
                        text: " We suspect that one rep max formulas can be used to give users a new goal to work towards after each set,"
                        +" but this has not been proven yet." + newLine,
                      ),
                    ]
                  ),
                ),
                //-------------------------Below Suggestions-------------------------
                RichText(
                  text: TextSpan(
                    style: defaultStyle,
                    children: [
                      TextSpan(
                        text: tab + "Below are some suggestions to get you started. "
                      ),
                      TextSpan(
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                        text: "\tEnjoy Pumping Iron!\t",
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}