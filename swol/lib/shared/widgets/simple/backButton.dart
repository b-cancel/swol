import 'package:flutter/material.dart';
import 'package:swol/excerciseListTile/titleHero.dart';
import 'package:swol/main.dart';

class BackFromExcercise extends StatelessWidget {
  BackFromExcercise({
    this.excerciseIDTag,
  });

  final int excerciseIDTag;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: IconButton(
        icon: ExcerciseBegin(
          inAppBar: true,
          excerciseIDTag: excerciseIDTag,
        ),
        color: Theme.of(context).iconTheme.color,
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () {
          FocusScope.of(context).unfocus();

          //we only unspread from the page and not comming back from notes
          if(excerciseIDTag != null) App.navSpread.value = false;
        
          Navigator.of(context).pop();
        },
      ),
    );
  }
}