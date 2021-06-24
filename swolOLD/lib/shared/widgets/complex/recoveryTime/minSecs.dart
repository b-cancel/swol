//show min and seconds below timer 
//don't show S below min or seconds if the value is 1
//super small detail but simple too
import 'package:flutter/material.dart';

class MinsSecsBelowTimePicker extends StatefulWidget {
  const MinsSecsBelowTimePicker({
    Key key,
    @required this.duration,
    this.darkTheme: true,
  }) : super(key: key);

  final ValueNotifier<Duration> duration;
  final bool darkTheme;

  @override
  _MinsSecsBelowTimePickerState createState() => _MinsSecsBelowTimePickerState();
}

class _MinsSecsBelowTimePickerState extends State<MinsSecsBelowTimePicker> {
  ValueNotifier<bool> showMinS;
  ValueNotifier<bool> showSecS;

  manualSetState(){
    if(mounted) setState(() {});
  }

  durationToShowSs(){
    //get minutes and seconds seperately
    int mins = widget.duration.value.inMinutes;
    int secs = (widget.duration.value - Duration(minutes: mins)).inSeconds;
    bool minS = (mins != 1);
    bool secS = (secs != 1);

    //create or update valuenotifiers
    if(showMinS == null && showSecS == null){
      showMinS = new ValueNotifier(minS);
      showSecS = new ValueNotifier(secS);
    }
    else{
      showMinS.value = minS;
      showSecS.value = secS;
    }
  }

  @override
  void initState() {
    //inital vars setting
    durationToShowSs();

    //add listenerss
    widget.duration.addListener(durationToShowSs);
    showMinS.addListener(manualSetState);
    showSecS.addListener(manualSetState);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    //remove listeners
    widget.duration.removeListener(durationToShowSs);
    showMinS.removeListener(manualSetState);
    showSecS.removeListener(manualSetState);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: (widget.darkTheme) ? Colors.white : Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  "MINUTE"
                  + ((showMinS.value) ? "S" : " "),
                ),
              ),
            ),
          ),
          Container(
            //spacing of columns + width of dots
            width: (16 * 2) + 16.0,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  "SECOND"
                  + ((showSecS.value) ? "S" : " "),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}