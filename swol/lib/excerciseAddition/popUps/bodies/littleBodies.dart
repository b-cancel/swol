import 'package:flutter/material.dart';
import 'package:swol/learn/shared.dart';

class ReferenceLinkPopUpBody extends StatelessWidget {
  const ReferenceLinkPopUpBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "It's helpful to have an external resource at hand\n",
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Link a video or image of the proper form, or anything else that might help you excercise safetly",
            ),
          ),
        ],
      ),
    );
  }
}

class ExcerciseNotePopUpBody extends StatelessWidget {
  const ExcerciseNotePopUpBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
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
                  text: "A space for any ",
                ),
                TextSpan(
                  text: "extra details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " that you may want to keep in mind before starting the excercise",
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
                  content: Text("Grip Type"),
                ),
                ListItem(
                  circleColor: Colors.blue,
                  circleText: "2",
                  circleTextSize: 18,
                  circleTextColor: Colors.white,
                  content: Text("Hold Duration"),
                ),
                ListItem(
                  circleColor: Colors.blue,
                  circleText: "3",
                  circleTextSize: 18,
                  circleTextColor: Colors.white,
                  content: Text("Muscles To Focus On"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}