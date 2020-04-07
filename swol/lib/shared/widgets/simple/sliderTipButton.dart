//flutter
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/simple/ourToolTip.dart';

//slider tip button
class SlideRangeExtent extends StatelessWidget {
  const SlideRangeExtent({
    @required this.buttonText,
    this.tipText,
    this.tipToLeft: true,
    Key key,
  }) : super(key: key);

  final String buttonText;
  final String tipText;
  final bool tipToLeft;

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
        horizontal: (tipText == null) ? 0.0 : 4.0,
        vertical: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          (tipText == null) ? Container()
          : Padding(
            padding: const EdgeInsets.only(
              right: 4.0,
            ),
            child: Icon(
              Icons.warning,
              color: Theme.of(context).primaryColorDark,
              size: 16,
            ),
          ),
          Text(
            buttonText,
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
          )
        ],
      ),
    );
    
    if(tipText == null) return mainButton;
    else{
      return InkWell(
        onTap: (){
          showWidgetToolTip(
            context, 
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: tipToLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    
                    tipText,
                    textAlign: tipToLeft ? TextAlign.left : TextAlign.right,
                  ),
                )
              ],
            ),
            direction: tipToLeft ? PreferDirection.topLeft : PreferDirection.topRight,
          );
        },
        child: mainButton,
      );
    }
  }
}