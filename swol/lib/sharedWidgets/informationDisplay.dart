import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

infoPopUpFunction(
  BuildContext context, 
  {
    @required title,
    subtitle: "",
    @required body,
    isDense: false,
  }){
    //unfocus so whatever was focused before doesnt annoying scroll us back
    FocusScope.of(context).unfocus();

    //show awesome dialog
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: true,
      animType: AnimType.SCALE,
      customHeader: ClipOval(
      child: Container(
        color: Colors.white,
          //NOTE: 28 is the max
          padding: EdgeInsets.all(0),
          child: FittedBox(
            fit: BoxFit.fill,
            child: Icon(
              Icons.info,
              color: Colors.blue,
              //NOTE: not actual size but will take to max size
              size: 128,
            ),
          ),
        ),
      ),
      isDense: isDense, //is dense true is slightly larger
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
      ),
    ).show();
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