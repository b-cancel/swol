//flutter
import 'package:flutter/material.dart';

//packages
import 'package:flutter_icons/flutter_icons.dart';

//internal
import 'package:swol/utils/vibrate.dart';

//build
class VibrationSwitch extends StatelessWidget {
  const VibrationSwitch({
    Key key,
  }) : super(key: key);

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