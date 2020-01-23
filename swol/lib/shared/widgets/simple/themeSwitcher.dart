//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:provider/provider.dart';

//internal
import 'package:swol/shared/methods/theme.dart';

//show function
void showThemeSwitcher(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
      return ThemeSelector(
        selectLight: () => _themeChanger.setTheme(MyTheme.light),
        selectDark: () => _themeChanger.setTheme(MyTheme.dark),
      );
    },
  );
}

//switcher widget
class ThemeSelector extends StatelessWidget {
  ThemeSelector({
    @required this.selectLight,
    @required this.selectDark,
  });

  final Function selectLight;
  final Function selectDark;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select Theme'),
      children: <Widget>[
        RadioListTile<Brightness>(
          value: Brightness.light,
          groupValue: Theme.of(context).brightness,
          onChanged: (Brightness value) {
            if(value == Brightness.light) selectLight();
          },
          title: const Text('Light'),
        ),
        RadioListTile<Brightness>(
          value: Brightness.dark,
          groupValue: Theme.of(context).brightness,
          onChanged: (Brightness value) {
            if(value == Brightness.dark) selectDark();
          },
          title: const Text('Dark'),
        ),
      ],
    );
  }
}