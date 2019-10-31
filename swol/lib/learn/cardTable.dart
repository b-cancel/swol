import 'package:flutter/material.dart';

class FunctionCardTable extends StatelessWidget {
  FunctionCardTable({
    @required this.context,
  });

  final BuildContext context;

  List<Widget> buildFields(List<String> items){
    List<Widget> buildFields = new List<Widget>();

    for(int i = 0; i < items.length; i++){
      Color fieldColor;
      if(i == 0) fieldColor = Theme.of(context).accentColor;
      else{
        if(i%2==0) fieldColor = Theme.of(context).cardColor;
        else fieldColor = Theme.of(context).primaryColor.withOpacity(0.5);
      }

      buildFields.add(
        Container(
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
              child: Text(
                items[i],
                style: TextStyle(
                  color: (i == 0) ? Colors.black : Colors.white,
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
          Expanded(
            child: Container(
              color: Theme.of(context).cardColor,
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildFields([
                    "Limitation Level",
                    "8",
                    "7",
                    "6",
                    "5",
                    "4",
                    "3",
                    "2",
                    "1 Professional Athlete",
                  ]),
                ),
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

class PersistentCardTable extends StatelessWidget {
  PersistentCardTable({
    @required this.items,
    @required this.lightMode,
    this.highlightField,
  });

  final List<String> items;
  final bool lightMode;
  final int highlightField;

  @override
  Widget build(BuildContext context) {
    Color accentColor = (lightMode) ? Colors.blue : Theme.of(context).accentColor;
    Color titleColor = (lightMode) ? Colors.white : Theme.of(context).primaryColor; 
    Color otherColor = Colors.white; //(lightMode) ? Theme.of(context).primaryColor : 
    Color backgroudColor = Theme.of(context).primaryColor; //(lightMode) ? Colors.white : 

    //alternating colors
    Color colorEven = Theme.of(context).cardColor; //(lightMode) ? Colors.blue.withOpacity(0.5) : 
    Color colorOdd = Theme.of(context).primaryColor.withOpacity(0.5); //(lightMode) ? Colors.white : 

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
    @required this.lightMode,
    this.highlightField,
  });

  final List<String> items;
  final IconData icon;
  final bool lightMode;
  final int highlightField;

  @override
  Widget build(BuildContext context) {
    Color accentColor = (lightMode) ? Colors.blue : Theme.of(context).accentColor;
    Color titleColor = (lightMode) ? Colors.white : Theme.of(context).primaryColor; 
    Color otherColor = Colors.white; //(lightMode) ? Theme.of(context).primaryColor : 
    Color backgroudColor = Theme.of(context).primaryColor; //(lightMode) ? Colors.white : 

    //alternating colors
    Color colorEven = Theme.of(context).cardColor; //(lightMode) ? Colors.blue.withOpacity(0.5) : 
    Color colorOdd = Theme.of(context).primaryColor.withOpacity(0.5); //(lightMode) ? Colors.white : 

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
        //TODO: add expanded here to share space
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