import 'package:flutter/material.dart';

class IntroductionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String tab = "\t\t\t\t\t";
    String newLine = "\n";
    TextStyle defaultStyle = TextStyle(
      fontSize: 16,
    );

    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
      ),
      child: Column(
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: defaultStyle,
              children: [
                TextSpan(
                  text: tab + "Swol is an app that helps "
                ),
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  text: "\thelps beginners get into weightlifting as quick as possible.\t"
                ),
                TextSpan(
                  text: " It does not focus on tracking progress; it focuses on creating a habit. "
                  +" What matters is that you do the best that you can now; the results will come on their own." + newLine,
                ),
              ]
            ),
          ),
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
                  text: "\twe have many suggestions\t"
                ),
                TextSpan(
                  text: " but it's your responsibility to stay safe. "
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
    );
  }
}