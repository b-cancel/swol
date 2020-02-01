import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ValueName {
  IsDark,
  TermsAgreed, 
  //for onboarding
  InitialControlsShown, 
  IntroductionShown,
  SaveShown,
  SearchShown,
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
    ValueName.TermsAgreed: false,
    //for onboarding
    ValueName.InitialControlsShown: false,
    ValueName.IntroductionShown: false,
    ValueName.SaveShown: false,
    ValueName.SearchShown: false,
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
    for(int i = 0; i < names.length; i++) _getOrSetToDefault(names[i]);
  }

  //getters
  static ValueNotifier getIsDark() => _nameToValueNotifier[ValueName.IsDark];
  static ValueNotifier getTermAgreed() => _nameToValueNotifier[ValueName.TermsAgreed];
  static ValueNotifier getInitialControlsShown() => _nameToValueNotifier[ValueName.InitialControlsShown];
  static ValueNotifier getIntroductionShown() => _nameToValueNotifier[ValueName.IntroductionShown];
  static ValueNotifier getSaveShown() => _nameToValueNotifier[ValueName.SaveShown];
  static ValueNotifier getSearchShown() => _nameToValueNotifier[ValueName.SearchShown];

  //setters (must update local and global)
  static setIsDark(bool isDark) => _setLocalGlobal(ValueName.IsDark, isDark);
  static setTermsAgreed(bool termsAgreed) => _setLocalGlobal(ValueName.TermsAgreed, termsAgreed);
  static setInitialControlsShown(bool initialControlsShown) => _setLocalGlobal(ValueName.InitialControlsShown, initialControlsShown);
  static setIntroductionShown(bool introductionShown) => _setLocalGlobal(ValueName.IntroductionShown, introductionShown);
  static setSaveShown(bool saveShown) => _setLocalGlobal(ValueName.SaveShown, saveShown);
  static setSearchShown(bool searchShown) => _setLocalGlobal(ValueName.SearchShown, searchShown);

  //-------------------------private-------------------------

  static _getOrSetToDefault(ValueName name){
    bool isBool = true;
    String key = name.toString();

    //try to find the value
    dynamic value = _get(isBool, key);

    //set the default if necesary
    if(value == null){
      value = _set(
        isBool, 
        key, _nameToDefaultValue[name],
      );
    }

    //save it in value notifier
    _nameToValueNotifier[name] = ValueNotifier(value);
  }

  static _setLocalGlobal(ValueName name, dynamic value, {bool isBool: true}){
    //update locally
    _nameToValueNotifier[name].value = value;
    //update globally
    _set(isBool, name.toString(), value);
  }

  static dynamic _get(bool isBool, String key){
    if(isBool) return _savedPreferences.getBool(key);
    else return _savedPreferences.getInt(key);
  }

  static dynamic _set(bool isBool, String key, dynamic value){
    //start the process of saving in shared preferences asynchronously
    if(isBool) _savedPreferences.setBool(key, value);
    else _savedPreferences.setInt(key, value);

    //return the value we will be saving synchronously
    return value;
  }
}