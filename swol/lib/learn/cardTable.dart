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
  });

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    List<Widget> buildFields = new List<Widget>();
    for(int i = 0; i < items.length; i++){
      Color fieldColor;
      if(i == 0) fieldColor = Theme.of(context).accentColor;
      else{
        if(i%2==0) fieldColor = Theme.of(context).cardColor;
        else fieldColor = Theme.of(context).primaryColor.withOpacity(0.5);
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
                        color: (i == 0) ? Colors.black : Colors.white,
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
        color: Theme.of(context).cardColor,
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
  });

  final List<String> items;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    List<Widget> buildFields = new List<Widget>();
    for(int i = 0; i < items.length; i++){
      Color fieldColor;
      if(i == 0) fieldColor = Theme.of(context).accentColor;
      else{
        if(i%2==0) fieldColor = Theme.of(context).cardColor;
        else fieldColor = Theme.of(context).primaryColor.withOpacity(0.5);
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
                      right: 4,
                    ),
                    child: Icon(
                      icon,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                  ),
                  Text(
                    items[i],
                    style: TextStyle(
                      color: (i == 0) ? Colors.black : Colors.white,
                      fontWeight: (i == 0) ? FontWeight.bold : FontWeight.normal,
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
          height: 256, //TODO: instead of havin to manually pass this do thing automatically
          color: Theme.of(context).cardColor,
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