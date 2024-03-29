import 'package:flutter/material.dart';

class TrainingNameButton extends StatelessWidget {
  const TrainingNameButton({
    Key? key,
    required this.width,
    required this.sectionName,
    required this.sectionTap,
    required this.blackText,
  }) : super(key: key);

  final double width;
  final String sectionName;
  final Function sectionTap;
  final bool blackText;

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
              color: blackText ? Colors.black : Colors.white,
              size: 16,
            ),
          ),
          Text(
            sectionName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: blackText ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
    );

    return Container(
      width: width,
      height: 32,
      alignment: Alignment.topCenter,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(24.0),
            side: BorderSide(
              color: blackText ? Colors.black : Colors.white,
            ),
          ),
          //everything transparent
          primary: Colors.transparent,
          //onPrimary: Colors.transparent,
          //onSurface: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () => sectionTap(),
        child: content,
      ),
    );
  }
}
