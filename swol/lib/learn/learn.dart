import 'package:flutter/gestures.dart' as gests;
import 'package:flutter/material.dart';
import 'package:swol/learn/fullScreenDialog.dart';
import 'package:swol/learn/reusableWidgets.dart';

BuildContext learnSectionBuildContext;

class LearnExcercise extends StatelessWidget {

  Function _openDetailsSection(BuildContext context, int i) {
    return () {
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => details[i],
          fullscreenDialog: true,
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    learnSectionBuildContext = context;

    final expansionTiles = [
      new ExpansionTile(
          title: const Text('The 4 Main Ideas'),
          backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
          children: <Widget>[
            new Divider(color: Theme.of(context).accentColor),
            new Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new CustomCard(
                    //The ABILITY of any set of muscles can be represented by an equation; or more accurately, is a function\n
                    content: new RichText(
                      text: new TextSpan(
                          style: TextStyle(fontSize: 16.0),
                          children: [
                            new TextSpan(
                              text: "The ",
                            ),
                            new TextSpan(
                              text: "ABILITY",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new TextSpan(
                              text: " of any set of muscles can be represented by an equation; or more accurately, ",
                            ),
                            new TextSpan(
                              text: "is a function\n",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ]
                      ),
                    ),
                    circleContent: "1",
                    readMoreFunction: _openDetailsSection(context, 0),
                  ),
                  new CustomCard(
                    //Everyone has a different level of control over their entire nervous system, and different sets of muscles require different percentages of that CONTROL
                    content: new RichText(
                      text: new TextSpan(
                          style: TextStyle(fontSize: 16.0),
                          children: [
                            new TextSpan(
                              text: "Everyone has a different ",
                            ),
                            new TextSpan(
                              text: "level of",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new TextSpan(
                              text: " control over their entire nervous system, and different sets of muscles require different percentages of that ",
                            ),
                            new TextSpan(
                              text: "CONTROL\n",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ]
                      ),
                    ),
                    circleContent: "2",
                    readMoreFunction: _openDetailsSection(context, 1),
                  ),
                  new CustomCard(
                    //The STRENGTH of any set of muscles relies primarily on their ABILITY, and to what extent you can CONTROL them\n
                    content: new RichText(
                      text: new TextSpan(
                          style:  TextStyle(fontSize: 16.0),
                          children: [
                            new TextSpan(
                              text: "The ",
                            ),
                            new TextSpan(
                              text: "STRENGTH",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new TextSpan(
                              text: " of any set of muscles relies primarily on their ",
                            ),
                            new TextSpan(
                              text: "ABILITY",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new TextSpan(
                              text: ", ",
                            ),
                            new TextSpan(
                              text: "and",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new TextSpan(
                              text: " to what extent you can ",
                            ),
                            new TextSpan(
                              text: "CONTROL",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            new TextSpan(
                              text: " them\n",
                            ),
                          ]
                      ),
                    ),
                    circleContent: "3",
                    readMoreFunction: _openDetailsSection(context, 2),
                  ),
                  new CustomCard(
                    //The functions used to estimate an individual's 1 rep maximum weight can be reworked to help individuals exercise optimally\n
                    content: new Text(
                      "The functions used to estimate an individual's 1 rep maximum weight can be reworked to help individuals exercise optimally\n",
                      style:  TextStyle(fontSize: 16.0),
                    ),
                    circleContent: "4",
                    readMoreFunction: _openDetailsSection(context, 3),
                  ),
                  new Container(
                    padding: EdgeInsets.all(16.0),
                    child: new Column(
                      children: <Widget>[
                        new Text(
                          "        We suspect that the reason there are multiple functions to help individuals exercise optimally is because each function assumes a certain level of control over the muscles you are using for a particular exercise. ",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        new Text(
                          "\n        This means that although everyone has a certain level of nervous system control, since a different percentage of that control is used per exercise, different exercises might use different functions.",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        new Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(12.0),
                          child: new Text(
                            "STRENGTH",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
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
                                  color: Theme.of(context).splashColor,
                                ),
                                children: [
                                  new Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: new Text(
                                      "CONTROL LEVEL",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: new Text(
                                      "ABILITY FUNCTION",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                            new TableRow(children: [
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("1")),
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("Brzycki")),
                            ]),
                            new TableRow(children: [
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("2")),
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("McGlothin (or Landers)")),
                            ]),
                            new TableRow(children: [
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("3")),
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("Almazan *our own*")),
                            ]),
                            new TableRow(children: [
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("4")),
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("Epley (or Baechle)")),
                            ]),
                            new TableRow(children: [
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("5")),
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("O`Conner")),
                            ]),
                            new TableRow(children: [
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("6")),
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("Wathan")),
                            ]),
                            new TableRow(children: [
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("7")),
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("Mayhew")),
                            ]),
                            new TableRow(children: [
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("8 (Olympic Athlete)")),
                              new Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Text("Lombardi")),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ]
      ),
      new ExpansionTile(
          title: const Text('How To Use'),
          backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
          children: <Widget>[
            new Divider(
              color: Theme.of(context).accentColor,
            ),
            new Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  new ListItem(
                    content: new Text(
                      "Pick an exercise",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    circleText: "1",
                    circleTextSize: 22.0,
                    circleColor: getRandomBrightColor(),
                  ),
                  new ListItem(
                    content: new Text(
                      "Pick a weight",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    circleText: "2",
                    circleTextSize: 22.0,
                    circleColor: getRandomBrightColor(),
                  ),
                  new ListItem(
                    content: new Text(
                      "Do as many reps as possible",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    circleText: "3",
                    circleTextSize: 22.0,
                    circleColor: getRandomBrightColor(),
                  ),
                  new ListItem(
                    content: new Text(
                      "Log that set",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    circleText: "4",
                    circleTextSize: 22.0,
                    circleColor: getRandomBrightColor(),
                  ),
                  new ListItem(
                    content: new Text(
                      "Repeat steps 2-4 until you complete your sets",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    circleText: "5",
                    circleTextSize: 22.0,
                    circleColor: getRandomBrightColor(),
                  ),
                  new ListItem(
                    content: new Text(
                      "Set a target for your next set use the suggestion",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    circleText: "6",
                    circleTextSize: 22.0,
                    circleColor: getRandomBrightColor(),
                  ),
                  new ListItem(
                    content: new Text(
                      "Repeat steps 1-6 until you complete your workout",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    circleText: "7",
                    circleTextSize: 22.0,
                    circleColor: getRandomBrightColor(),
                  ),
                ],
              ),
            )
          ]
      ),
      new ExpansionTile(
          title: const Text('Tips'),
          backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
          children: <Widget>[
            new Divider(color: Theme.of(context).accentColor),
            new Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  ListItem(
                    content: new Text(
                      "Although you want to push yourself to your max, you do not want to injure yourself, to avoid doing so stop increasing reps or weight once you see your form starting to break, especially when you are lifting near your 1 rep maximum",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  ListItem(
                    content: new Text(
                      "Your form will make a massive difference in your overall strength so for best results make sure you only increase your weight if you can lift said weight with good form",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  ListItem(
                    content: new Text(
                      "if after completing your 1 rep max, you do the maximum repetitions with 50% of your weight with ease, you might not have put enough effort in your 1 rep max or you might have to use another function to help you to continue to be optimal in your exercise",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  ListItem(
                    content: new Text(
                      "In order to not break a set you cannot take a break longer than 30 seconds",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  ListItem(
                    content: new Text(
                      "The heavier your lift the faster your will gain control over your entire system",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ]
      ),
      new ExpansionTile(
          title: const Text('Warnings'),
          backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
          children: <Widget>[
            new Divider(color: Theme.of(context).accentColor),
            new Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  ListItem(
                    content: new Text(
                      "This is an experimental fitness application, results are not guaranteed",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  ListItem(
                    content: new Text(
                      "Using this application might push you to your limits so use it at your own risk, we are not liable for any injuries",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  ListItem(
                    content: new Text(
                      "There are many other ways to exercise, you should do your own research and experiments if possible",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ]
      ),
      new ExpansionTile(
          title: const Text('Contact Us'),
          backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
          children: <Widget>[
            new Divider(
              color: Theme.of(context).accentColor,
            ),
            new Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(16.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new RichText(
                    text: new TextSpan(
                      style: TextStyle(fontSize: 16.0),
                      children: [
                        new TextSpan(
                          text: 'Request Support: ',
                        ),
                        new TextSpan(
                          text: 'Here',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textSelectionHandleColor,
                          ),
                          recognizer: new gests.TapGestureRecognizer()
                            ..onTap = () {launchURL("mailto:bryan.o.cancel@gmail.com?subject=SWOL%20Support");},
                        ),
                      ],
                    ),
                  ),
                  new Divider(),
                  new RichText(
                    text: new TextSpan(
                      style: TextStyle(fontSize: 16.0),
                      children: [
                        new TextSpan(
                          text: 'Developed By: ',
                        ),
                        new TextSpan(
                          text: 'Bryan Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textSelectionHandleColor,
                          ),
                          recognizer: new gests.TapGestureRecognizer()
                            ..onTap = () {launchURL("https://b-cancel.github.io/");},
                        ),
                      ],
                    ),
                  ),
                  new Divider(),
                  new RichText(
                    text: new TextSpan(
                      style: TextStyle(fontSize: 16.0),
                      children: [
                        new TextSpan(
                          text: 'As an Intern at: ',
                        ),
                        new TextSpan(
                          text: 'CleverSolve',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textSelectionHandleColor,
                          ),
                          recognizer: new gests.TapGestureRecognizer()
                            ..onTap = () {launchURL("http://cleversolve.com/");},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]
      ),
    ];

    return new Scaffold(
      body: new ListView(children: <Widget>[
          expansionTiles[0],
          expansionTiles[1],
          expansionTiles[2],
          expansionTiles[3],
          expansionTiles[4],
        ],
      ),
    );
  }
}