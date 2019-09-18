import 'package:vibration/vibration.dart';

bool hasCheckedForVibrator = false;
bool hasVibration = false;

_vibrationCheck()async{
  if(hasCheckedForVibrator == false){
    hasCheckedForVibrator = true;
    hasVibration = await Vibration.hasVibrator();
  }
}

startVibration()async{
  await _vibrationCheck();
  if(hasVibration){
    Vibration.vibrate(
      pattern: [500],
      intensities: [255],
      repeat: 0,
    );
  }
}

stopVibration()async{
  await _vibrationCheck();
  if(hasVibration){
    Vibration.cancel();
  }
}