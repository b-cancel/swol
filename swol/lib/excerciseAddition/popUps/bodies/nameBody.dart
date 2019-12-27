import 'package:flutter/material.dart';
import 'package:swol/learn/shared.dart';

class ExcerciseNamePopUpBody extends StatelessWidget {
  const ExcerciseNamePopUpBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        ],
      ),
    );
  }
}