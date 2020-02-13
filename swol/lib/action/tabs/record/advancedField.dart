import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/action/other/toolTips.dart';
import 'package:swol/shared/functions/goldenRatio.dart';

class RecordFields extends StatefulWidget {
  RecordFields({
    @required this.weightController,
    @required this.weightFocusNode,
    @required this.repsController,
    @required this.repsFocusNode,
  });

  final TextEditingController weightController;
  final FocusNode weightFocusNode;
  final TextEditingController repsController;
  final FocusNode repsFocusNode;

  //weight field
  @override
  _RecordFieldsState createState() => _RecordFieldsState();
}

class _RecordFieldsState extends State<RecordFields> {
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
    return Container(
      height: (iconSize * 2) + 8,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RecordField(
            focusNode: widget.weightFocusNode,
            controller: widget.weightController,
            isLeft: true,
            borderSize: borderSize,
            otherFocusNode: widget.repsFocusNode,
            otherController: widget.repsController
          ),
          Column(
            children: <Widget>[
              TappableIcon(
                focusNode: widget.weightFocusNode,
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
                focusNode: widget.repsFocusNode,
                iconSize: iconSize,
                borderSize: borderSize,
                icon: Icon(Icons.repeat),
                isLeft: false,
              ),
            ],
          ),
          RecordField(
            focusNode: widget.repsFocusNode,
            controller: widget.repsController,
            isLeft: false,
            borderSize: borderSize,
            otherFocusNode: widget.weightFocusNode,
            otherController: widget.weightController,
          ),
        ],
      ),
    );
  }
}

class RecordField extends StatefulWidget {
  RecordField({
    @required this.focusNode,
    @required this.controller,
    @required this.isLeft,
    @required this.borderSize,
    @required this.otherFocusNode,
    @required this.otherController,
  });

  final FocusNode focusNode;
  final TextEditingController controller;
  final bool isLeft;
  final double borderSize;
  final FocusNode otherFocusNode;
  final TextEditingController otherController;

  @override
  _RecordFieldState createState() => _RecordFieldState();
}

class _RecordFieldState extends State<RecordField> {
  updateState() {
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
    BorderSide borderThatHides = BorderSide(
      color: widget.focusNode.hasFocus ? Theme.of(context).accentColor : Theme.of(context).cardColor,
      width: widget.borderSize,
    );

    BorderSide borderThatExists = BorderSide(
      color: Colors.transparent,
    );

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
                  right: widget.isLeft ? borderThatHides : borderThatExists,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: widget.isLeft == false ? borderThatHides : borderThatExists,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Radius normalCurve = Radius.circular(24);
    //NOTE: without toolbar shown our multiplier can drop to 3
    //else must be 4
    double multiplier = 3;
    return Expanded(
      //NOTE: this is required because for some reason 
      //initially focusing on the text field misifres sometimes
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          //reset text so they start back up at the begining
          widget.controller.clear();
          //focus on the field so the user can begin typing
          FocusScope.of(context).unfocus();
          FocusScope.of(context).requestFocus(widget.focusNode);
        },
        child: Stack(
          alignment: widget.isLeft ? Alignment.centerRight : Alignment.centerLeft,
          children: <Widget>[
            Positioned.fill(
              child: Container(
                  decoration: BoxDecoration(
                    color: widget.focusNode.hasFocus ? Theme.of(context).accentColor : Colors.transparent,
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
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        //set text size as large as a large phone 
                        //so if anything the cursor is smaller than it should be
                        style: TextStyle(
                          fontSize: 16.0 * multiplier,
                        ),
                        //eliminate bottom line border
                        decoration: InputDecoration(
                          //hide automatically bottom border
                          border: InputBorder.none,
                          //hides digit counter
                          counterText: "",
                        ),
                        //hide signs or decimals from keyboard if possible
                        keyboardType: TextInputType.numberWithOptions(
                          signed: false,
                          decimal: false,
                        ),
                        //cut, copy, past, and select all are not necessary
                        toolbarOptions: ToolbarOptions(),
                        //adding dashing intelligently is not needed in IOS
                        smartDashesType: SmartDashesType.disabled,
                        //ditto but for quote is not needed in IOS
                        smartQuotesType: SmartQuotesType.disabled,
                        //so your eyes dont burn
                        keyboardAppearance: Brightness.dark,
                        //balance
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        //where you are writing kinda matters
                        showCursor: true,
                        //no passwords here
                        obscureText: false,
                        //no suggstion of fancy selection useful
                        enableSuggestions: false, 
                        enableInteractiveSelection: false,
                        //guarnatee only digits and a max of 4 digits
                        maxLength: widget.isLeft ? 4 : 3,
                        inputFormatters: [
                          //super guarnatee a max of 4 digits
                          LengthLimitingTextInputFormatter(
                            widget.isLeft ? 4 : 3,
                          ),
                          //super guarantee only digits
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                        //line count
                        expands: false, //only 1 line at all times
                        minLines: 1,
                        maxLines: 1,
                        maxLengthEnforced: true,
                        //next to go to other field
                        textInputAction: TextInputAction.next,
                        //NOTE: on submitted seems to be working just as well
                        onEditingComplete: (){
                          //NOTE: we don't care for our state because
                          //if the user presses NEXT they want an OBVIOUS action to be performed
                          //regardless of whether or not its the most useful thing

                          //if we press next then we KNOW that the keyboard is open
                          //in which case we have 2 possible actions to perform
                          //1. either we close the keyboard which naturally leads into us unfocusing
                          //2. or we move onto the next text field

                          //so although sometimes staying on our own field makes more sense
                          //we don't do that because the user EXPECTS some OBVIOUS action
                          if(widget.otherController.text != "" && widget.otherController.text != "0"){
                            //the other controller has a valid value
                            //so we perform the only other possible action
                            FocusScope.of(context).unfocus();
                          }
                          else{
                            //in case the otherController has just a 0
                            widget.otherController.clear();
                            //focus on the next field
                            FocusScope.of(context).requestFocus(widget.otherFocusNode);
                          }
                        },
                      ),
                    ),
                  ),
                ),
            ),
            coveringStick,
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ],
        ),
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
            color: widget.focusNode.hasFocus ? Theme.of(context).accentColor : Colors.transparent,
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
                      color: widget.focusNode.hasFocus ? Theme.of(context).accentColor : Theme.of(context).cardColor,
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
