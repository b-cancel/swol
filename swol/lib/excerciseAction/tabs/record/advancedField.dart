import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/excerciseAction/toolTips.dart';
import 'package:swol/shared/functions/goldenRatio.dart';

class RecordFields extends StatelessWidget {
  //weight field
  final FocusNode weightFocusNode = new FocusNode();
  final TextEditingController weightController = new TextEditingController();

  //rep field
  final FocusNode repFocusNode = new FocusNode();
  final TextEditingController repController = new TextEditingController();

  //build
  @override
  Widget build(BuildContext context) {
    //-32 is for 16 pixels of padding from both sides
    double screenWidth = MediaQuery.of(context).size.width - 32;
    List<double> goldenBS = measurementToGoldenRatioBS(screenWidth);
    double iconSize = goldenBS[1];
    List<double> golden2BS = measurementToGoldenRatioBS(iconSize);
    iconSize = golden2BS[1];
    double borderSize = 3;

    //build
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          RecordField(
            focusNode: weightFocusNode,
            conroller: weightController,
            isLeft: true,
            text: "256",
            borderSize: borderSize,
          ),
          Container(
            child: Column(
              children: <Widget>[
                TappableIcon(
                  focusNode: weightFocusNode,
                  iconSize: iconSize,
                  borderSize: borderSize,
                  icon: Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                    ),
                    child: Icon(
                      FontAwesomeIcons.dumbbell,
                    ),
                  ),
                  isLeft: true,
                ),
                TappableIcon(
                  focusNode: repFocusNode,
                  iconSize: iconSize,
                  borderSize: borderSize,
                  icon: Icon(Icons.repeat),
                  isLeft: false,
                ),
              ],
            ),
          ),
          RecordField(
            focusNode: repFocusNode,
            conroller: repController,
            isLeft: false,
            text: "8",
            borderSize: borderSize,
          ),
        ],
      ),
    );
  }
}

class RecordField extends StatefulWidget {
  RecordField({
    @required this.focusNode,
    @required this.conroller,
    @required this.isLeft,
    @required this.text,
    @required this.borderSize,
  });

  final FocusNode focusNode;
  final TextEditingController conroller;
  final bool isLeft;
  final String text;
  final double borderSize;

  @override
  _RecordFieldState createState() => _RecordFieldState();
}

class _RecordFieldState extends State<RecordField> {
  updateState() {
    print("focus chagned to: " + widget.focusNode.hasFocus.toString());
    //if (mounted) setState(() {});
  }

  @override
  void initState() {
    //super inits
    super.initState();

    //add listener
    widget.focusNode.addListener(updateState);
  }

  @override
  void dispose() {
    //remove listener
    widget.focusNode.removeListener(updateState);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget coveringStick = Container(
      width: widget.borderSize,
      padding: EdgeInsets.only(
        top: widget.isLeft ? widget.borderSize : widget.borderSize * 3 + 8,
        bottom: widget.isLeft ? widget.borderSize * 3 + 8 : widget.borderSize,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: widget.isLeft
                      ? BorderSide(
                          color: Theme.of(context).cardColor,
                          width: widget.borderSize,
                        )
                      : BorderSide(
                          color: Colors.transparent,
                        ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: widget.isLeft == false
                      ? BorderSide(
                          color: Theme.of(context).cardColor,
                          width: widget.borderSize,
                        )
                      : BorderSide(
                          color: Colors.transparent,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.isLeft) {
      coveringStick = Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        child: coveringStick,
      );
    } else {}

    Radius normalCurve = Radius.circular(24);
    double multiplier = 4;
    return Expanded(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    //set
                    topRight: widget.isLeft ? Radius.zero : normalCurve,
                    bottomLeft: widget.isLeft ? normalCurve : Radius.zero,
                    //not so set
                    topLeft: widget.isLeft ? normalCurve : Radius.zero,
                    bottomRight: widget.isLeft ? Radius.zero : normalCurve,
                  ),
                  border: Border.all(
                    color: widget.focusNode.hasFocus
                        ? Theme.of(context).accentColor
                        : Theme.of(context).primaryColorLight,
                    width: widget.borderSize,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    width: 48.0 * multiplier,
                    height: 24.0 * multiplier,
                    child: TextField(
                      controller: widget.conroller,
                      focusNode: widget.focusNode,
                      style: TextStyle(
                        fontSize: 16.0 * multiplier,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        signed: false,
                        decimal: false,
                      ),
                      //TODO: pass other focusNode
                      textInputAction: widget.isLeft
                          ? TextInputAction.next
                          : TextInputAction.done,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      showCursor: true,
                      //toolbarOptions: ToolbarOptions(),
                      obscureText: false,
                      enableSuggestions: false,
                      enableInteractiveSelection: true,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      //NOTE: replace by the inputFormatter above
                      //maxLength: 4,
                      minLines: 1,
                      maxLengthEnforced: true,
                      maxLines: 1,
                      //TODO: only true for the first
                      //autofocus: true,
                    ),
                  ),
                ),),
          ),
          coveringStick,
        ],
      ),
    );
  }
}

class TappableIcon extends StatefulWidget {
  const TappableIcon({
    Key key,
    @required this.focusNode,
    @required this.iconSize,
    @required this.borderSize,
    @required this.icon,
    @required this.isLeft,
  }) : super(key: key);

  final FocusNode focusNode;
  final double iconSize;
  final double borderSize;
  final Widget icon;
  final bool isLeft;

  @override
  _TappableIconState createState() => _TappableIconState();
}

class _TappableIconState extends State<TappableIcon> {
  updateState() {
    print("change focus to: " + widget.focusNode.hasFocus.toString());
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    //super inits
    super.initState();

    //add listener
    widget.focusNode.addListener(updateState);
  }

  @override
  void dispose() {
    //remove listener
    widget.focusNode.removeListener(updateState);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Radius tinyCurve = Radius.circular(12);
    Radius normalCurve = Radius.circular(24);
    Radius bigCurve = Radius.circular(48);

    print("building given focus to: " + widget.focusNode.hasFocus.toString());

    return GestureDetector(
      onTap: () {
        if (widget.isLeft)
          showWeightToolTip(context);
        else
          showRepsToolTip(context);
      },
      child: Container(
        padding: EdgeInsets.only(
          right: widget.isLeft ? 8 : 0,
          left: widget.isLeft ? 0 : 8,
          bottom: widget.isLeft ? 4 : 0,
          top: widget.isLeft ? 0 : 4,
        ),
        child: Container(
          width: widget.iconSize,
          height: widget.iconSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: widget.isLeft ? tinyCurve : Radius.zero,
              bottomLeft: widget.isLeft ? Radius.zero : tinyCurve,
            ),
            border: Border.all(
              color: widget.focusNode.hasFocus
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColorLight,
              width: widget.borderSize,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Transform.translate(
                  offset:
                      Offset(widget.borderSize * (widget.isLeft ? -1 : 1), 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topRight: widget.isLeft ? tinyCurve : Radius.zero,
                        bottomLeft: widget.isLeft ? Radius.zero : tinyCurve,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: widget.isLeft ? 0 : 4,
                    right: widget.isLeft ? 4 : 0,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: widget.icon,
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
