//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:bot_toast/bot_toast.dart';

showToolTip(BuildContext context, String text){
  BotToast.showAttachedWidget(
    enableSafeArea: true,
    attachedBuilder: (_) => OurToolTip(text: text),
    duration: Duration(seconds: 3),
    targetContext: context,
    onlyOne: true,
    preferDirection: PreferDirection.topRight,
  );
}

class OurToolTip extends StatelessWidget {
  const OurToolTip({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //NOTE: the reason we may need to take out the icon later...

          //NOTE: we took out the icon because 
          //if the widget overflows the rest of the warning won't show
          //and ofcourse its more important that it shows than anything else
          
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
            ),
            child: Icon(
              Icons.warning,
              size: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              maxLines: 3,
            )
          ),
        ],
      ),
    );
  }
}