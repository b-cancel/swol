import 'package:flutter/material.dart';

Widget buildFrontWidget(String title, Function onPressed) {
  return Container(
    color: Color(0xFFffcd3c),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "CARD",
          style: TextStyle(
            color: Color(0xFF2e282a),
            fontFamily: 'OpenSans',
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        FlatButton(
          onPressed: onPressed,
          child: Text(
            "Open",
          ),
          textColor: Colors.white,
          color: Colors.indigoAccent,
          splashColor: Colors.white.withOpacity(0.5),
        )
      ],
    ),
  );
}

Widget buildInnerTopWidget() {
  return Container(
    color: Color(0xFFff9234),
    alignment: Alignment.center,
    child: Text(
      "TITLE",
      style: TextStyle(
        color: Color(0xFF2e282a),
        fontFamily: 'OpenSans',
        fontSize: 20.0,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

Widget buildInnerBottomWidget(Function onPressed) {
  return Container(
    color: Color(0xFFecf2f9),
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: FlatButton(
        onPressed: onPressed,
        child: Text(
          "Close",
        ),
        textColor: Colors.white,
        color: Colors.indigoAccent,
        splashColor: Colors.white.withOpacity(0.5),
      ),
    ),
  );
}
