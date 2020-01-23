//flutter
import 'package:flutter/material.dart';

//packages
import 'package:flutter_icons/flutter_icons.dart';

//internal
import 'package:swol/shared/methods/vibrate.dart';

//build
class VibrationSwitch extends StatelessWidget {
  const VibrationSwitch({
    this.updateState,
    Key key,
  }) : super(key: key);

  //required because if this is the last time vibration started
  //then setState won't automatically be called
  //and the vibration button won't go away
  final Function updateState;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        child: Visibility(
          visible: (Vibrator.isVibrating) ? true : false,
          child: IconButton(
            padding: EdgeInsets.all(16),
            tooltip: 'Turn Off Vibration',
            onPressed: (){
              Vibrator.stopVibration();
              if(updateState != null) updateState();
            },
            icon: Icon(
              MaterialCommunityIcons.getIconData("vibrate-off")
            ),
          ),
        ),
      ),
    );
  }
}