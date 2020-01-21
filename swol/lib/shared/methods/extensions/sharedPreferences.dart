import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ValueName {
  IsDark,
  NextID,
  TermsAgreed, 
  //for onboarding
  InitialControlsShown, 
  IntroductionShown,
  SaveShown,
}

//NOTE: ideally this would contain extension methods
//extension Manager on SharedPreferences 
//but since we need it to be compatible with previous versions 
//we a refraining from making it official
class SharedPrefsExt {
  //variables
  //TODO: always make sure each ValueName has a default
  static Map<ValueName, dynamic> _nameToDefaultValue = {
    ValueName.IsDark: true,
    ValueName.NextID: 0,
    ValueName.TermsAgreed: false,
    //for onboarding
    ValueName.InitialControlsShown: false,
    ValueName.IntroductionShown: false,
    ValueName.SaveShown: false,
  };

  //used throughout privately
  static SharedPreferences _savedPreferences;
  static Map<ValueName, ValueNotifier> _nameToValueNotifier;

  //-------------------------public-------------------------

  //make sure each value has a valuenotifer to use on our end
  static init(SharedPreferences preferences){
    //save preferences for use throughout
    _savedPreferences = preferences;

    //create notifier
    _nameToValueNotifier = new Map<ValueName, ValueNotifier>();

    //interate through all enums to grab data or set it to its default
    List<ValueName> names = _nameToDefaultValue.keys.toList();
    for(int i = 0; i < names.length; i++){
      ValueName name = names[i];
      _nameToValueNotifier[name] = _getOrSetToDefault(name);
    }
  }

  //getters
  static ValueNotifier<bool> getIsDark() => _nameToValueNotifier[ValueName.IsDark];
  static ValueNotifier<int> getNextID() => _nameToValueNotifier[ValueName.NextID];
  static ValueNotifier<bool> getTermAgreed() => _nameToValueNotifier[ValueName.TermsAgreed];
  static ValueNotifier<bool> getInitialControlsShown() => _nameToValueNotifier[ValueName.InitialControlsShown];
  static ValueNotifier<bool> getIntroductionShown() => _nameToValueNotifier[ValueName.IntroductionShown];
  static ValueNotifier<bool> getSaveShown() => _nameToValueNotifier[ValueName.SaveShown];

  //setters (must update local and global)
  static setIsDark(bool isDark) => _setLocalGlobal(ValueName.IsDark, isDark);
  static setNextID(int nextID) => _setLocalGlobal(ValueName.NextID, nextID, isBool: false);
  static setTermsAgreed(bool termsAgreed) => _setLocalGlobal(ValueName.TermsAgreed, termsAgreed);
  static setInitialControlsShown(bool initialControlsShown) => _setLocalGlobal(ValueName.InitialControlsShown, initialControlsShown);
  static setIntroductionShown(bool introductionShown) => _setLocalGlobal(ValueName.IntroductionShown, introductionShown);
  static setSaveShown(bool saveShown) => _setLocalGlobal(ValueName.SaveShown, saveShown);

  //-------------------------private-------------------------

  static _setLocalGlobal(ValueName name, dynamic value, {bool isBool: true}){
    //update locally
    _nameToValueNotifier[name].value = value;
    //update globally
    _set(isBool, name.toString(), value);
  }

  static ValueNotifier _getOrSetToDefault(ValueName name){
    bool isBool = name != ValueName.NextID;
    String key = name.toString();

    //try to find the value
    dynamic value = _get(isBool, key);

    //set the default if necesary
    if(value == null){
      return ValueNotifier(
        _set(
          isBool, 
          key, _nameToDefaultValue[value],
        ),
      );
    } //otherwise return the value
    else return new ValueNotifier(value);
  }

  static dynamic _get(bool isBool, String key){
    if(isBool) return _savedPreferences.getBool(key);
    else return _savedPreferences.getInt(key);
  }

  static dynamic _set(bool isBool, String key, dynamic value){
    if(isBool) return _savedPreferences.setBool(key, value);
    else return _savedPreferences.setInt(key, value);
  }
}