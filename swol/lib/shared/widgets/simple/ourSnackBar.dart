//flutter
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'ourToolTip.dart';

//standard UI
//used by 1. name when only 1 is editable at a time to tell users then need a name (should barely ever happen)
//used by 2. one rep max chip (chips stacking no big deal)
//used by 3. used by reference link to tell the user the link navigation didnt work
openSnackBar(
  BuildContext context,
  Color color,
  IconData icon, {
  bool dismissBeforeShow: true,
  bool quickDismissBeforeShow: false,
  bool dismissible: true,
  bool showForever: false,
  //main
  String message: "",
  ValueNotifier<String>? updatingMessage,
}) {
  BotToast.cleanAll();

  showWidgetToolTip(
    context,
    SnackBarBody(
      icon: icon,
      color: color,
      updatingMessage: updatingMessage,
      message: message,
    ),
    seconds: 5,
    direction: PreferDirection.topCenter,
    color: Colors.white,
  );
}

class SnackBarBody extends StatelessWidget {
  const SnackBarBody({
    required this.icon,
    required this.color,
    this.updatingMessage,
    this.message,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final Color color;
  final ValueNotifier<String>? updatingMessage;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 6,
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.black,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 6,
              ),
              child: Icon(
                icon,
                size: 24.0,
                color: color,
              ),
            ),
            Flexible(
              child: updatingMessage == null
                  ? Text(message ?? "")
                  : UpdatingText(updatingText: updatingMessage!),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdatingText extends StatefulWidget {
  UpdatingText({
    required this.updatingText,
  });

  final ValueNotifier<String> updatingText;

  @override
  _UpdatingTextState createState() => _UpdatingTextState();
}

class _UpdatingTextState extends State<UpdatingText> {
  updateState() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.updatingText.addListener(updateState);
  }

  @override
  void dispose() {
    widget.updatingText.addListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.updatingText.value,
    );
  }
}
