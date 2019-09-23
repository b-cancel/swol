//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//plugins
import 'package:flutter_picker/flutter_picker.dart';

class TextFieldWithClearButton extends StatelessWidget {
  const TextFieldWithClearButton({
    Key key,
    @required this.ctrl,
    @required this.focusnode,
    @required this.hint,
    @required this.error,
    @required this.present,
    this.otherFocusNode,
  }) : super(key: key);

  final TextEditingController ctrl;
  final FocusNode focusnode;
  final String hint;
  final String error;
  final ValueNotifier<bool> present;
  final FocusNode otherFocusNode;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Stack(
        children: <Widget>[
          TextField(
            controller: ctrl,
            focusNode: focusnode,
            maxLines: (otherFocusNode == null) ? null : 1,
            minLines: (otherFocusNode == null) ? 2 : 1,
            keyboardType: TextInputType.text,
            textInputAction: (otherFocusNode == null) 
            ? TextInputAction.newline
            : TextInputAction.next,
            decoration: InputDecoration(
              hintText: hint,
              errorText: error,
              //spacer so X doesn't cover the text
              suffix: Container(
                width: 36,
              )
            ),
            onEditingComplete: (){
              if(otherFocusNode != null){
                FocusScope.of(context).requestFocus(otherFocusNode);
              }
            },
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Transform.translate(
              offset: Offset(8, 0),
              child: IconButton(
                onPressed: (){
                  ctrl.text = "";
                },
                color: Colors.grey, 
                highlightColor: Colors.grey,
                icon: Icon(
                  Icons.close,
                  color: (present.value) ? Colors.grey : Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

class ReferenceLinkBox extends StatelessWidget {
  const ReferenceLinkBox({
    Key key,
    @required this.url,
  }) : super(key: key);

  final ValueNotifier<String> url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: new BorderRadius.all(
        Radius.circular(16.0),
      ),
      child: Container(
        color: Colors.grey.withOpacity(0.25),
        padding: EdgeInsets.all(0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MaterialButton(
                color: Theme.of(context).accentColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.all(0),
                onPressed: (){
                  Clipboard.getData('text/plain').then((clipboarContent) {
                    url.value = clipboarContent.text;
                  });
                },
                child: Text(
                  "Paste",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.only(
                    left: 16,
                  ),
                  onPressed: (){
                    url.value = "";
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            (url.value == "") ? 'Tap to paste the link' : url.value,
                            style: TextStyle(
                              color: (url.value == "") ? Colors.grey : Colors.white,
                            ),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            right: 8,
                          ),
                          child: (url.value == "") 
                          ? Container()
                          : Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MinsSecsBelowTimePicker extends StatelessWidget {
  const MinsSecsBelowTimePicker({
    Key key,
    @required this.showS,
  }) : super(key: key);

  final bool showS;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontWeight: FontWeight.bold
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  "MINUTE"
                  + ((showS) ? "S" : ""),
                ),
              ),
            ),
          ),
          Container(
            //spacing of columns + width of dots
            width: (16 * 2) + 16.0,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text("SECONDS"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedRecoveryTimeInfo extends StatelessWidget {
  AnimatedRecoveryTimeInfo({
    Key key,
    @required this.changeDuration,
    @required this.sectionGrown,
    @required this.grownWidth,
    @required this.regularWidth,
    @required this.textHeight,
    @required this.textMaxWidth,
    @required this.selectedDuration,
  }) : super(key: key);

  final Duration changeDuration;
  final int sectionGrown;
  final double grownWidth;
  final double regularWidth;
  final double textHeight;
  final double textMaxWidth;
  final ValueNotifier<Duration> selectedDuration;

  @override
  Widget build(BuildContext context) {
    double sub = -(textMaxWidth * 2);
    double sizeWhenGrown = grownWidth + sub;
    double sizeWhenShrunk = regularWidth + sub;
    if(sizeWhenShrunk.isNegative){
      sizeWhenShrunk = 0;
    }

    //build
    return Center(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 24.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AnimatedContainer(
                  duration: changeDuration,
                  width: (sectionGrown == 0) ? grownWidth : regularWidth,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: (sectionGrown == 0) ? 16 : 0,
                    ),
                    child: Center(
                      child: Text(
                        "ENDURANCE",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: (sectionGrown == 0) ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: changeDuration,
                  width: (sectionGrown == 1) ? grownWidth : regularWidth,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: (sectionGrown == 1) ? 16 : 0,
                    ),
                    child: Center(
                      child: Text(
                        "MASS",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: (sectionGrown == 1) ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: changeDuration,
                  width: (sectionGrown == 2) ? grownWidth : regularWidth,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: (sectionGrown == 2) ? 16 : 0,
                    ),
                    child: Center(
                      child: Text(
                        "STRENGTH",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: (sectionGrown == 2) ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              AnimatedContainer(
                duration: changeDuration,
                height: 16,
                width: (sectionGrown == 0) ? grownWidth : 0,
                child: (sectionGrown == 0) ? TickGenerator(
                  tickTypes: [7],
                  startTick: 0,
                  selectedDuration: selectedDuration,
                ) : Container(),
              ),
              AnimatedContainer(
                duration: changeDuration,
                height: 16,
                width:  (sectionGrown == 1) ? grownWidth : 0,
                child: (sectionGrown == 1) ? TickGenerator(
                  tickTypes: [5,6],
                  startTick: 35,
                  selectedDuration: selectedDuration,
                ) : Container(),
              ),
              AnimatedContainer(
                duration: changeDuration,
                height: 16,
                width: (sectionGrown == 2) ? grownWidth : 0,
                child: (sectionGrown == 2) ? TickGenerator(
                  tickTypes: [5, 11, 11, 11],
                  startTick: 95,
                  selectedDuration: selectedDuration,
                ) : Container(),
              ),
            ],
          ),
          DefaultTextStyle(
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: 16,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AnimatedContainer(
                    duration: changeDuration,
                    height: textHeight,                 
                    width: (sectionGrown == 0) ? textMaxWidth : 0,
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        "0s",
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: changeDuration,
                    constraints: BoxConstraints(
                      maxWidth: (sectionGrown == 0) ? sizeWhenGrown : sizeWhenShrunk,
                    ),
                  ),
                  AnimatedContainer(
                    duration: changeDuration,
                    height: textHeight,
                    width: (sectionGrown == 0 || sectionGrown == 1) ? textMaxWidth : 0,
                    alignment: (sectionGrown == 0) ? Alignment.centerRight : Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Center(
                        child: Text("3"
                        + ((sectionGrown == 0) ? "0" : "5") 
                        + "s"),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: changeDuration,
                    constraints: BoxConstraints(
                      maxWidth: (sectionGrown == 1) ? sizeWhenGrown : sizeWhenShrunk,
                    ),
                  ),
                  AnimatedContainer(
                    duration: changeDuration,
                    height: textHeight,
                    width: (sectionGrown == 1 || sectionGrown == 2) ? textMaxWidth : 0,
                    alignment: (sectionGrown == 1) ? Alignment.centerRight : Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Center(
                        child: Text("9"
                        + ((sectionGrown == 1) ? "0" : "5") 
                        + "s"),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: changeDuration,
                    constraints: BoxConstraints(
                      maxWidth: (sectionGrown == 2) ? sizeWhenGrown : sizeWhenShrunk,
                    ),
                  ),
                  AnimatedContainer(
                    duration: changeDuration,                           
                    height: textHeight,
                    width: (sectionGrown == 2) ? textMaxWidth : 0,
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Center(
                        child: Text("4:55"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TickGenerator extends StatefulWidget {
  TickGenerator({
    @required this.tickTypes,
    this.startTick,
    this.selectedDuration,
  });

  final List<int> tickTypes;
  final int startTick;
  final ValueNotifier<Duration> selectedDuration;

  @override
  _TickGeneratorState createState() => _TickGeneratorState();
}

class _TickGeneratorState extends State<TickGenerator> {
  @override
  void initState() {
    widget.selectedDuration.addListener((){
      setState(() {});
    });

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double tickWidth = 3;

    Widget spacer = Expanded(
      child: Container(),
    );

    int tempVal = widget.startTick;
    int selected = widget.selectedDuration.value.inSeconds;

    //generate ticks
    List<Widget> ticks = new List<Widget>();
    for(int i = 0; i < widget.tickTypes.length; i++){
      int littleOnesBeforeBigOnes = widget.tickTypes[i];
      for(int tick = 0; tick < littleOnesBeforeBigOnes; tick++){
        bool highlight = (tempVal == selected);

        //add small tick
        ticks.add(
          Container(
            width: 0,
            child: OverflowBox(
              minWidth: tickWidth,
              maxWidth: tickWidth,
              child: Container(
                height: 8,
                width: tickWidth,
                color: (highlight) 
                ? Theme.of(context).accentColor
                : Theme.of(context).backgroundColor,
              ),
            ),
          ),
        );
        ticks.add(spacer);
        
        //add 5 units each time
        tempVal += 5;
      }

      //see if we should add a big tick
      if(i != (widget.tickTypes.length - 1)){
        bool highlight = (tempVal == selected);

        //add big tick
        ticks.add(
          Container(
            width: 0,
            child: OverflowBox(
              minWidth: tickWidth,
              maxWidth: tickWidth,
              child: Container(
                height: 16,
                width: tickWidth,
                color: (highlight) 
                ? Theme.of(context).accentColor
                : Theme.of(context).backgroundColor,
              ),
            ),
          ),
        );
        ticks.add(spacer);

        //add 5 units each time
        tempVal += 5;
      }
    }

    //remove trailing spacer
    ticks.removeLast();

    //build
    return Row(
      children: ticks,
    );
  }
}