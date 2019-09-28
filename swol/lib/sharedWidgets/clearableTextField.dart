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
  }) : super(key: key);

  final ValueNotifier<String> valueToUpdate;
  final String hint;
  final String error;
  final bool autofocus;
  final FocusNode focusNode;
  final ValueNotifier<bool> present;
  final FocusNode otherFocusNode;

  @override
  _TextFieldWithClearButtonState createState() => _TextFieldWithClearButtonState();
}

class _TextFieldWithClearButtonState extends State<TextFieldWithClearButton> {
  TextEditingController ctrl = new TextEditingController();
  FocusNode focusNode;
  ValueNotifier<bool> present;

  //init
  @override
  void initState() {
    //handle focus passed or not
    if(widget.focusNode == null){
      focusNode = new FocusNode();
    }
    else focusNode = widget.focusNode;

    //handle present passed or not
    if(widget.present == null){
      present = new ValueNotifier(false);
    }
    else present = widget.present;

    //handle showing or hiding clear button
    ctrl.addListener((){
      present.value = (ctrl.text != "");
      widget.valueToUpdate.value = ctrl.text;
      setState(() {});
    });

    //handle autofocus
    //autofocus name
    if(widget.autofocus){
      WidgetsBinding.instance.addPostFrameCallback((_){
        FocusScope.of(context).requestFocus(focusNode);
      });
    }

    //super init
    super.initState();
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Stack(
        children: <Widget>[
          TextField(
            controller: ctrl,
            focusNode: focusNode,
            maxLines: (widget.otherFocusNode == null) ? null : 1,
            minLines: (widget.otherFocusNode == null) ? 2 : 1,
            keyboardType: TextInputType.text,
            textInputAction: (widget.otherFocusNode == null) 
            ? TextInputAction.newline
            : TextInputAction.next,
            decoration: InputDecoration(
              hintText: widget.hint,
              errorText: widget.error,
              //spacer so X doesn't cover the text
              suffix: Container(
                width: 36,
              )
            ),
            onEditingComplete: (){
              if(widget.otherFocusNode != null){
                FocusScope.of(context).requestFocus(widget.otherFocusNode);
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