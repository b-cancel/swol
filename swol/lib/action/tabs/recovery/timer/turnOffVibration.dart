//flutter
import 'package:flutter/material.dart';

//packages
import 'package:flutter_icons/flutter_icons.dart';

//internal
import 'package:swol/shared/methods/vibrate.dart';

//build
class VibrationSwitch extends StatefulWidget {
  @override
  _VibrationSwitchState createState() => _VibrationSwitchState();
}

class _VibrationSwitchState extends State<VibrationSwitch> {
  updateState(){
    if(mounted) setState(() {});
  }

  @override
  void initState() {
    Vibrator.isVibrating.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() { 
    Vibrator.isVibrating.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        padding: EdgeInsets.all(24),
        child: Visibility(
          visible: (Vibrator.isVibrating.value) ? true : false,
          child: IconButton(
            padding: EdgeInsets.all(16),
            tooltip: 'Turn Off Vibration',
            onPressed: () => Vibrator.stopVibration(),
            icon: Icon(
              MaterialCommunityIcons.getIconData("vibrate-off")
            ),
          ),
        ),
      ),
    );
  }
}