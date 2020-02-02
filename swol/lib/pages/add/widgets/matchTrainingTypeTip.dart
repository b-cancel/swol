//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal
import 'package:swol/shared/widgets/simple/ourSnackBar.dart';

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

enum TrainingID {
  Endurance, //
  EnduranceAndHypertrophy, 
  Hypertrophy, //
  HypertrophyAndStrength,
  Strength, //
  StrengthAndEndurance,
  //all of them (end, hype, str)
  All,
}

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

  bool oneOfThemIs(TrainingID a, TrainingID b, TrainingID val){
    bool aIs = (a == val);
    bool bIs = (b == val);
    return aIs || bIs;
  }

  bool trainingIDsEqual(TrainingID a, TrainingID b){
    if(a == b) return true;
    else{ //overlaps also count as matching
      //if either cover all 3 trainings then there is an obvious match
      if(a == TrainingID.All || b == TrainingID.All) return true;
      else{ 
        //neither of them cover all scenarios
        bool oneEndurance = oneOfThemIs(a, b, TrainingID.Endurance);
        bool oneHypertrohpy = oneOfThemIs(a, b, TrainingID.Hypertrophy);
        bool oneStrength = oneOfThemIs(a, b, TrainingID.Strength);

        //only if there are overlaps is it possible still be equal
        if(oneOfThemIs(a, b, TrainingID.EnduranceAndHypertrophy)){
          return (oneEndurance || oneHypertrohpy);
        }
        else if(oneOfThemIs(a, b, TrainingID.HypertrophyAndStrength)){
          return (oneHypertrohpy || oneStrength);
        }
        else if(oneOfThemIs(a, b, TrainingID.StrengthAndEndurance)){
          return (oneStrength || oneEndurance);
        }
        else return false;
      }
    }
  }

  showTheTip(String message){
    updateableTipMessage.value = message;
    widget.tipIsShowing.value = true;
    openSnackBar(
      context, 
      Colors.yellow, 
      FontAwesomeIcons.solidLightbulb,
      updatingMessage: updateableTipMessage,
      dismissible: false,
      showForever: true,
    );
  }

  updateTheTip(String message){
    updateableTipMessage.value = message;
  }

  hideTheTip(){
    if(updateableTipMessage.value != ""){
      updateableTipMessage.value = "";
      widget.tipIsShowing.value = false;
      Scaffold.of(context).hideCurrentSnackBar();
    }
  }

  updateTip(){
    //handle recovery period
    Duration currRecovery = widget.recoveryPeriod.value;
    TrainingID recoveryID;
    if(currRecovery <= Duration(minutes: 1)){
      recoveryID = TrainingID.Endurance;
    }
    else{
      if(currRecovery <= Duration(minutes: 2)){
        recoveryID = TrainingID.Hypertrophy;
      }
      else if(currRecovery <= Duration(minutes: 3)){
        recoveryID = TrainingID.HypertrophyAndStrength;
      }
      else{
        recoveryID = TrainingID.Strength;
      }
    }

    //handle set target
    int currSetTar = widget.setTarget.value;
    TrainingID setTargetID;
    if(1 <= currSetTar && currSetTar <= 3){
      setTargetID = TrainingID.Endurance;
    }
    if(3 <= currSetTar && currSetTar <= 5){
      if(setTargetID == null) setTargetID = TrainingID.Hypertrophy;
      else setTargetID = TrainingID.EnduranceAndHypertrophy;
    }
    if(4 <= currSetTar && currSetTar <= 6){
      if(setTargetID == null) setTargetID = TrainingID.Strength;
      else if(setTargetID == TrainingID.Hypertrophy) setTargetID = TrainingID.HypertrophyAndStrength;
      else setTargetID = TrainingID.All;
    }

    //handle rep target
    int currRepTar = widget.repTarget.value;
    TrainingID repTargetID;
    if(currRepTar <= 6) repTargetID = TrainingID.Strength;
    else if(currRepTar <= 12) repTargetID = TrainingID.Hypertrophy;
    else repTargetID = TrainingID.Endurance;

    //find matches
    bool recoveryANDsetTarget = trainingIDsEqual(
      recoveryID,
      setTargetID,
    );
    bool setTargetANDrepTarget = trainingIDsEqual(
      setTargetID,
      repTargetID,
    );
    bool repTargetANDrecovery = trainingIDsEqual(
      repTargetID,
      recoveryID,
    );

    //show tip if needed
    int matches = 0;
    matches += (recoveryANDsetTarget) ? 1 : 0;
    matches += (setTargetANDrepTarget) ? 1 : 0;
    matches += (repTargetANDrecovery) ? 1 : 0;
    if(matches == 3) hideTheTip();
    else{ //none of them are 3, so no 3 things are matching (at most 2)
      //NOTE: because set target can be 2 types of training at the same time
      //we can still match my transitive property
      //EX: recovery time(end) && set target (end,hype) && rep target (hype)
      //so we cover this edge case here
      //NOTE: we also assume that it maybe be possible in the future
      //for any of the other 2 setting to work the same way
      if(matches == 2) hideTheTip();
      else{
        String tipText = "Recovery Time, Set Target, and Rep Target\n"
        + "should have matching training types\n";

        //if nothing matches well... tell em
        if(matches == 0){
          tipText += "but none of them share the same one";
        }
        else{ //2 match so point out the odd man out
          String settingToChange;
          if(recoveryANDsetTarget) settingToChange = "Rep Target";
          else if(setTargetANDrepTarget) settingToChange = "Recovery Time";
          else settingToChange = "Set Target";

          tipText += "but " + settingToChange + " doesn't match the others";
        }

        //show or update
        if(updateableTipMessage.value == "") showTheTip(tipText);
        else updateTheTip(tipText);
      }
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

class TipSpacing extends StatefulWidget {
  const TipSpacing({
    @required this.tipIsShowing,
    Key key,
  }) : super(key: key);

  final ValueNotifier<bool> tipIsShowing;

  @override
  _TipSpacingState createState() => _TipSpacingState();
}

class _TipSpacingState extends State<TipSpacing> {
  updateState(){
    if(mounted) setState(() {});
  }

  @override
  void initState() { 
    widget.tipIsShowing.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() { 
    widget.tipIsShowing.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.tipIsShowing.value ? 56.0 + 16 + 8 : 0,
      width: MediaQuery.of(context).size.width,
    );
  }
}