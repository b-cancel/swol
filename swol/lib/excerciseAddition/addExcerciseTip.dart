//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal
import 'package:swol/sharedWidgets/ourSnackBar.dart';

/*
at all times we are trying to help the user
every user is going to get the best results by focusing on 1 of the 3 types of training 
so we help them do that

When any mismatch
"In order to get the fastest results, you should use the suggested"
"Eecovery Time, Set target, and Rep target"
"for ONE type of training"

When all mismatch (ideally)
"To Get Strong use Strength Training"
"To Get Big use Hypertrophy Training"
"To Get Agile use Endurance Training"

When 1 mismatch (ideally)
"To make them all match change the XXX value to be within YYY Training Range"
*/

class TipGenerator extends StatefulWidget {
  TipGenerator({
    @required this.tipIsShowing,
    @required this.recoveryPeriod,
    @required this.setTarget,
    @required this.repTarget,
    Key key,
  }) : super(key: key);

  final ValueNotifier<bool> tipIsShowing;
  final ValueNotifier<Duration> recoveryPeriod;
  final ValueNotifier<int> setTarget;
  final ValueNotifier<int> repTarget;

  @override
  _TipGeneratorState createState() => _TipGeneratorState();
}

class _TipGeneratorState extends State<TipGenerator> {
  ValueNotifier<String> updateableTipMessage;

  showTheTip(String message){
    updateableTipMessage.value = message;
    widget.tipIsShowing.value = true;
    openSnackBar(
      context, 
      Colors.yellow, 
      FontAwesomeIcons.solidLightbulb,
      message: message,
      dismissible: false,
      showForever: true,
    );
  }

  updateTheTip(String message){
    print("updating the tip");
    updateableTipMessage.value = message;
  }

  hideTheTip(){
    updateableTipMessage.value = "";
    widget.tipIsShowing.value = false;
    Scaffold.of(context).hideCurrentSnackBar();
  }

  updateTip(){
    int endurance = 0;
    int hypertrophy = 0;
    int strength = 0;

    //handle recovery period
    Duration currRecovery = widget.recoveryPeriod.value;
    if(currRecovery <= Duration(minutes: 1)){
      endurance++;
    }
    else{
      if(currRecovery <= Duration(minutes: 2)){
        hypertrophy++;
      }
      else if(currRecovery <= Duration(minutes: 3)){
        hypertrophy++;
        strength++;
      }
      else{
        strength++;
      }
    }

    //handle set target
    int currSetTar = widget.setTarget.value;
    if(1 <= currSetTar && currSetTar <= 3) endurance++; //1,2,3
    if(3 <= currSetTar && currSetTar <= 5) hypertrophy++; //3,4,5
    if(4 <= currSetTar && currSetTar <= 6) strength++; //4,5,6

    //handle rep target
    int currRepTar = widget.repTarget.value;
    if(currRepTar <= 6) strength++;
    else if(currRepTar <= 12) hypertrophy++;
    else endurance++;

    //show tip if needed
    if(endurance == 3 || hypertrophy == 3 || strength == 3){
      //a message was shown
      if(updateableTipMessage.value != "") hideTheTip();
    }
    else{
      String tipText = "Recovery Time, Set Target, and Rep Target\n"
      + "should have matching training types";

      if(updateableTipMessage.value == "") showTheTip(tipText);
      else updateTheTip(tipText + DateTime.now().toString());
    }
  }

  @override
  void initState() {
    updateableTipMessage = new ValueNotifier("");

    //handle listeners
    widget.recoveryPeriod.addListener(updateTip);
    widget.setTarget.addListener(updateTip);
    widget.repTarget.addListener(updateTip);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.recoveryPeriod.removeListener(updateTip);
    widget.setTarget.removeListener(updateTip);
    widget.repTarget.removeListener(updateTip);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}