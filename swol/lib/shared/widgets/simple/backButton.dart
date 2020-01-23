import 'package:flutter/material.dart';

class BackFromExcercise extends StatelessWidget {
  const BackFromExcercise({
    Key key,
    this.unSpread: true,
  }) : super(key: key);

  final bool unSpread;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: IconButton(
        icon: Icon(Icons.chevron_left),
        color: Theme.of(context).iconTheme.color,
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}