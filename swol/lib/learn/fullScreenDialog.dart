//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/learn/learn.dart';
import 'reusableWidgets.dart';

final details = [
  new FullScreenDialog(
      title: "Ability Is A Function",
      body: new Column(
        children: <Widget>[
          new RichText(
            text: new TextSpan(
              children: [
                new TextSpan(
                    text: "        There are several functions used to estimate how much weight an individual can lift 1 time based on how many times they lifted any other weight. This is called determining an individual's 1 rep maximum or 1RM using the submaximal method.\n\n",
                ),
                new TextSpan(
                    text: "        Since this is possible then we should be able to tell how many times an individual can lift some amount of weight based on their 1RM. Since the relationship holds both ways then any set of muscles' ability is a function. We prove this mathematically in the \"Learn More\" section of Idea 4.\n",
                ),
              ],
            ),
          ),
          new Container(
            alignment: Alignment.bottomRight,
            child: new FlatButton(
              onPressed: () => launchURL('https://en.wikipedia.org/wiki/One-repetition_maximum'),
              child: new Text(
                "Read More",
                style: TextStyle(
                  color: Theme.of(learnSectionBuildContext).textSelectionHandleColor,
                ),
              ),
            ),
          ),
        ],
      ),
  ),
  new FullScreenDialog(
    title: "Level Of Control",
    body: new Column(
      children: <Widget>[
        new RichText(
          text: new TextSpan(
            children: [
              new TextSpan(
                text: "        Everyone has a particular level of control over their nervous system. You can increase how much control you have over it by pushing your limits. This is a concept called overcompensation.\n\n",
              ),
              new TextSpan(
                text: "        It's important to keep in mind that not every exercise pushes the limits of your nervous system.\n\n"
                    "     A bicep curl uses a relatively small muscle, so most people starting off wont be limited by their nervous sytem but rather their muscles ability, because they have all the control they need.\n\n"
                    "     A deadlift uses a alot of different large muscles, so most people starting off will be limited by their nervous sytem and not their muscles' ability, because each muscle independantly can lift the ammount required but you dont have enough control over your nervous system to control each muscle to that level at the same time.\n\n"
                    "        One indicator that your nervous system is holding you back is when your grip is giving out but you are feel like you could have easily done the rep if you would have been able to hold on.\n\n"
                    "        For this reason different exercises might match up to different ability functions.",
              ),
            ],
          ),
        ),
        new Container(
          alignment: Alignment.bottomRight,
          child: new FlatButton(
            onPressed: () => launchURL('https://www.sciencedaily.com/releases/2017/07/170710091652.htm'),
            child: new Text(
              "Read More",
              style: TextStyle(
                color: Theme.of(learnSectionBuildContext).textSelectionHandleColor,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
  new FullScreenDialog(
    title: "Strength = Ability + Control",
    body: new Text(
      "        Your strength is usually how much weight you can lift or do in a particular exercise. As discussed  in the previous \"Learn More\" sections, since your nervous system might stop you from using all of your muscles do their max, your strength is a combination of both your muscles' ability and the control your have over your nervous system."
    ),
  ),
  new FullScreenDialog(
    title: "Exercise Optimally",
    body: new Column(
      children: <Widget>[
        new Text(
          "        Before we rework the functions we clean up our functions with the definitions below.\n",
          style: TextStyle(fontSize: 16.0),
        ),
        new Table(
          border: TableBorder.all(
            color: Colors.white,
            width: 1.0,
            style: BorderStyle.solid,
          ),
          children: [
            new TableRow(
                decoration: BoxDecoration(
                  color: Theme.of(learnSectionBuildContext).splashColor,
                ),
                children: [
                  new Container(
                    padding: EdgeInsets.all(10.0),
                    child: new Text(
                      "VARIABLE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.all(10.0),
                    child: new Text(
                      "DEFINITION",
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
            new TableRow(children: [
              new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Text("w")),
              new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Text("weight lifted")),
            ]),
            new TableRow(children: [
              new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Text("m")),
              new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Text("1 rep maximum")),
            ]),
            new TableRow(children: [
              new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Text("p")),
              new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Text("percentage of 1 rep maximum\n (w/m) = p")),
            ]),
            new TableRow(children: [
              new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Text("r")),
              new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Text("repetitions -or- max repetitions")),
            ]),
          ],
        ),
        new Text(
          "\n        We took multiple steps to rework the original functions. Click each link below to view the reworks of each function and the resulting curve.\n",
          style: TextStyle(fontSize: 16.0),
        ),
        new ListItem(
          content: LinkAsListContent(
            link: "https://www.desmos.com/calculator/aungeuiu8d",
            text: "Original Functions",
            context: learnSectionBuildContext,
          ),
          circleText: "0",
          circleTextSize: 22.0,
          circleColor: getRandomBrightColor(),
        ),
        new ListItem(
          content: LinkAsListContent(
            link: "https://www.desmos.com/calculator/awaxpa5yzq",
            text: "Solve For \"r\"",
            context: learnSectionBuildContext,
          ),
          circleText: "1",
          circleTextSize: 22.0,
          circleColor: getRandomBrightColor(),
        ),
        new ListItem(
          content: LinkAsListContent(
            link: "https://www.desmos.com/calculator/0elq17drtl",
            text: "Replace (w/m) for \"p\"",
            context: learnSectionBuildContext,
          ),
          circleText: "2",
          circleTextSize: 22.0,
          circleColor: getRandomBrightColor(),
        ),
        new ListItem(
          content: LinkAsListContent(
            link: "https://www.desmos.com/calculator/vrofciafsk",
            text: "Flip the Axises",
            context: learnSectionBuildContext,
          ),
          circleText: "2",
          circleTextSize: 22.0,
          circleColor: getRandomBrightColor(),
        ),
      ],
    ),
  ),
];

class FullScreenDialog extends StatelessWidget {

  FullScreenDialog({
    @required this.title,
    @required this.body,
  });

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(16.0),
            child: body
          )
        ],
      ),
    );
  }
}