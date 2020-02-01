import 'package:flutter/material.dart';

class PersistentCardTable extends StatelessWidget {
  PersistentCardTable({
    @required this.items,
    this.highlightField,
  });

  final List<String> items;
  final int highlightField;

  @override
  Widget build(BuildContext context) {
    Color accentColor = Colors.blue;
    Color titleColor = Colors.white;
    Color otherColor = Colors.white; 
    Color backgroudColor = Theme.of(context).primaryColor; 

    //alternating colors
    Color colorEven = Theme.of(context).scaffoldBackgroundColor; 
    Color colorOdd = Theme.of(context).primaryColor;

    List<Widget> buildFields = new List<Widget>();
    for(int i = 0; i < items.length; i++){
      Color fieldColor;
      if(i == highlightField) fieldColor = accentColor;
      else{
        if(i == 0) fieldColor = accentColor;
        else{
          if(i%2==0) fieldColor = colorEven;
          else fieldColor = colorOdd;
        }
      }

      buildFields.add(
        Expanded(
          child: Container(
            color: fieldColor,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 8,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      items[i],
                      style: TextStyle(
                        color: (i == 0) ? titleColor : otherColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      child: Container(
        height: 256, 
        color: backgroudColor,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildFields,
          ),
        ),
      ),
    );
  }
}

class CardTable extends StatelessWidget {
  CardTable({
    @required this.items,
    @required this.icon,
    this.highlightField,
  });

  final List<String> items;
  final IconData icon;
  final int highlightField;

  @override
  Widget build(BuildContext context) {
    Color accentColor = Colors.blue;
    Color titleColor = Colors.white;
    Color otherColor = Colors.white;
    Color backgroudColor = Theme.of(context).primaryColor; 

    //alternating colors
    Color colorEven = Theme.of(context).scaffoldBackgroundColor;
    Color colorOdd = Theme.of(context).primaryColor;

    List<Widget> buildFields = new List<Widget>();
    for(int i = 0; i < items.length; i++){
      Color fieldColor;
      if(i == highlightField) fieldColor = accentColor;
      else{
        if(i == 0) fieldColor = accentColor;
        else{
          if(i%2==0) fieldColor = colorEven;
          else fieldColor = colorOdd;
        }
      }

      buildFields.add(
        Expanded(
          child: Container(
            color: fieldColor,
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              left: 16,
              right: 8,
              top: (i == 0) ? 4 : 8,
              bottom: (i == 0) ? 4 : 8,
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Row(
                children: <Widget>[
                  (i != 0) ? Container() : 
                  Padding(
                    padding: EdgeInsets.only(
                      right: 8,
                    ),
                    child: Icon(
                      icon,
                      color: titleColor,
                      size: 16,
                    ),
                  ),
                  Text(
                    items[i],
                    style: TextStyle(
                      color: (i == 0) ? titleColor : otherColor,
                      fontWeight: (i == 0 || i == highlightField) ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        right: 16
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 256, 
          color: backgroudColor,
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