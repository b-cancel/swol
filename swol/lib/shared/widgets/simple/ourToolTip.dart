//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:bot_toast/bot_toast.dart';

//checked for text size modification
showWidgetToolTip(BuildContext context, Widget widget, {
  int seconds: 4,
  PreferDirection direction: PreferDirection.topRight,
}){
  BotToast.showAttachedWidget(
    enableSafeArea: true,
    attachedBuilder: (_){
      return Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget,
        ),
      );
    },
    duration: Duration(seconds: seconds),
    targetContext: context,
    onlyOne: true,
    preferDirection: direction,
  );
}

//function
//TODO: check this
showToolTip(BuildContext context, String text, {
  PreferDirection direction: PreferDirection.topRight,
  bool showIcon: true,
}){
  BotToast.showAttachedWidget(
    enableSafeArea: true,
    attachedBuilder: (_) => OurToolTip(
      text: text,
      showIcon: showIcon,
    ),
    duration: Duration(seconds: 3),
    targetContext: context,
    onlyOne: true,
    preferDirection: direction,
  );
}

//widget
class OurToolTip extends StatelessWidget {
  const OurToolTip({
    Key key,
    @required this.text,
    @required this.showIcon,
  }) : super(key: key);

  final String text;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        BotToast.cleanAll();
      },
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //NOTE: the reason we may need to take out the icon later...
            //if the widget overflows the rest of the warning won't show
            //and ofcourse its more important that it shows than anything else
            Visibility(
              visible: showIcon,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                ),
                child: Icon(
                  Icons.warning,
                  size: 24,
                ),
              ),
            ),
            //this is what's actually important
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flexible(
                child: Text(
                  text,
                  maxLines: 3,
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}