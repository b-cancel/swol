//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feature_discovery/feature_discovery.dart';

//NOTE: alot of containers below must have color transparent to functions

//enums
enum AFeature {
  SwolLogo, 
  LearnPage, 
  AddExcercise, 
  SaveExcercise,
  SearchExcercise,
}

enum StoredBools {
  TermsAgreed, 
  InitialControlsShown, 
  IntroductionShown,
  SaveShown, 
  //TODO: do or eliminate variables below
  SearchButtonShown,
  SettingsShown,
}

//classes
class OnBoarding{
  static bool setgetValue(SharedPreferences prefs, StoredBools storedBool){
    dynamic value = prefs.getBool(storedBool.toString());
    if(value == null){
      prefs.setBool(storedBool.toString(), false);
      return false;
    }
    else return value;
  }

  static givePermission() => boolSet(StoredBools.TermsAgreed);
  static initialControlsShown() => boolSet(StoredBools.InitialControlsShown);
  static saveShown() => boolSet(StoredBools.SaveShown);
  //TODO: finish below
  static searchButtonShown() => boolSet(StoredBools.SearchButtonShown);
  static settingsShown() => boolSet(StoredBools.SettingsShown);

  static boolSet(StoredBools storedBool) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(storedBool.toString(), true);
  }

  //-------------------------*-------------------------

  static discoverSwolLogo(BuildContext context){
    discoverSet(context, AFeature.SwolLogo);
  }

  static discoverLearnPage(BuildContext context){
    discoverSet(context, AFeature.LearnPage);
  }

  static discoverAddExcercise(BuildContext context){
    discoverSet(context, AFeature.AddExcercise);
  }

  static discoverSaveExcercise(BuildContext context){
    discoverSet(context, AFeature.SaveExcercise);
  }

  //TODO: finish 2 below

  //utility function because Feature discovery seems to prefer sets
  static discoverSet(BuildContext context, AFeature featureName){
    Set<String> aSet = new Set<String>();
    aSet.add(featureName.toString());
    FeatureDiscovery.discoverFeatures(context, aSet);
  }
}