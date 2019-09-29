import 'package:flutter/material.dart';

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
  TextEditingController ctrl = new TextEditingController();
  ValueNotifier<bool> isEditing;
  FocusNode focusNode;
  ValueNotifier<bool> present;

  //init
  @override
  void initState() {
    //set isEditing init
    if(widget.editOneAtAtTime) isEditing = new ValueNotifier(false);
    else isEditing = new ValueNotifier(true);

    //handle focus passed or not
    if(widget.focusNode == null){
      focusNode = new FocusNode();
    }
    else focusNode = widget.focusNode;

    //set the initial value of the fields
    ctrl.text = widget.valueToUpdate.value;

    //handle showing or hiding clear button
    ctrl.addListener((){
      present.value = (ctrl.text != "");
      widget.valueToUpdate.value = ctrl.text;
      setState(() {});
    });

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
          FocusScope.of(context).requestFocus(focusNode);
        });
      }
    }

    //if editing value changes then update
    isEditing.addListener((){
      if(isEditing.value == false){
        //we have just confirmed
        //release focus
        FocusScope.of(context).unfocus();
      }
      setState(() {});
    });

    //super init
    super.initState();
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

    //build
    return Flexible(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            (widget.editOneAtAtTime == false) ? Container()
            : Padding(
              padding: EdgeInsets.only(
                right: 8,
              ),
              child: ClipRRect(
                borderRadius: new BorderRadius.only(
                  topLeft:  const  Radius.circular(16.0),
                  bottomLeft: const  Radius.circular(16.0),
                ),
                child: FlatButton(
                  color: Theme.of(context).accentColor,
                  padding: EdgeInsets.all(0),
                  onPressed: (){
                    isEditing.value = !isEditing.value;
                  },
                  child: Icon(
                    (isEditing.value) ? Icons.check : Icons.edit,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Stack(
                children: <Widget>[
                  TextField(
                    onTap: (){
                      isEditing.value = true;
                    },
                    controller: ctrl,
                    focusNode: focusNode,
                    maxLines: (widget.otherFocusNode == null) ? null : 1,
                    minLines: (widget.otherFocusNode == null) ? 2 : 1,
                    keyboardType: TextInputType.text,
                    textInputAction: textInputAction,
                    decoration: InputDecoration(
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
            ),
          ],
        ),
      ),
    );
  }
}