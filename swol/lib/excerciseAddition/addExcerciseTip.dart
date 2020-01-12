import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TipGenerator extends StatefulWidget {
  TipGenerator({
    @required this.recoveryPeriod,
    @required this.setTarget,
    @required this.repTarget,
    Key key,
  }) : super(key: key);

  final ValueNotifier<Duration> recoveryPeriod;
  final ValueNotifier<int> setTarget;
  final ValueNotifier<int> repTarget;

  @override
  _TipGeneratorState createState() => _TipGeneratorState();
}

class _TipGeneratorState extends State<TipGenerator> {
  showFlushBar(String message){
    Flushbar(
      message: message,
      //icon pulsing is very distracting
      shouldIconPulse: false,
      //it should always show up after the user change some setting
      leftBarIndicatorColor: Colors.transparent,
      isDismissible: false, 
      duration: null,
      //color that are just distracting enough
      backgroundColor: Theme.of(context).primaryColorDark,
      borderColor: Theme.of(context).scaffoldBackgroundColor,
      //other
      icon: Icon(
        FontAwesomeIcons.solidLightbulb,
        size: 28.0,
        color: Colors.yellow,
      ),
      borderRadius: 16,
      margin: EdgeInsets.all(16), 
      //flushbar default styling
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
    )..show(context);
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
      String trainingSelected;
      if(endurance == 3) trainingSelected = "Endurance";
      else if(hypertrophy == 3) trainingSelected = "Hypertrohpy";
      else trainingSelected = "Strength";

      //show flushbar
      showFlushBar(trainingSelected + " Training Selected");
    }
    else{
      showFlushBar("MISMATCH");
    }
  }

  @override
  void initState() { 
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