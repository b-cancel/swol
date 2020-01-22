//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/simple/ourInformationPopUp.dart';

//display function
infoPopUpFunction(
  BuildContext context, 
  {
    @required title,
    subtitle: "",
    @required body,
    isDense: false,
  }){
  showInformationPopUp(
    context,
    Icon(
      Icons.info,
      color: Colors.blue,
      //NOTE: not actual size but will take to max size
      size: 128,
    ),
    [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black,
        ),
      ),
      subtitle == null ? Container() : Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
        ),
        child: Theme(
          data: ThemeData.dark(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: body,
          ),
        ),
      ),
    ],
    iconPadding: false,
    isDense: isDense,
  );
}

class HeaderWithInfo extends StatelessWidget {
  const HeaderWithInfo({
    Key key,
    @required this.title,
    @required this.popUpFunction,
    this.subtle: false,
  }) : super(key: key);

  final String title;
  final Function popUpFunction;
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Transform.translate(
          offset: Offset(12, 0),
          child: IconButton(
            onPressed: () => popUpFunction(),
            icon: Icon(Icons.info),
            color: subtle ? Theme.of(context).primaryColor :  Theme.of(context).accentColor,
          ),
        )
      ],
    );
  }
}