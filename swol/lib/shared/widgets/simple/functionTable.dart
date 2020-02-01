

import 'package:flutter/material.dart';

//widget
class FunctionCardTable extends StatelessWidget {
  FunctionCardTable({
    @required this.context,
    this.isDark: true,
    this.otherDark: false,
  });

  final BuildContext context;
  final bool isDark;
  final bool otherDark;

  List<Widget> buildFields(List<String> items, {bool leftAligned: true}){
    List<Widget> buildFields = new List<Widget>();

    for(int i = 0; i < items.length; i++){
      Color fieldColor;
      if(i == 0) fieldColor = (isDark) ? Theme.of(context).accentColor : Colors.blue;
      else{
        if(i%2==0) fieldColor = otherDark ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).cardColor;
        else fieldColor = Theme.of(context).primaryColor;
      }

      buildFields.add(
        Container(
          color: fieldColor,
          alignment: leftAligned ? Alignment.centerLeft : Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 8,
              ),
              child: Text(
                items[i],
                style: TextStyle(
                  color: (i == 0) 
                  ? ((isDark) ? Colors.black : Colors.white) 
                  : Colors.white,
                  fontWeight: (i == 0) ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return buildFields;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Row(
        children: <Widget>[
          Container(
            color: Theme.of(context).cardColor,
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buildFields([
                  "Limitation Level",
                  "BEGINNER 8",
                  "7",
                  "6",
                  "5",
                  "AVG 4",
                  "3",
                  "2",
                  "PRO 1",
                ], leftAligned: false),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).cardColor,
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildFields([
                    "Ability Formulas",
                    "Brzycki",
                    "McGlothin (or Landers)",
                    "Almazan *our own*",
                    "Epley (or Baechle)",
                    "O`Conner",
                    "Wathan",
                    "Mayhew",
                    "Lombardi",
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}