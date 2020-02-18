import 'package:flutter/material.dart';
import 'package:swol/action/tabs/recovery/secondary/timeDisplay.dart';

//utility (max is 9:59 but we indicate we are maxed out with 9:99)
List<String> durationToCustomDisplay(Duration duration){
  String only1stDigit = "0";
  String always2Digits = "00";

  if(duration > Duration.zero){
    //seperate minutes
    int minutes = duration.inMinutes;

    //9 minutes or less have passed (still displayable)
    if(minutes <= 9){
      only1stDigit = minutes.toString(); //9 through 0

      //remove minutes so only seconds left
      duration = duration - Duration(minutes: minutes);

      //seperate seconds
      int seconds = duration.inSeconds;
      always2Digits = seconds.toString(); //0 through 59

      //anything less than 10
      if(always2Digits.length < 2){ //0 -> 9
        always2Digits = "0" + always2Digits;
      }
      //ELSE: 10 -> 59
    }
    else{
      only1stDigit = "9";
      always2Digits = "99";
    }
  }

  return [only1stDigit, always2Digits];
}

class OnlyEditButton extends StatelessWidget {
  const OnlyEditButton({
    Key key,
    @required this.durationString,
  }) : super(key: key);

  final String durationString;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: DefaultTextStyle(
          style: TextStyle(
            color: Theme.of(context)
                .primaryColorDark,
          ),
          child: EditIcon(
            text: durationString,
            roundedRight: true,
          ),
        ),
      ),
    );
  }
}