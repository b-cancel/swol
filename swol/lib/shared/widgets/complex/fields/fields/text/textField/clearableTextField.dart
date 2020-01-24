//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/fields/text/textField/undoAndEditToggle.dart';
import 'package:swol/shared/widgets/simple/ourSnackBar.dart';
import 'undoAndEditToggle.dart';
import 'clearButton.dart';

//widget
class TextFieldWithClearButton extends StatefulWidget {
  const TextFieldWithClearButton({
    Key key,
    @required this.isName,
    @required this.valueToUpdate,
    @required this.hint,
    @required this.error,
    @required this.editOneAtAtTime,
    this.autofocus: false,
    this.focusNode, //If passed then use this
    this.present, //If passed then use this
    this.noteFocusNode, //If passed then shift over on next
    
  }) : super(key: key);

  final bool isName;
  final ValueNotifier<String> valueToUpdate;
  final String hint;
  final String error;
  final bool editOneAtAtTime;
  final bool autofocus;
  final FocusNode focusNode;
  final ValueNotifier<bool> present;
  final FocusNode noteFocusNode;

  @override
  _TextFieldWithClearButtonState createState() => _TextFieldWithClearButtonState();
}

class _TextFieldWithClearButtonState extends State<TextFieldWithClearButton> {
  TextEditingController ctrl = new TextEditingController();
  ValueNotifier<bool> isEditing;
  ValueNotifier<FocusNode> focusNodeVN = new ValueNotifier(new FocusNode());
  ValueNotifier<bool> present;

  //init
  @override
  void initState() {
    //set isEditing init
    if(widget.editOneAtAtTime) isEditing = new ValueNotifier(false);
    else isEditing = new ValueNotifier(true);

    //handle focus passed or not
    if(widget.focusNode == null){
      focusNodeVN.value = new FocusNode();
    }
    else focusNodeVN.value = widget.focusNode;

    //set the initial value of the fields
    setCtrlWithValue();

    //handle showing or hiding clear button
    ctrl.addListener(showHideClearButton);

    //handle present passed or not
    if(widget.present == null){
      present = new ValueNotifier(ctrl.text != "");
    }
    else present = widget.present;

    //handle autofocus
    //autofocus name
    if(widget.editOneAtAtTime == false){
      if(widget.autofocus){
        WidgetsBinding.instance.addPostFrameCallback((_){
          Future.delayed(
            //wait a little bit so animations page transition animation complete
            Duration(milliseconds: 300),(){
              FocusScope.of(context).requestFocus(focusNodeVN.value);
            }
          );
        });
      }
    }
    else{
      //if we are editing one at a time
      //if our focus node no longer has focus
      //we revert back to our old value
      //and we change is editing
      WidgetsBinding.instance.addPostFrameCallback((_){
        focusNodeVN.value.addListener(focusSwitch);
      });
    }

    //if editing value changes then update
    isEditing.addListener(isEditingUpdate);

    //super init
    super.initState();
  }

  @override
  void dispose() { 
    ctrl.removeListener(showHideClearButton);
    focusNodeVN.value.removeListener(focusSwitch);
    isEditing.removeListener(isEditingUpdate);
    super.dispose();
  }

  //build
  @override
  Widget build(BuildContext context) {
    Function onEditingComplete = (){
      if(widget.editOneAtAtTime == false){
        if(widget.isName){
          FocusScope.of(context).requestFocus(widget.noteFocusNode);
        }
        else FocusScope.of(context).unfocus();
      }
      else isEditing.value = false;
    };

    //determine text input action
    TextInputAction textInputAction;
    if(widget.isName){
      if(widget.editOneAtAtTime) textInputAction = TextInputAction.done;
      else textInputAction = TextInputAction.next;
    }
    else textInputAction = TextInputAction.newline;

    //build
    return Flexible(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            (widget.editOneAtAtTime) ? EditOneAtATimeButtons(
              undo: () => setCtrlWithValue(),
              showTopButton: (
                isEditing.value 
                && (ctrl.text != widget.valueToUpdate.value)
              ), 
              isEditing: isEditing,
            ) : Container(),
            Flexible(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        onTap: (){
                          isEditing.value = true;
                        },
                        controller: ctrl,
                        focusNode: focusNodeVN.value,
                        maxLines: (widget.isName) ? 1 : null,
                        minLines: 1,
                        //so when we scroll the field into view we also include the field's title
                        scrollPadding: EdgeInsets.only(top: 56),
                        keyboardType: TextInputType.text,
                        textInputAction: textInputAction,
                        decoration: InputDecoration(
                          //TODO: figure out why all of a sudden this was required to not cause some ugly overflow problem
                          contentPadding: EdgeInsets.only(
                            top: 12,
                            bottom: 18,
                          ),
                          hintText: widget.hint,
                          errorText: widget.error,
                          //spacer so X doesn't cover the text
                          suffix: Container(
                            width: 36,
                          ),
                        ),
                        onEditingComplete: () => onEditingComplete(),
                      ),
                    ],
                  ),
                  (isEditing.value && present.value) 
                  ? ClearButton(ctrl: ctrl) 
                  : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  setValueWithCtrl() => widget.valueToUpdate.value = ctrl.text;
  setCtrlWithValue() => ctrl.text = widget.valueToUpdate.value;

  showHideClearButton(){
    //update present
    present.value = (ctrl.text != "");

    //if we are allowed to edit everything at once then automatically update the value
    if(widget.editOneAtAtTime == false) setValueWithCtrl();

    //reflect changes in UI
    if(mounted) setState(() {});
  }

  //only used when (widget.editOneAtAtTime)
  //so that when switch focus, without saving directly, we simply put back the value that was there
  focusSwitch(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(focusNodeVN.value.hasFocus == false){
        isEditing.value = false; //triggers the function below
      }
    });
  }

  isEditingUpdate(){
    if(isEditing.value){ //we want to edit, request focus
      WidgetsBinding.instance.addPostFrameCallback((_){
        if(focusNodeVN.value.hasFocus == false){
          FocusScope.of(context).requestFocus(focusNodeVN.value);
        }
      });
    }
    else{
      //TODO: know if "has" or "maybe have" is more correct and cover potential edge case
      //you know FOCUS SWITCH has been triggered IF 
      //1. isEditing.value == false (here)
      //2. widget.editOneAtAtime && focusNodeVN.value.hasFocus == false (else below)

      //we are saving
      if(widget.editOneAtAtTime == false || (widget.editOneAtAtTime && focusNodeVN.value.hasFocus)){
        if(widget.isName && ctrl.text == ""){ 
          setCtrlWithValue();
          openSnackBar(
            context, 
            Colors.red, 
            Icons.error_outline,
            message: "A Name Is Required", 
          );
        } //name but valid, or not name and guaranteed valid
        else setValueWithCtrl();

        //the edit is complete so remove focus from us
        if(focusNodeVN.value.hasFocus){
          FocusScope.of(context).unfocus();
        }
      } //we are undoing (FOCUS SWITCH)
      else setCtrlWithValue();
    }

    //show check or edit
    setState(() {});
  }
}