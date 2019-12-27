//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LearnPageSuggestion extends StatelessWidget {
  const LearnPageSuggestion({
    Key key,
    this.bottomPadding: true,
  }) : super(key: key);

  final bool bottomPadding;

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
                  text: " page" + (bottomPadding ? "\n" : ""),
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