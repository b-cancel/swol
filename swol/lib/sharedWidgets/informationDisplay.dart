import 'package:flutter/material.dart';

class HeaderWithInfo extends StatelessWidget {
  const HeaderWithInfo({
    Key key,
    @required this.title,
    @required this.popUp,
  }) : super(key: key);

  final String title;
  final Widget popUp;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Transform.translate(
          offset: Offset(12, 0),
          child: IconButton(
            onPressed: (){
              showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return popUp; 
                },
              );
            },
            icon: Icon(Icons.info),
            color: Theme.of(context).accentColor,
          ),
        )
      ],
    );
  }
}

class MyInfoDialog extends StatelessWidget {
  const MyInfoDialog({
    @required this.title,
    this.subtitle: "",
    @required this.child,
    Key key,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: SimpleDialog(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                right: 4,
              ),
              child: Icon(
                Icons.info,
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(title),
                  ),
                  (subtitle == "") ? Container()
                  : Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(0, -12),
              child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
            )
          ],
        ),
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: child,
          ),
        ],
      ),
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 8,
      ),
      child: Divider(
        height: 0,
      ),
    );
  }
}