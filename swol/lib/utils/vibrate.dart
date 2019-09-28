import 'package:vibration/vibration.dart';

class Vibrator{
  static bool hasCheckedForVibrator = false;
  static bool hasVibration = false;

  static _vibrationCheck()async{
    if(hasCheckedForVibrator == false){
      hasCheckedForVibrator = true;
      hasVibration = await Vibration.hasVibrator();
    }
  }

  static vibrate({Duration duration: const Duration(milliseconds: 500)})async{
    await _vibrationCheck();
    if(hasVibration) Vibration.vibrate(
      duration: duration.inMilliseconds,
    );
  }

  static startVibration()async{
    await _vibrationCheck();
    if(hasVibration){
      Vibration.vibrate(
        pattern: [500],
        intensities: [255],
        repeat: 0,
      );
    }
  }

  static stopVibration()async{
    await _vibrationCheck();
    if(hasVibration){
      Vibration.cancel();
    }
  }
}