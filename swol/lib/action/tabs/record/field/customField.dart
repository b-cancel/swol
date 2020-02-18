//flutter
import 'package:flutter/material.dart';

//for white listing characters
import 'package:flutter/services.dart';
import 'package:swol/action/popUps/textValid.dart';

//widget
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
      color: widget.focusNode.hasFocus
          ? Theme.of(context).accentColor
          : Theme.of(context).cardColor,
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
                  left: widget.isLeft == false
                      ? borderThatHides
                      : borderThatExists,
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
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          //right
          topRight: widget.isLeft ? Radius.zero : normalCurve,
          bottomRight: widget.isLeft ? Radius.zero : normalCurve,
          //left
          bottomLeft: widget.isLeft ? normalCurve : Radius.zero,
          topLeft: widget.isLeft ? normalCurve : Radius.zero,
        ),
        child: Material(
          color: widget.focusNode.hasFocus ? Theme.of(context).accentColor : Colors.transparent,
          child: Stack(
            alignment:
                widget.isLeft ? Alignment.centerRight : Alignment.centerLeft,
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
                        //show little tick, lets you select but with no toolbar you can't do anything with it
                        //we only WOULD LIKE the user to be able to reposition their cursor
                        //nothing else
                        //dealing with everything else is too much hassle so we turn it offf
                        enableInteractiveSelection: false,
                        //position in the field
                        cursorColor: Theme.of(context).cardColor,
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
                        //and because of scaling up and sizing they might not look right either
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
                        onEditingComplete: () {
                          //NOTE: we don't care for our state because
                          //if the user presses NEXT they want an OBVIOUS action to be performed
                          //regardless of whether or not its the most useful thing

                          //if we press next then we KNOW that the keyboard is open
                          //in which case we have 2 possible actions to perform
                          //1. either we close the keyboard which naturally leads into us unfocusing
                          //2. or we move onto the next text field

                          //so although sometimes staying on our own field makes more sense
                          //we don't do that because the user EXPECTS some OBVIOUS action
                          if (isTextValid(widget.otherController.text)) {
                            //the other controller has a valid value
                            //so we perform the only other possible action
                            FocusScope.of(context).unfocus();
                          } else {
                            //in case the otherController has just a 0
                            if(widget.otherController.text == "0") widget.otherController.clear();
                            //focus on the next field
                            FocusScope.of(context).requestFocus(widget.otherFocusNode);
                            //send cursor to end
                            /*
                            //NOTE: with interactive selection off it does this automatically
                            widget.otherController.selection = TextSelection.fromPosition(
                              TextPosition(offset: widget.otherController?.text?.length ?? 0),
                            );
                            */
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              coveringStick,
            ],
          ),
        ),
      ),
    );
  }
}
