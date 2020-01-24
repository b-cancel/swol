//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/textField/undoAndEditToggle.dart';
import 'package:swol/shared/widgets/complex/fields/textField/clearButton.dart';
import 'package:swol/shared/widgets/simple/ourSnackBar.dart';

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
  //initially synced with valueToUpdate which is synced up with ctrl
  //always kept in sync with ctrl
  //IF widget.editOneAtAtTime == false then also always keeps valueToUpdate in sync
  ValueNotifier<String> tempValueToUpdate; 

  //other
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
    ctrl.text = widget.valueToUpdate.value;
    tempValueToUpdate = new ValueNotifier(ctrl.text);

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
              undo: (){ //go back to what you had previously
                ctrl.text = widget.valueToUpdate.value;
              },
              showTopButton: (
                isEditing.value 
                && (tempValueToUpdate.value != widget.valueToUpdate.value)
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

  //only used when (widget.editOneAtAtTime)
  //so that when switch focus, without saving directly, we simply put back the value that was there
  focusSwitch(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(focusNodeVN.value.hasFocus == false){
        isEditing.value = false; //triggers the function below
      }
    });
  }

  makeSureNameIsntEmpty(){
    if(widget.isName){ //name must be not empty
      if(tempValueToUpdate.value == ""){
        //auto undo (will also update tempValueToUpdate)
        ctrl.text = widget.valueToUpdate.value;
        
        //let the user know their action is invalid
        showSnackBar();
      }
    }
  }

  removeFocusFromUs(){
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
    if(isEditing.value){ //we want to edit, request focus
      WidgetsBinding.instance.addPostFrameCallback((_){
        if(focusNodeVN.value.hasFocus == false){
          FocusScope.of(context).requestFocus(focusNodeVN.value);
        }
      });
    }
    else{
      //we are saving
      if(widget.editOneAtAtTime == false || focusNodeVN.value.hasFocus){
        makeSureNameIsntEmpty();
        removeFocusFromUs();
      } //we are undoing
      else ctrl.text = widget.valueToUpdate.value; //(will also update tempValueToUpdate)

      //we are done editing so save (or save the undone value)
      widget.valueToUpdate.value = tempValueToUpdate.value; //that will have been updated by ctrl.text
    }

    //show check or edit
    setState(() {});
  }
}