import 'package:flutter/material.dart';

class TrainingNameButton extends StatelessWidget {
  const TrainingNameButton({
    Key key,
    @required this.width,
    @required this.sectionName,
    @required this.sectionTap,
  }) : super(key: key);

  final double width;
  final String sectionName;
  final Function sectionTap;

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: 8,
            ),
            child: Icon(
              Icons.info,
              size: 16,
            ),
          ),
          Text(
            sectionName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    return Container(
      width: width,
      height: 32,
      alignment: Alignment.topCenter,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(24.0),
          side: BorderSide(color: Colors.white),
        ),
        padding: EdgeInsets.all(0),
        //everything transparent
        color: Colors.transparent,
        splashColor: Colors.transparent,
        disabledColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        //only when touched
        highlightColor: Theme.of(context).accentColor,
        colorBrightness: Brightness.dark,
        onPressed: sectionTap,
        child: content,
      ),
    );
  }
}