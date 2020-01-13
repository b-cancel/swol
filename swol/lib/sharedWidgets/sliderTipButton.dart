//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:swol/sharedWidgets/ourToolTip.dart';

//slider tip button
class SliderTipButton extends StatelessWidget {
  const SliderTipButton({
    @required this.buttonText,
    this.tipText,
    Key key,
  }) : super(key: key);

  final String buttonText;
  final String tipText;

  @override
  Widget build(BuildContext context) {
    Widget mainButton = Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: (tipText == null) ? Colors.transparent : Theme.of(context).primaryColorDark,
          width: 2,
        )
      ),
      padding: EdgeInsets.symmetric(
        horizontal: (tipText == null) ? 0 : 4,
        vertical: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          (tipText == null) ? Container()
          : Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ),
            child: Icon(
              Icons.warning,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          Text(buttonText)
        ],
      ),
    );
    
    if(tipText == null) return mainButton;
    else{
      return InkWell(
        onTap: () => showToolTip(context, tipText),
        child: mainButton,
      );
    }
  }
}