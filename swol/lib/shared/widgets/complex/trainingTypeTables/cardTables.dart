import 'package:flutter/material.dart';

class CardTable extends StatelessWidget {
  CardTable({
    @required this.height,
    @required this.items,
    this.highlightField,
    this.persistent: false,
    this.icon,
  });

  final double height;
  final List<String> items;
  final int highlightField;
  final bool persistent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    Color accentColor = Colors.blue; //todo replace for the current theme color
    Color colorEven = Theme.of(context).scaffoldBackgroundColor; 
    Color colorOdd = Theme.of(context).primaryColor;

    //build the fields
    List<Widget> buildFields = new List<Widget>();
    for(int i = 0; i < items.length; i++){
      bool isHeader = i == 0;

      //get field color
      Color fieldColor;
      if(i == highlightField) fieldColor = accentColor;
      else{
        if(isHeader) fieldColor = accentColor;
        else{
          if(i%2==0) fieldColor = colorEven;
          else fieldColor = colorOdd;
        }
      }

      //get icon widget
      Widget iconWidget = (isHeader && icon != null) ? Padding(
        padding: EdgeInsets.only(
          right: 8,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),
      ) : Container();

      //add this field
      buildFields.add(
        Expanded(
          child: Container(
            color: fieldColor,
            alignment: Alignment.centerLeft,
            //non persistent ones span the carousel width
            width: persistent ? null : MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 8,
              ),
              child: Row(
                children: <Widget>[
                  iconWidget,
                  Text(
                    items[i],
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: (persistent || i == 0 || i == highlightField) 
                      ? FontWeight.bold : FontWeight.normal,
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