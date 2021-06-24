//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:auto_size_text/auto_size_text.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';

//widget
class CardTable extends StatelessWidget {
  CardTable({
    required this.height,
    required this.items,
    required this.cardBackground,
    this.highlightField,
    this.persistent: false,
    this.icon,
  });

  final double height;
  final List<String> items;
  final bool cardBackground;
  final int highlightField;
  final bool persistent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    Color accentColor = Theme.of(context).accentColor;
    Color colorEven = cardBackground
        ? Theme.of(context).scaffoldBackgroundColor
        : Theme.of(context).cardColor;
    Color colorOdd = Theme.of(context).primaryColor;

    //build the fields
    List<Widget> buildFields = [];
    for (int i = 0; i < items.length; i++) {
      bool isHeader = i == 0;

      //get field color
      Color fieldColor;
      if (i == highlightField)
        fieldColor = accentColor;
      else {
        if (isHeader)
          fieldColor = accentColor;
        else {
          if (i % 2 == 0)
            fieldColor = colorEven;
          else
            fieldColor = colorOdd;
        }
      }

      //Widget text portion
      Widget fieldText = Text(
        items[i],
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: TextStyle(
          color: Colors.white,
          fontWeight: (persistent || i == 0 || i == highlightField)
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      );

      //add this field
      buildFields.add(
        Expanded(
          child: Container(
            color: fieldColor,
            alignment: Alignment.centerLeft,
            //non persistent ones span the carousel width
            width: persistent ? null : MediaQuery.of(context).size.width,
            child: Padding(
              //persitent ones need a little extra space
              padding: EdgeInsets.only(
                left: persistent ? 16 : 8,
                right: 8,
              ),
              child: Row(
                children: <Widget>[
                  Visibility(
                    visible: (isHeader && icon != null),
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 8,
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  //todo: perhaps fitted box .contains
                  Conditional(
                    condition: persistent,
                    ifTrue: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.contain,
                      child: fieldText,
                    ),
                    ifFalse: Flexible(
                      child: fieldText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    //output the fields in their card
    Radius cardRadius = Radius.circular(24);
    return Padding(
      padding: EdgeInsets.symmetric(
        //non persistent have a little gap between them
        //to make it obvious you can scroll betweenthem
        horizontal: (persistent) ? 0 : 6,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: cardRadius,
          bottomRight: cardRadius,
          //persistent should look like they are attach to the screen edges
          topLeft: persistent ? Radius.zero : cardRadius,
          bottomLeft: persistent ? Radius.zero : cardRadius,
        ),
        child: Container(
          height: height,
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildFields,
            ),
          ),
        ),
      ),
    );
  }
}
