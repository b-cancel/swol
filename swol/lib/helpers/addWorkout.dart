import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class HeaderWithInfo extends StatelessWidget {
  const HeaderWithInfo({
    Key key,
    @required this.title,
    @required this.popUp,
  }) : super(key: key);

  final String title;
  final Widget popUp;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Transform.translate(
          offset: Offset(12, 0),
          child: IconButton(
            onPressed: (){
              showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return popUp; 
                },
              );
            },
            icon: Icon(Icons.info),
            color: Theme.of(context).accentColor,
          ),
        )
      ],
    );
  }
}

class MyInfoDialog extends StatelessWidget {
  const MyInfoDialog({
    @required this.title,
    this.subtitle: "",
    @required this.child,
    Key key,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: SimpleDialog(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                right: 4,
              ),
              child: Icon(
                Icons.info,
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(title),
                  ),
                  (subtitle == "") ? Container()
                  : Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(0, -12),
              child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
            )
          ],
        ),
        children: <Widget>[
          child,
        ],
      ),
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 8,
      ),
      child: Divider(
        height: 0,
      ),
    );
  }
}

class ExcerciseNotePopUp extends StatelessWidget {
  const ExcerciseNotePopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Excercise Note",
      subtitle: "Details",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Here you can write in details like: \n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "1. Preferred grip",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "2. Modifications you made to form",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "3. Etc...",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExcerciseNamePopUp extends StatelessWidget {
  const ExcerciseNamePopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Excercise Name",
      subtitle: "Unique Name",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Don't worry about adding too many details here\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Extra details should be placed in notes",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RepTargetPopUp extends StatelessWidget {
  const RepTargetPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Rep Target",
      subtitle: "How many times you lift the weight before a break",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "something about how rep target change what you are focusing on",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PredictionFormulasPopUp extends StatelessWidget {
  const PredictionFormulasPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Prediction Formulas",
      subtitle: "Not sure? Keep the default",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Although these formulas were originally used to calculate an individual's 1 rep max\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "You can also use them to determine what your next set should be\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "In other words, they can give you a realistic goal to push towards",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Assming that you have both\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "1. Kept proper form",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "2. And taken an appropiate break between sets",
              ),
            ),
            new MyDivider(),
            //
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Which formula works best, depends on"
                  + " how much your nervous system is limiting you" 
                  + " in each individual excercise",
              ),
            ),
            new MyDivider(),
            //
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "In general \n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Exercises that use MORE muscle will put MORE strain on your nervous system\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Exercises that use LESS muscle will put LESS strain on your nervous system",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AutoUpdatePopUp extends StatelessWidget {
  const AutoUpdatePopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Auto Update",
      subtitle: "Not sure? Keep the default",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Which formula works best, depends on"
                  + " how much your nervous system is limiting you" 
                  + " in each individual excercise",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "But the forumla you chose initally, might not be predicting your results",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Because your nervous system is limiting you more or less than expected",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "By enabling this, you allow the app to switch to a formula that matches your results after each set",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "So you can have a more realistic goal to push towards",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SetTargetPopUp extends StatelessWidget {
  const SetTargetPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Set Target",
      subtitle: "Not sure? Keep the default",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "When you workout, it can be easy to forget how many sets you have left",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "So we help you track them",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "In general\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "The MORE reps you are doing per set",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "the LESS sets you should be doing\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "The LESS reps you are doing per set",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "the MORE sets you should be doing",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SetBreakPopUp extends StatelessWidget {
  const SetBreakPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Set Break",
      subtitle: "Not sure? Keep the default",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "You need to give your muscles time to recover"
              ),
            ),
            MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Exactly how much rest depends\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "1. How you specifically want to improve",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "2. And how much muscle this particular excercise uses",
              ),
            ),
            MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "In general \n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Exercises that use MORE muscle will require LONGER breaks\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Exercises that use LESS muscle will require SHORTER breaks",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReferenceLinkPopUp extends StatelessWidget {
  const ReferenceLinkPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Reference Link",
      subtitle: "Copy and paste from web browser",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Form is incredibly important!"
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Especially as you're approaching your 1 rep max, if your form isn't perfect, you could get permanently injured",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "So it's a good idea to keep a link to a video or picture of the proper form of each excercise",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const Sets = '''
[
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
]
''';

class HorizontalPicker extends StatelessWidget {
  HorizontalPicker({
    @required this.setTarget,
    @required this.numberSize,
    @required this.height,
  });

  final ValueNotifier<int> setTarget;
  final double numberSize;
  final double height;

  PickerItem intToPickerItem(int i){
    return PickerItem(
      text: Transform.rotate(
        angle: math.pi / 2,
        child: Text(i.toString()),
      ),
      value: i,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).primaryTextTheme.title.color;

    //build
    return Transform.rotate(
      angle: - math.pi / 2,
      child: Picker(
        hideHeader: true,
        looping: false, //not that many options
        backgroundColor: Colors.transparent,
        containerColor: Colors.transparent,
        height: height,
        selecteds: [setTarget.value - 1],
        onSelect: (Picker picker, int index, List<int> ints){
          int selected = picker.getSelectedValues()[0];
          setTarget.value = selected;
        },
        adapter: PickerDataAdapter(
          data: [
            intToPickerItem(1),
            intToPickerItem(2),
            intToPickerItem(3),
            intToPickerItem(4),
            intToPickerItem(5),
            intToPickerItem(6),
            intToPickerItem(7),
            intToPickerItem(8),
            intToPickerItem(9),
          ],
        ),
        //---still being messed
        textStyle: TextStyle(
          color: textColor,
        ),
        selectedTextStyle: TextStyle(
          color: textColor,
          fontSize: numberSize,
        ),
        itemExtent: numberSize,
      ).makePicker(),
    );
  }
}