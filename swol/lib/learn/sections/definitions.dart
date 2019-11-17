//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/learn/shared.dart';

class DefinitionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionDescription(
          child: Text("Some definitions to clarify what is being referred to throughout the app"),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Text("Terms used throughout the app"),
              //-------------------------Repetition
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
                    + "It refers to the ammount of ",
                  ),
                  TextSpan(
                    text: "times you were able to lift",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " a particular weight ",
                  ),
                  TextSpan(
                    text: "before taking a break",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              //-------------------------Set
              ADefinition(
                word: "Set",
                definition: [
                  TextSpan(
                    text: "A set includes both the ",
                  ),
                  TextSpan(
                    text: "weight and the amount of times you were able to lift",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " that particular weight (reps)",
                  ),
                ],
                extra: [
                  TextSpan(
                    text: "You need ",
                  ),
                  TextSpan(
                    text: "at least one set before",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " your muscles are warm and ready to ",
                  ),
                  TextSpan(
                    text: "work at their peak",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              //-------------------------Excercise
              ADefinition(
                word: "Excercise",
                definition: [
                  TextSpan(
                    text: "An excercise is a type of movement.",
                  ),
                ],
                extra: [
                  TextSpan(
                    text: "Multiple sets",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " should be done ",
                  ),
                  TextSpan(
                    text: "per excercise",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ", since the first is a warm up.",
                  ),
                ],
              ),
              //-------------------------Workout
              ADefinition(
                word: "Workout",
                definition: [
                  TextSpan(
                    text: "A workout is a list of exercises done one after the other with a gap of ",
                  ),
                  TextSpan(
                    text: "at most",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " 1 hour and a half between each."
                  ),
                ],
              ),
              //-------------------------One Rep Max
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
          ),
        ),
      ],
    );
  }
}

//Format for a word and definition
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
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          WordToDefine(word: word),
          Container(
            width: 16,
          ),
          Expanded(
            child: DefinitionOfWord(definition: definition, extra: extra),
          )
        ],
      ),
    );
  }
}

class DefinitionOfWord extends StatelessWidget {
  const DefinitionOfWord({
    Key key,
    @required this.definition,
    @required this.extra,
  }) : super(key: key);

  final List<TextSpan> definition;
  final List<TextSpan> extra;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: new BorderRadius.only(
          topLeft:  const  Radius.circular(12.0),
          bottomLeft: const  Radius.circular(12.0),
        ),
      ),
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
          : Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: 12,
                ),
                child: Container(
                  color: Colors.white.withOpacity(0.5),
                  height: 1,
                ),
              ),
              Padding(
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
          )
        ],
      ),
    );
  }
}

class WordToDefine extends StatelessWidget {
  const WordToDefine({
    Key key,
    @required this.word,
  }) : super(key: key);

  final String word;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: new BorderRadius.only(
          bottomRight:  const  Radius.circular(12.0),
          topRight: const  Radius.circular(12.0),
        ),
      ),
      child: Stack(
        children: <Widget>[
          //longest term to keep divider in same location
          Opacity(
            opacity: 0,
            child: Text(
              "1 Rep Max",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          //actual term
          Text(
            word,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}