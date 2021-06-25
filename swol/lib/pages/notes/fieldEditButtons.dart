import 'package:flutter/material.dart';

//NOTE: eventhough this is only used for a shared widget
//the shared widget uses it ONLY for the notes section
class FieldEditButtons extends StatelessWidget {
  FieldEditButtons({
    required this.darkButtons,
    required this.onPressTop,
    required this.topIcon,
    required this.showTopButton,
    required this.onPressBottom,
    required this.bottomIcon,
  });

  final bool darkButtons;
  final Function onPressTop;
  final IconData topIcon;
  final bool showTopButton;
  final Function onPressBottom;
  final IconData bottomIcon;

  @override
  Widget build(BuildContext context) {
    Color buttonColor = darkButtons
        ? Theme.of(context).primaryColor
        : Theme.of(context).accentColor;
    Color iconColor =
        (darkButtons == false) ? Theme.of(context).primaryColor : Colors.white;
    return IntrinsicWidth(
      child: Container(
        color: buttonColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            (showTopButton)
                ? _TopButton(
                    onPressTop: onPressTop,
                    buttonColor: buttonColor,
                    topIcon: topIcon,
                    iconColor: iconColor,
                    darkButtons: darkButtons,
                  )
                : Container(),
            Expanded(
              child: TextButton(
                onPressed: () => onPressBottom(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  //TODO: confirm this is creates the intended effect
                  primary: buttonColor,
                ),
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

class _TopButton extends StatelessWidget {
  const _TopButton({
    Key? key,
    required this.onPressTop,
    required this.buttonColor,
    required this.topIcon,
    required this.iconColor,
    required this.darkButtons,
  }) : super(key: key);

  final Function onPressTop;
  final Color buttonColor;
  final IconData topIcon;
  final Color iconColor;
  final bool darkButtons;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: TextButton(
              onPressed: () => onPressTop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(0),
                //TODO: confirm this is creates the intended effect
                primary: buttonColor,
              ),
              child: Icon(
                topIcon,
                color: iconColor,
              ),
            ),
          ),
          _ButtonSpacer(isDark: darkButtons == false)
        ],
      ),
    );
  }
}

class _ButtonSpacer extends StatelessWidget {
  _ButtonSpacer({
    required this.isDark,
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
        color: isDark
            ? Theme.of(context).primaryColorDark
            : Theme.of(context).cardColor,
        height: 2,
        child: Container(),
      ),
    );
  }
}
