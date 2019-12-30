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
      dialogType: DialogType.INFO,
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
  }) : super(key: key);

  final String title;
  final Function popUpFunction;

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
            color: Theme.of(context).accentColor,
          ),
        )
      ],
    );
  }
}