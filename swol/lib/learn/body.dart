import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

    return Padding(
      padding: EdgeInsets.all(
        16,
      ),
      child: Container(
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
      ),
    );
  }
}

class DefinitionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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

          //TODO SET
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

          //TODO EXCERCISE
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

          //TODO WORKOUT
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

class TrainingBody extends StatelessWidget {
  const TrainingBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Text(
            "Select a training based on the results you desire\n\n"
            + "But first research the risks, and have a plan to eliminate or minimize them",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: PersistentCardTable(
                  items: [
                    "Training Type",
                    "Weight Heaviness",
                    "Recovery Duration",
                    "Rep Targets",
                    "Set Targets",
                    "Primary Goal",
                    "Increase Muscle",
                    "Risk To",
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: CarouselSlider(
                        height: 256.0,
                        //so they can compare both
                        enableInfiniteScroll: true,
                        enlargeCenterPage: true,
                        autoPlay: false,
                        viewportFraction: .75,
                        items: [0,1,2].map((i) {
                          List<String> one = [
                            "Strength ",
                            "Very Heavy",
                            "3 to 5 mins",
                            "1 to 6",
                            "4 to 6",
                            "Tension",
                            "Strength",
                            "Joints",
                          ];

                          List<String> two = [
                            "\tHypertrophy",//NOTE: extra space for dumbell
                            "Heavy",
                            "1 to 2 mins",
                            "7 to 12",
                            "3 to 5",
                            "Hypertrophy", 
                            "Size",
                            "Joints and Tissue",
                          ];

                          List<String> three = [
                            "Endurance ",
                            "Light",
                            "15 seconds to 1 min",
                            "13+",
                            "2 to 4",
                            "Metabolic Stress",
                            "Endurance",
                            "Connective Tissue",
                          ];

                          List<List<String>> lists = [one,two,three];

                          return Builder(
                            builder: (BuildContext context) {
                              return CardTable(
                                items: lists[i],
                                icon: [
                                  FontAwesomeIcons.weightHanging,
                                  FontAwesomeIcons.dumbbell,
                                  FontAwesomeIcons.weight,
                                ][i],
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 32,
                        
                        decoration: BoxDecoration(
                          // Box decoration takes a gradient
                          gradient: LinearGradient(
                            // Where the linear gradient begins and ends
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            stops: [0.1,1.0],
                            colors: [
                              Theme.of(context).primaryColor,
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Container(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PrecautionsBody extends StatelessWidget {
  const PrecautionsBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 16,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: 16,
              ),
              child: Text(
                "Every exercise has its own unique risks\n\n"
                + "So make sure you do the research, in order to fully understand how to eliminate or minimize them\n\n"
                + "Below are some of the most common precautions you can take",
              ),
            ),
            ListItem(
              circleColor: Theme.of(context).accentColor,
              content: Text(
                "use a spotter",
              ),
            ),
            ListItem(
              circleColor: Theme.of(context).accentColor,
              content: Text(
                "stay away from extremes like, 1 Rep Sets with tons of weight, and 20+ Rep Sets",
              ),
            ),
            ListItem(
              circleColor: Theme.of(context).accentColor,
              content: Text(
                "don't exercise until failure, instead stop before it",
              ),
            ),
            ListItem(
              circleColor: Theme.of(context).accentColor,
              content: Text(
                "use the joints full range of motion as long as doing so doesn't cause overextension",
              ),
            ),
            ListItem(
              circleColor: Theme.of(context).accentColor,
              content: Text(
                "avoid locking your joints when the force can cause them to bend in the incorrect direction ",
              ),
            ),
            ListItem(
              circleColor: Theme.of(context).accentColor,
              content: Text(
                "if you suspect you are injured, do not continue, go to a doctor",
              ),
            ),
            ListItem(
              circleColor: Theme.of(context).accentColor,
              content: Text(
                "maintain good form at all times",
              ),
            ),
            ListItem(
              circleColor: Theme.of(context).accentColor,
              content: Text(
                "take the appropriate break between sets",
              ),
            ),
            ListItem(
              circleColor: Theme.of(context).accentColor,
              content: Text(
                "drink the right amount of water",
              ),
            ),
            ListItem(
              circleColor: Theme.of(context).accentColor,
              content: Text(
                "eat the right amount and kind of food",
              ),
            ),
          ],
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