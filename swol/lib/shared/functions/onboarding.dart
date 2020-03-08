//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:feature_discovery/feature_discovery.dart';

//NOTE: alot of containers below must have color transparent to function
//this is because I beleive with a color the container is encourage to expand
//even if that color is transparent

//enums
enum AFeature {
  SwolLogo, 
  LearnPage, 
  AddExercise, 
  SaveExercise,
  SearchExercise,
}

//classes
class OnBoarding{
  static discoverSwolLogo(BuildContext context){
    _discoverSet(context, AFeature.SwolLogo);
  }

  static discoverLearnPage(BuildContext context){
    _discoverSet(context, AFeature.LearnPage);
  }

  static discoverAddExercise(BuildContext context){
    _discoverSet(context, AFeature.AddExercise);
  }

  static discoverSaveExercise(BuildContext context){
    _discoverSet(context, AFeature.SaveExercise);
  }

  static discoverSearchExercise(BuildContext context){
    _discoverSet(context, AFeature.SearchExercise);
  }

  //utility function because Feature discovery seems to prefer sets
  static _discoverSet(BuildContext context, AFeature featureName){
    Set<String> aSet = new Set<String>();
    aSet.add(featureName.toString());
    FeatureDiscovery.discoverFeatures(context, aSet);
  }
}