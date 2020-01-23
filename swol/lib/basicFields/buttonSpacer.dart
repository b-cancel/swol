import 'package:flutter/material.dart';

class OneOrTwoButtons extends StatelessWidget {
  OneOrTwoButtons({
    @required this.darkButtons,
    @required this.onPressTop,
    @required this.topIcon,
    @required this.twoButtons,
    @required this.onPressBottom,
    @required this.bottomIcon,
  });

  final bool darkButtons;
  final Function onPressTop;
  final IconData topIcon;
  final bool twoButtons;
  final Function onPressBottom;
  final IconData bottomIcon;

  @override
  Widget build(BuildContext context) {
    Color buttonColor = darkButtons ? Theme.of(context).primaryColor : Theme.of(context).accentColor;
    Color iconColor = darkButtons == false ? Theme.of(context).primaryColor : Colors.white;
    return IntrinsicWidth(
      child: Container(
        color: buttonColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            (twoButtons == false) ? Container()
            : Expanded(
              child: FlatButton(
                onPressed: () => onPressTop(),
                padding: EdgeInsets.all(0),
                color: buttonColor,
                child: Icon(
                  topIcon,
                  color: iconColor,
                ),
              ),
            ),
            (twoButtons == false) ? Container() 
            : _ButtonSpacer(isDark: darkButtons == false),
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.all(0),
                color: buttonColor,
                onPressed: () => onPressBottom(),
                child: Icon(
                  bottomIcon,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
onPressed: (){
              widget.url.value = "";
              isEditing.value = false;
            },
            child: Container(
              padding: EdgeInsets.all(0),
              child: (widget.url.value == "") 
              ? Container()
              : Icon(Icons.close),
            )
*/

/*
  onPressed: (){
            isEditing.value = !isEditing.value;
          },
          child: Icon(
            (isEditing.value) ? Icons.check : Icons.edit,
            color: Theme.of(context).primaryColorDark,
          ),
*/

class _ButtonSpacer extends StatelessWidget {
  _ButtonSpacer({
    @required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Container(
        color: isDark ? Theme.of(context).primaryColorDark : Theme.of(context).cardColor,
        height: 2,
        child: Container(),
      ),
    );
  }
}