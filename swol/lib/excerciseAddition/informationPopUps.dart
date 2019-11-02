import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/learn/body.dart';
import 'package:swol/learn/cardTable.dart';
import 'package:swol/learn/reusableWidgets.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';

class RepTargetPopUp extends StatelessWidget {
  const RepTargetPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Rep Target",
      subtitle: "Not sure? Keep the default",
      child: Container(
        child: Column(
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
                      text: "rep target",
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
                  child: ScrollableTrainingTypes(
                    lightMode: true,
                    highlightField: 3,
                  ),
                ),
            ),
            LearnPageSuggestion(),
          ],
        ),
      ),
    );
  }
}

class PredictionFormulasPopUp extends StatelessWidget {
  const PredictionFormulasPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Prediction Formulas",
      subtitle: "Not sure? Keep the default",
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "Select the formula that you ",
                  ),
                  TextSpan(
                    text: "beleive",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " will predict your ",
                  ),
                  TextSpan(
                    text: "ability",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " for this excercise\n"
                  ),
                ]
              ),
            ),
          ),
          Theme(
            data: ThemeData.dark(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: FunctionCardTable(
                  context: context,
                ),
              ),
            ),
          ),
          LearnPageSuggestion(),
        ],
      ),
    );
  }
}

class AutoUpdatePopUp extends StatelessWidget {
  const AutoUpdatePopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Auto Update",
      subtitle: "Not sure? Keep the default",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Which formula works best, depends on"
                  + " how much your nervous system is limiting you" 
                  + " in each individual excercise",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "But the forumla you chose initally, might not be predicting your results",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Because your nervous system is limiting you more or less than expected",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "By enabling this, you allow the app to switch to a formula that matches your results after each set",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "So you can have a more realistic goal to push towards",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SetTargetPopUp extends StatelessWidget {
  const SetTargetPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Set Target",
      subtitle: "Not sure? Keep the default",
      child: Container(
        child: Column(
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
                  child: ScrollableTrainingTypes(
                    lightMode: true,
                    highlightField: 4,
                  ),
                ),
            ),
            LearnPageSuggestion(),
          ],
        ),
      ),
    );
  }
}

class SetBreakPopUp extends StatelessWidget {
  const SetBreakPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Recovery Time",
      subtitle: "Not sure? Keep the default",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "To select the appropiate recovery time\n"
                  ),
                ),
                ListItem(
                  circleColor: Colors.blue,
                  circleText: "1",
                  circleTextColor: Colors.white,
                  circleTextSize: 18,
                  circlePadding: 0,
                  content: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Select the ",
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
                ListItem(
                  circleColor: Colors.blue,
                  circleText: "2",
                  circleTextColor: Colors.white,
                  circleTextSize: 18,
                  circlePadding: 0,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Select a ",
                            ),
                            TextSpan(
                              text: "larger recovery time ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "within the training type's range",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              )
                            ),
                            TextSpan(
                              text: " if you are working with ",
                            ),
                            TextSpan(
                              text: "larger muscle groups\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Select a ",
                            ),
                            TextSpan(
                              text: "smaller recovery time ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "within the training type's range",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              )
                            ),
                            TextSpan(
                              text: " if you are working with ",
                            ),
                            TextSpan(
                              text: "smaller muscle groups",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                ),
              ),
          ),
          new LearnPageSuggestion(),
        ],
      ),
    );
  }
}

class LearnPageSuggestion extends StatelessWidget {
  const LearnPageSuggestion({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "To Learn More\nVisit the ",
                ),
                TextSpan(
                  text: "Learn",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " page\n"
                ),
              ]
            ),
          ),
          Icon(
            FontAwesomeIcons.leanpub,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

class ReferenceLinkPopUp extends StatelessWidget {
  const ReferenceLinkPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Reference Link",
      subtitle: "Copy and paste",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "It's helpful to have a resource at hand\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Link a video or image of the proper form, or anything else that might help",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExcerciseNotePopUp extends StatelessWidget {
  const ExcerciseNotePopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Excercise Note",
      subtitle: "Details",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "A space for any extra details",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExcerciseNamePopUp extends StatelessWidget {
  const ExcerciseNamePopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Excercise Name",
      subtitle: "Choose a unique name",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "You can have ",
                  ),
                  TextSpan(
                    text: "multiple excercises",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " with the ",
                  ),
                  TextSpan(
                    text: "same name\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ),
            ),
            //---
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "But, it's best",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " if you keep the name ",
                  ),
                  TextSpan(
                    text: "unique\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ),
            ),
            //---
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "Especially",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " when you do the "
                    + "same excercise, multiple times, in the same workout"
                    + " but with a ",
                  ),
                  TextSpan(
                    text: "different",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
              ),
              child: Column(
                children: <Widget>[
                  ListItem(
                    circleColor: Colors.blue,
                    circleText: "1",
                    circleTextSize: 18,
                    circleTextColor: Colors.white,
                    content: Text("Previous Set"),
                  ),
                  ListItem(
                    circleColor: Colors.blue,
                    circleText: "2",
                    circleTextSize: 18,
                    circleTextColor: Colors.white,
                    content: Text("Ability Formula"),
                  ),
                  ListItem(
                    circleColor: Colors.blue,
                    circleText: "3",
                    circleTextSize: 18,
                    circleTextColor: Colors.white,
                    content: Text("Rep Target"),
                  )
                ],
              ),
            )
            /*
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Although the you can have multiple excercises with the same name\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Extra details should be placed in notes", sdfsd
              ),
            ),
            */
          ],
        ),
      ),
    );
  }
}

/*
BASIC TEMPLATE
RichText(
  text: TextSpan(
    style: TextStyle(
      color: Colors.black,
    ),
    children: [
      TextSpan(
        text: "bold text",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: " non bold text ",
      ),
    ]
  ),
),
*/