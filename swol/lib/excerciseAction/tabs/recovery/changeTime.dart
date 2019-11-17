import 'package:flutter/material.dart';
import 'package:swol/sharedWidgets/timePicker.dart';
import 'package:swol/sharedWidgets/trainingTypes/trainingTypes.dart';

class ChangeRecoveryTimeWidget extends StatefulWidget {
  ChangeRecoveryTimeWidget({
    Key key,
    @required this.changeDuration,
    @required this.recoveryPeriod,
  }) : super(key: key);

  final Duration changeDuration;
  final ValueNotifier<Duration> recoveryPeriod;

  @override
  _ChangeRecoveryTimeWidgetState createState() => _ChangeRecoveryTimeWidgetState();
}

class _ChangeRecoveryTimeWidgetState extends State<ChangeRecoveryTimeWidget> {
  ValueNotifier<int> sectionID = new ValueNotifier(0);
  ValueNotifier<bool> showS = new ValueNotifier(false);

  recoveryPeriodToSectionID(){
    if(widget.recoveryPeriod.value < Duration(seconds: 15)) sectionID.value = 0; //nothing
    else{
      if(widget.recoveryPeriod.value <= Duration(minutes: 1)) sectionID.value = 1; //endurance
      else{
        if(widget.recoveryPeriod.value <= Duration(minutes: 2)) sectionID.value = 2; //hypertrophy
        else{
          if(widget.recoveryPeriod.value < Duration(minutes: 3)) sectionID.value = 3; //hypertrophy/strength
          else sectionID.value = 4;
        }
      }
    }
  }

  recoveryPeriodToShowS(){
    int mins = widget.recoveryPeriod.value.inMinutes;
    showS.value = ((mins == 1) ? false : true);
  }

  //TODO: uncomment after we are sure the other more important stuff works
  manualSetState(){
    /*
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(mounted){
        setState(() {});
      }
    });
    */
  }

  @override
  void initState() {
    //initial function calls
    recoveryPeriodToSectionID();
    recoveryPeriodToShowS();

    //as the recovery period changes updates should occur
    widget.recoveryPeriod.addListener(recoveryPeriodToSectionID);
    widget.recoveryPeriod.addListener(recoveryPeriodToShowS);

    //when showS changes we should set state (on next frame)
    showS.addListener(manualSetState);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.recoveryPeriod.removeListener(recoveryPeriodToSectionID);
    widget.recoveryPeriod.removeListener(recoveryPeriodToShowS);
    showS.removeListener(manualSetState);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Theme(
              data: ThemeData.dark(),
              child: TrainingTypeSections(
                lightMode: true,
                highlightField: 2,
                //nothing / endurance / hypertrohpy / hypertrophy & strength / strength and above
                sections: [[0], [0], [1], [1,2], [2]],
                sectionID: sectionID,
                plus24: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              children: <Widget>[
                TimePicker(
                  duration: widget.recoveryPeriod,
                  darkTheme: false,
                ),
                //TODO: this widget should take in duration and decide based on that to avoid uneeded reloads elsewhere
                MinsSecsBelowTimePicker(
                  showS: showS.value,
                  darkTheme: false,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}