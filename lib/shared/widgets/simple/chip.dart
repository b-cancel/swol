import 'package:flutter/material.dart';

class ListTileChipShell extends StatelessWidget {
  const ListTileChipShell({
    Key? key,
    required this.chip,
  }) : super(key: key);

  final Widget chip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          chip,
        ],
      ),
    );
  }
}

class MyChip extends StatelessWidget {
  const MyChip({
    Key? key,
    required this.chipString,
    this.inverse: false,
  }) : super(key: key);

  final String chipString;
  final bool inverse;

  @override
  Widget build(BuildContext context) {
    Color chipColor = (inverse)
        ? Theme.of(context).primaryColorDark
        : Theme.of(context).accentColor;
    Color textColor = (inverse)
        ? Theme.of(context).accentColor
        : Theme.of(context).primaryColorDark;

    return Container(
      alignment: Alignment.topLeft,
      child: MyCustomChip(
        chipColor: chipColor,
        chipString: chipString,
        textColor: textColor,
      ),
    );
  }
}

class MyCustomChip extends StatelessWidget {
  const MyCustomChip({
    Key? key,
    required this.chipColor,
    required this.chipString,
    required this.textColor,
    this.extraPadding,
  }) : super(key: key);

  final Color chipColor;
  final String chipString;
  final Color textColor;
  final EdgeInsets? extraPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 4,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 4,
        ),
        decoration: new BoxDecoration(
          color: chipColor,
          borderRadius: new BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Padding(
          padding: extraPadding ?? EdgeInsets.all(0),
          child: Text(
            chipString,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
