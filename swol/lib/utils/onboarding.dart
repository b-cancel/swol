import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding{
  static givePermission() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("permissionGiven", true);
  }
}