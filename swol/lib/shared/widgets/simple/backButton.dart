import 'package:flutter/material.dart';
import 'package:swol/main.dart';

class BackFromExcercise extends StatelessWidget {
  BackFromExcercise({
    this.unSpread: false,
  });

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

          //we only unspread from the page and not comming back from notes
          if(unSpread) App.navSpread.value = false;
        
          Navigator.of(context).pop();
        },
      ),
    );
  }
}