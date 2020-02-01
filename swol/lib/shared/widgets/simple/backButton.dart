import 'package:flutter/material.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/widgets/simple/heros/leading.dart';
import 'package:swol/main.dart';

class BackFromExcercise extends StatelessWidget {
  BackFromExcercise({
    this.excercise,
  });

  final AnExcercise excercise;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: IconButton(
        icon: ExcerciseBegin(
          inAppBar: true,
          excercise: excercise,
        ),
        color: Theme.of(context).iconTheme.color,
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () {
          FocusScope.of(context).unfocus();

          //we only unspread from the page and not comming back from notes
          if(excercise != null) App.navSpread.value = false;
        
          Navigator.of(context).pop();
        },
      ),
    );
  }
}