//flutter
import 'package:flutter/material.dart';
import 'package:swol/shared/widgets/complex/fields/textField/clearButton.dart';
import 'package:swol/shared/widgets/complex/fields/textField/undoAndEditToggle.dart';

//internal
import 'package:swol/shared/widgets/simple/ourSnackBar.dart';
import 'package:swol/pages/notes/fieldEditButtons.dart';

//widget
class TextFieldWithClearButton extends StatefulWidget {
  const TextFieldWithClearButton({
    Key key,
    @required this.valueToUpdate,
    @required this.hint,
    @required this.error,
    this.autofocus: false,
    this.focusNode, //If passed then use this
    this.present, //If passed then use this
    this.otherFocusNode, //If passed then shift over on next
    @required this.editOneAtAtTime,
  }) : super(key: key);

  final ValueNotifier<String> valueToUpdate;
  final String hint;
  final String error;
  final bool autofocus;
  final FocusNode focusNode;
  final ValueNotifier<bool> present;
  final FocusNode otherFocusNode;
  final bool editOneAtAtTime;

  @override
  _TextFieldWithClearButtonState createState() => _TextFieldWithClearButtonState();
}

class _TextFieldWithClearButtonState extends State<TextFieldWithClearButton> {
  ValueNotifier<String> tempValueToUpdate;
  TextEditingController ctrl = new TextEditingController();
  ValueNotifier<bool> isEditing;
  ValueNotifier<FocusNode> focusNodeVN = new ValueNotifier(new FocusNode());
  ValueNotifier<bool> present;

  showSnackBar(){
    openSnackBar(
      context, 
      Colors.red, 
      Icons.error_outline,
      message: "A Name Is Required", 
    );
  }

  showHideClearButton(){
    present.value = (ctrl.text != "");

    //update temp value
    tempValueToUpdate.value = ctrl.text;

    //if we are allowed to edit everything at once then automatically update the value
    if(widget.editOneAtAtTime == false){
      widget.valueToUpdate.value = tempValueToUpdate.value;
    }

    //reflect changes in UI
    if(mounted) setState(() {});
  }

  focusSwitch(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(focusNodeVN.value.hasFocus == false){
        isEditing.value = false; //triggers the function below
      }
    });
  }

  makeSureNameIsntEmpty(){
    if(widget.otherFocusNode != null){ //name must be not empty
      if(tempValueToUpdate.value == ""){
        //auto undo (will also update tempValueToUpdate)
        ctrl.text = widget.valueToUpdate.value;
        
        //let the user know their action is invalid
        showSnackBar();
      }
    }
  }

  maybeRemoveFocusFromUs(){
    if(widget.editOneAtAtTime){
      //NOTE: we shouldn't need this
      //BUT we haven't got only the one button to be active at a time
      //so we have this as a back up as an intermediate
      //between the worst and best UX
      if(focusNodeVN.value.hasFocus){
        FocusScope.of(context).unfocus();
      }
      //ELSE: what ever else has focus wants to keep it
    }
    else FocusScope.of(context).unfocus();
  }

  isEditingUpdate(){
    if(widget.editOneAtAtTime == false){
      if(isEditing.value == false){ //no longer editing so SAVE
        makeSureNameIsntEmpty();
        maybeRemoveFocusFromUs();
        widget.valueToUpdate.value = tempValueToUpdate.value;
      }
    }
    else{
      if(isEditing.value){ //autofocus on the field
        WidgetsBinding.instance.addPostFrameCallback((_){
          FocusScope.of(context).requestFocus(focusNodeVN.value);
        });
      }
      else{ //no longer editing so SAVE OR UNDO?
        //TODO: figure out how i came to the conclusions below 
        //save (IF we are currently focused)
        //undo (IF we are currently NOT focused)
        if(focusNodeVN.value.hasFocus){
          makeSureNameIsntEmpty();
          maybeRemoveFocusFromUs();
        }
        else{ //auto undo (will also update tempValueToUpdate)
          ctrl.text = widget.valueToUpdate.value;
        }

        //update actual value (will only trigger update if different)
        widget.valueToUpdate.value = tempValueToUpdate.value;
      }
    }

    //show check or edit
    setState(() {});
  }

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
    ctrl.text = widget.valueToUpdate.value;
    tempValueToUpdate = new ValueNotifier(ctrl.text);

    //handle showing or hiding clear button
    ctrl.addListener(showHideClearButton);

    //handle present passed or not
    if(widget.present == null){
      present = new ValueNotifier(false);
    }
    else present = widget.present;

    //set present based on ctrl
    present.value = (ctrl.text != "");

    //handle autofocus
    //autofocus name
    if(widget.editOneAtAtTime == false){
      if(widget.autofocus){
        WidgetsBinding.instance.addPostFrameCallback((_){
          Future.delayed(
            //wait a little bit so animations page transition animation complete
            Duration(milliseconds: 300),
            (){
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
    //determine text input action
    TextInputAction textInputAction;
    if(widget.otherFocusNode == null) textInputAction = TextInputAction.newline;
    else{
      if(widget.editOneAtAtTime) textInputAction = TextInputAction.done;
      else{
        textInputAction = TextInputAction.next;
      }
    }

    bool fieldEdited = (tempValueToUpdate.value != widget.valueToUpdate.value);
    bool twoButtons = (widget.editOneAtAtTime && isEditing.value && fieldEdited);

    //build
    return Flexible(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            (widget.editOneAtAtTime) ? EditOneAtATimeButtons(
              undo: (){ //go back to what you had previously
                ctrl.text = widget.valueToUpdate.value;
              },
              twoButtons: twoButtons, 
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
                        maxLines: (widget.otherFocusNode == null) ? null : 1,
                        minLines: 1,
                        //so when we scroll the field into view we also include is title
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
                          )
                        ),
                        onEditingComplete: (){
                          if(widget.editOneAtAtTime == false){
                            if(widget.otherFocusNode != null){
                              FocusScope.of(context).requestFocus(widget.otherFocusNode);
                            }
                            else FocusScope.of(context).unfocus();
                          }
                          else{
                            isEditing.value = false; //unfocuses automatically
                          }
                        },
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: (isEditing.value && present.value) 
                    ? ClearButton(ctrl: ctrl) 
                    : Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}