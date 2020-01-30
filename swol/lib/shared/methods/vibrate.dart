import 'package:vibration/vibration.dart';

class Vibrator{
  static bool _hasCheckedForVibrator = false;
  static bool _hasVibration = false;
  static bool isVibrating = false;

  static _vibrationCheck()async{
    if(_hasCheckedForVibrator == false){
      _hasCheckedForVibrator = true;
      _hasVibration = await Vibration.hasVibrator();
    }
  }

  //TODO: make sure this doesn't conflict with a vibration that has already started, or wants to start
  //the above referes to a continuous vibration
  static vibrateOnce({Duration duration: const Duration(milliseconds: 500)})async{
    await _vibrationCheck();
    if(_hasVibration) Vibration.vibrate(
      duration: duration.inMilliseconds,
    );
  }

  static startConstantVibration()async{
    await _vibrationCheck();
    if(_hasVibration && isVibrating == false){
      isVibrating = true;
      Vibration.vibrate(
        pattern: [500],
        intensities: [255],
        repeat: 0,
      );
    }
  }

  static stopVibration()async{
    await _vibrationCheck();
    if(_hasVibration && isVibrating == true){
      isVibrating = false;
      Vibration.cancel();
    }
  }
}