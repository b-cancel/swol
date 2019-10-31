//dart
import 'dart:math';

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Color getRandomBrightColor() {
  final _rnd = new Random();
  int min = 160; //inclusive
  int max = 225; //exclusive

  return Color.fromRGBO(min - _rnd.nextInt(max - min),
      min - _rnd.nextInt(max - min), min - _rnd.nextInt(max - min), 1.0);
}

class LinkAsListContent extends StatelessWidget {
  LinkAsListContent({
    this.link,
    this.text,
    this.context,
  });

  final String link;
  final String text;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return new Transform(
      transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
      child: new Container(
        alignment: Alignment.centerLeft,
        child: new FlatButton(
          onPressed: () => launchURL(link),
          child: new Text(
            text,
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).textSelectionHandleColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key key,
    this.content,
    this.circleContent,
    this.readMoreFunction,
  }) : super(key: key);

  final Widget content;
  final String circleContent;
  final Function readMoreFunction;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Padding(
        padding:
            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new ListItem(
              content: content,
              circleText: circleContent,
              bottomSpacing: 0.0,
              circleTextSize: 22.0,
              circleColor: Theme.of(context).accentColor,
            ),
            new Container(
              alignment: Alignment.bottomRight,
              child: new FlatButton(
                onPressed: readMoreFunction,
                child: new Text(
                  "Learn More",
                  style: TextStyle(
                    color: Theme.of(context).textSelectionHandleColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  ListItem({
    this.content,
    this.circleColor = Colors.white,
    this.circleSize = 12.0,
    this.circleText = "",
    this.circleTextColor = Colors.black,
    this.circleTextSize = 12.0,
    this.bottomSpacing = 16.0,
    this.circlePadding = 4,
  });

  final Widget content;

  final Color circleColor;
  final double circleSize;

  final String circleText;
  final Color circleTextColor;
  final double circleTextSize;

  final double bottomSpacing;

  final double circlePadding;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            width: circleTextSize,
            margin: EdgeInsets.only(right: circleTextSize),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(circlePadding),
              child: new Text(
                circleText,
                style: TextStyle(
                  color: circleTextColor,
                  fontSize: circleTextSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          new Expanded(
            child: new Container(
              margin: EdgeInsets.only(bottom: bottomSpacing),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}
