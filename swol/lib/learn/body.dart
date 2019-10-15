import 'package:flutter/material.dart';
import 'package:swol/learn/cardTable.dart';
import 'package:swol/learn/reusableWidgets.dart';

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

class DefinitionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //Text("Terms used throughout the app"),
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
              + "It refers to the ammount of times you were able to lift a particular weight"
            )
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

        //TODO SET
        ADefinition(
          word: "Set",
          definition: [
            TextSpan(text: "def")],
          extra: [TextSpan(text: "extra")],
        ),

        //TODO EXCERCISE
        ADefinition(
          word: "Excercise",
          definition: [TextSpan(text: "def")],
          extra: [TextSpan(text: "extra")],
        ),

        //TODO WORKOUT
        ADefinition(
          word: "Workout",
          definition: [TextSpan(text: "def")],
          extra: [TextSpan(text: "extra")],
        ),

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
              text: " ammount of ",
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
          extra: null,
        ),
      ],
    );
  }
}

class ADefinition extends StatelessWidget {
  ADefinition({
    this.word,
    this.definition,
    this.extra,
  });

  final String word;
  final List<TextSpan> definition;
  final List<TextSpan> extra;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        bottom: 16,
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  //longest term to keep divider in same location
                  Opacity(
                    opacity: 0,
                    child: Text(
                      "1 Rep Max",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  //actual term
                  Text(
                    word,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Container(
                  color: Theme.of(context).accentColor,
                  width: 2,
                  child: Container(),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        top: 2,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          children: definition,
                        ),
                      ),
                    ),
                    (extra == null) ? Container()
                    : Padding(
                      padding: EdgeInsets.only(
                        top: 8,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                          children: extra,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OneRepMaxBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: FunctionCardTable(
        context: context,
      ),
    );
  }
}