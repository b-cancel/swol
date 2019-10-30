import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/learn/cardTable.dart';
import 'package:swol/learn/reusableWidgets.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';

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
    return Column(
      children: <Widget>[
        new SectionDescription(
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
        ),
      ],
    );
  }
}

class SectionDescription extends StatelessWidget {
  const SectionDescription({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.5),
            )
          )
        ),
        padding: EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
          child: child,
        ),
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
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
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
          ),
          Container(
            width: 16,
          ),
          Expanded(
            child: Container(
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
            ),
          )
        ],
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
        SectionDescription(
          child: Text(
            "Select a training based on the results you desire\n\n"
            + "But first research the risks, and have a plan to eliminate or minimize them",
          ),
        ),
        new ScrollableTrainingTypes(),
      ],
    );
  }
}

class ScrollableTrainingTypes extends StatelessWidget {
  const ScrollableTrainingTypes({
    Key key,
    this.showStrength: true,
    this.showHypertrophy: true,
    this.showEndurance: true,
  }) : super(key: key);

  final bool showStrength;
  final bool showHypertrophy;
  final bool showEndurance;

  @override
  Widget build(BuildContext context) {
    List<Widget> types = new List<Widget>();

    if(showStrength){
      types.add(
        CardTable(
          items: [
            "Strength ",
            "Very Heavy",
            "2:35 -> 5:00",
            "1 to 6",
            "4 to 6",
            "Tension",
            "Strength",
            "Joints",
          ],
          icon: FontAwesomeIcons.weightHanging,
        ),
      );
    }

    if(showHypertrophy){
      types.add(
        CardTable(
          items: [
            "\tHypertrophy",//NOTE: extra space for dumbell
            "Heavy",
            "1:05 -> 2:30",
            "7 to 12",
            "3 to 5",
            "Hypertrophy", 
            "Size",
            "Joints and Tissue",
          ],
          icon: FontAwesomeIcons.dumbbell,
        ),
      );
    }
    
    if(showEndurance){
      types.add(
        CardTable(
          items: [
            "Endurance ",
            "Light",
            "15 secs -> 1:00",
            "13+",
            "2 to 4",
            "Metabolic Stress",
            "Endurance",
            "Connective Tissue",
          ],
          icon: FontAwesomeIcons.weight,
        ),
      );
    }

    return IntrinsicHeight(
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
                    items: types,
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
    );
  }
}

class PrecautionsBody extends StatelessWidget {
  const PrecautionsBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionDescription(
          child: Text(
            "Every exercise has its own unique risks\n\n"
            + "So make sure you do the research, in order to fully understand how to eliminate or minimize them\n\n"
            + "Below are some of the most common precautions you can take",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 16,
            ),
            child: Column(
              children: <Widget>[
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
        ),
      ],
    );
  }
}

class OneRepMaxBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
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
    );
  }
  /*
  FunctionCardTable(
        context: context,
      ),
  */
}

class ExperimentBody extends StatelessWidget {
  const ExperimentBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "We suspect that one rep max formulas can be helpful for more than just tracking your progress\n\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:"Based on our limited experience and experimentation we believe\n",
                ),
              ],
            ),
          ),
          //TODO: refine below
          ListItem(
            circleColor: Theme.of(context).accentColor,
            circleText: "1",
            circleTextSize: 18,
            content: Text(
              "The "
              + "ABILITY"
              + " of a set of muscles is the "
              + "maximum amount of weight"
              + " they can lift at "
              + "all rep range"
              + " targets (below 35)",
            ),
          ),
          ListItem(
            circleColor: Theme.of(context).accentColor,
            circleText: "2",
            circleTextSize: 18,
            content: Text(
              "The "
              + "ABILITY"
              + " of a set of muscles can therefore be "
              + "represented by a formula"
              + " (one of the one rep max formulas)",
            ),
          ),
          ListItem(
            circleColor: Theme.of(context).accentColor,
            circleText: "3",
            circleTextSize: 18,
            content: Text(
              "Additionally, the "
              + "ABILITY"
              + " of a set of muscles does not just "
              + "depend"
              + " on how strong those muscles are, but "
              + "also on how much of them you can voluntarily activate",
            ),
          ),
          ListItem(
            circleColor: Theme.of(context).accentColor,
            circleText: "4",
            circleTextSize: 18,
            content: Text(
              "Furthermore, because you need "
              + "different amounts of control"
              + " over your entire nervous system "
              + "for different exercises, different ABILITY formulas will be used for different exercises"
            ),
          ),
          ListItem(
            circleColor: Theme.of(context).accentColor,
            circleText: "5",
            circleTextSize: 18,
            content: Text(
              "We believe that "
              + "what ABILITY formula each exercise uses, indicates"
              + "to what extent you can voluntarily activate your muscles due to "
              + "your overall level of nervous system control"
            ),
          ),
          ListItem(
            circleColor: Theme.of(context).accentColor,
            circleText: "6",
            circleTextSize: 18,
            content: Text(
              "So as you continue to train, the "
              + "ABILITY formulas that each exercise uses should change to reflect an overall increase in the control"
              + " you have over your entire nervous system"
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "If we make these assumptions, for each exercise,",
                ),
                TextSpan(
                  text: "we can ",
                ),
                TextSpan(
                  text: "use the 1RM formulas to give you a goal to work towards",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " for your next set by using\n",
                ),
              ],
            ),
          ),
          ListItem(
            circleColor: Theme.of(context).accentColor,
            circleText: "1",
            circleTextSize: 18,
            content: Text(
              "your previous set ",
            ),
          ),
          ListItem(
            circleColor: Theme.of(context).accentColor,
            circleText: "2",
            circleTextSize: 18,
            content: Text(
              "your desired exertion level",
            ),
          ),
          ListItem(
            circleColor: Theme.of(context).accentColor,
            circleText: "3",
            circleTextSize: 18,
            content: Text(
              "your prefered or suggested ability formula",
            ),
          ),
          ListItem(
            circleColor: Theme.of(context).accentColor,
            circleText: "4",
            circleTextSize: 18,
            content: Text(
              "and your rep target",
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "As new sets are recorded ",
                ),
                TextSpan(
                  text: "we can also switch to a formula\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "that more accurately reflects your results\n\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //-------------------------
                TextSpan(
                  text: "We believe this will help you ",
                ),
                TextSpan(
                  text: "improve as fast as possible,\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "regardless of what type of training",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " you are using,\n",
                ),
                TextSpan(
                  text: "without getting injured\n\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //-------------------------
                TextSpan(
                  text: "Below is a chart of all the ",
                ),
                TextSpan(
                  text: "Ability Formulas\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "(previously known as",
                ),
                TextSpan(
                  text: "1 Rep Max Formulas",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ")\n",
                ),
                TextSpan(
                  text: "and what level of "
                ),
                TextSpan(
                  text: "limitation they imply",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: FunctionCardTable(
              context: context,
            ),
          ),
        ],
      ),
    );
  }
}