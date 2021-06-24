//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';

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
    required this.tipIsShowing,
    required this.updateableTipMessage,
    required this.recoveryPeriod,
    required this.setTarget,
    required this.repTarget,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<bool> tipIsShowing;
  final ValueNotifier<String> updateableTipMessage;
  final ValueNotifier<Duration> recoveryPeriod;
  final ValueNotifier<int> setTarget;
  final ValueNotifier<int> repTarget;

  @override
  _TipGeneratorState createState() => _TipGeneratorState();
}

class _TipGeneratorState extends State<TipGenerator> {
  bool hasEndurance(TrainingID item) {
    if (item == TrainingID.All)
      return true;
    else if (item == TrainingID.Endurance)
      return true;
    else if (item == TrainingID.EnduranceAndHypertrophy)
      return true;
    else if (item == TrainingID.StrengthAndEndurance)
      return true;
    else
      return false;
  }

  bool hasHypertrohpy(TrainingID item) {
    if (item == TrainingID.All)
      return true;
    else if (item == TrainingID.EnduranceAndHypertrophy)
      return true;
    else if (item == TrainingID.Hypertrophy)
      return true;
    else if (item == TrainingID.HypertrophyAndStrength)
      return true;
    else
      return false;
  }

  bool hasStrength(TrainingID item) {
    if (item == TrainingID.All)
      return true;
    else if (item == TrainingID.StrengthAndEndurance)
      return true;
    else if (item == TrainingID.HypertrophyAndStrength)
      return true;
    else if (item == TrainingID.Strength)
      return true;
    else
      return false;
  }

  //rep target can only be endurance, hypertrophy, or strength
  bool otherMatchesRepTarget(TrainingID repTarget, TrainingID other) {
    if (repTarget == other)
      return true;
    else {
      //overlaps also count as matching
      //if either cover all 3 trainings then there is an obvious match
      if (repTarget == TrainingID.All || other == TrainingID.All)
        return true;
      else {
        if (repTarget == TrainingID.Endurance) {
          return hasEndurance(other);
        } else if (repTarget == TrainingID.Hypertrophy) {
          return hasHypertrohpy(other);
        } else {
          return hasStrength(other);
        }
      }
    }
  }

  showTheTip(String message) {
    widget.updateableTipMessage.value = message;
    widget.tipIsShowing.value = true;
    openSnackBar(
      context,
      Colors.yellow,
      FontAwesomeIcons.solidLightbulb,
      updatingMessage: widget.updateableTipMessage,
      dismissible: false,
      showForever: true,
    );
  }

  updateTheTip(String message) {
    widget.updateableTipMessage.value = message;
  }

  hideTheTip() {
    if (widget.updateableTipMessage.value != "") {
      widget.updateableTipMessage.value = "";
      widget.tipIsShowing.value = false;
      Scaffold.of(context).hideCurrentSnackBar();
    }
  }

  //NOTE: we want to make sure that
  //once the user selects their rep target
  //their set target and recovery period match
  //since ultimately the biggest factor is reps
  updateTip() {
    //handle recovery period
    Duration currRecovery = widget.recoveryPeriod.value;
    TrainingID recoveryID;
    if (currRecovery <= Duration(minutes: 1)) {
      recoveryID = TrainingID.Endurance;
    } else {
      if (currRecovery <= Duration(minutes: 2)) {
        recoveryID = TrainingID.Hypertrophy;
      } else if (currRecovery <= Duration(minutes: 3)) {
        recoveryID = TrainingID.HypertrophyAndStrength;
      } else {
        recoveryID = TrainingID.Strength;
      }
    }

    //handle set target
    int currSetTar = widget.setTarget.value;
    TrainingID setTargetID;
    if (1 <= currSetTar && currSetTar <= 3) {
      setTargetID = TrainingID.Endurance;
    }
    if (3 <= currSetTar && currSetTar <= 5) {
      if (setTargetID == null)
        setTargetID = TrainingID.Hypertrophy;
      else
        setTargetID = TrainingID.EnduranceAndHypertrophy;
    }
    if (4 <= currSetTar && currSetTar <= 6) {
      if (setTargetID == null)
        setTargetID = TrainingID.Strength;
      else if (setTargetID == TrainingID.Hypertrophy)
        setTargetID = TrainingID.HypertrophyAndStrength;
      else
        setTargetID = TrainingID.All;
    }

    //handle rep target
    int currRepTar = widget.repTarget.value;
    TrainingID repTargetID;
    if (currRepTar <= 6)
      repTargetID = TrainingID.Strength;
    else if (currRepTar <= 12)
      repTargetID = TrainingID.Hypertrophy;
    else
      repTargetID = TrainingID.Endurance;

    //find matches
    bool goodRecoveryTarget = otherMatchesRepTarget(
      repTargetID,
      recoveryID,
    );
    bool goodSetTarget = otherMatchesRepTarget(
      repTargetID,
      setTargetID,
    );

    //show tip if needed
    if (goodRecoveryTarget && goodSetTarget)
      hideTheTip();
    else {
      //NOTE: here we point out what change should be made
      String trainingType;
      if (repTargetID == TrainingID.Endurance) {
        trainingType = "Endurance";
      } else if (repTargetID == TrainingID.Hypertrophy) {
        trainingType = "Hypertrophy";
      } else
        trainingType = "Strength";

      //create tip text
      String tipText = "You Rep Target indicates" +
          " that you are doing " +
          trainingType +
          " Training\n" +
          "But you have the wrong ";

      //specifics
      if (goodRecoveryTarget == false && goodSetTarget == false) {
        tipText += "Recovery Period and Set Target";
      } else if (goodRecoveryTarget == false) {
        tipText += "Recovery Period";
      } else {
        tipText += "Set Target";
      }

      //finish
      tipText += " for that type of training";

      //show or update
      if (widget.updateableTipMessage.value == "") {
        showTheTip(tipText);
      } else {
        updateTheTip(tipText);
      }
    }
  }

  @override
  void initState() {
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
    required this.tipIsShowing,
    required this.updateableTipMessage,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<bool> tipIsShowing;
  final ValueNotifier<String> updateableTipMessage;

  @override
  _TipSpacingState createState() => _TipSpacingState();
}

class _TipSpacingState extends State<TipSpacing> {
  updateState() {
    if (mounted) setState(() {});
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
    return Visibility(
      visible: widget.tipIsShowing.value,
      child: Opacity(
        opacity: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0 + 8,
            vertical: 24,
          ),
          child: SnackBarBody(
            icon: FontAwesomeIcons.solidLightbulb,
            color: Colors.yellow,
            updatingMessage: widget.updateableTipMessage,
          ),
        ),
      ),
    );
  }
}
