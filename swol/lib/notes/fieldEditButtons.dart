import 'package:flutter/material.dart';

class FieldEditButtons extends StatelessWidget {
  FieldEditButtons({
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
            : _BigButton(
              onPressed: () => onPressTop(), 
              icon: topIcon, 
              buttonColor: buttonColor, 
              iconColor: iconColor,
            ),
            (twoButtons == false) ? Container() 
            : _ButtonSpacer(isDark: darkButtons == false),
            _BigButton(
              onPressed: () => onPressBottom(),
              icon: bottomIcon,  
              buttonColor: buttonColor, 
              iconColor: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  const _BigButton({
    Key key,
    @required this.onPressed,
    @required this.buttonColor,
    @required this.icon,
    @required this.iconColor,
  }) : super(key: key);

  final Function onPressed;
  final Color buttonColor;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        onPressed: () => onPressed(),
        padding: EdgeInsets.all(0),
        color: buttonColor,
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}

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