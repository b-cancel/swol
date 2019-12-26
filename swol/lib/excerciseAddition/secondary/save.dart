import 'package:flutter/material.dart';
import 'package:swol/excercise/defaultDateTimes.dart';
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excercise/excerciseStructure.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({
    Key key,
    @required this.showSaveButton,
    @required this.namePresent,
    @required this.name,
    @required this.url,
    @required this.note,
    @required this.functionIndex,
    @required this.repTarget,
    @required this.recoveryPeriod,
    @required this.setTarget,
    @required this.navSpread,
    @required this.nameError,
  }) : super(key: key);

  final ValueNotifier<bool> showSaveButton;
  final ValueNotifier<bool> namePresent;
  final ValueNotifier<String> name;
  final ValueNotifier<String> url;
  final ValueNotifier<String> note;
  final ValueNotifier<int> functionIndex;
  final ValueNotifier<int> repTarget;
  final ValueNotifier<Duration> recoveryPeriod;
  final ValueNotifier<int> setTarget;
  final ValueNotifier<bool> navSpread;
  final ValueNotifier<bool> nameError;

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {

  //so it can be added and removed from listeners
  manualSetState(){
    if(mounted) setState(() {});
  }
  
  @override
  void initState() {
    //add listeners
    widget.showSaveButton.addListener(manualSetState);
    widget.namePresent.addListener(manualSetState);

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      constraints: BoxConstraints(
        //no limit vs limit
        //the 100 is so large its never going to be a limitation
        maxHeight: (widget.showSaveButton.value) ? 100 : 0,
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: RaisedButton(
          color: (widget.namePresent.value) 
          ? Theme.of(context).accentColor 
          : Colors.grey,
          onPressed: ()async{
            if(widget.namePresent.value){
              //remove keyboard
              FocusScope.of(context).unfocus();

              //add workout to our list
              await ExcerciseData.addExcercise(
                AnExcercise(
                  //basic
                  name: widget.name.value,
                  url: widget.url.value,
                  note: widget.note.value,

                  //other
                  predictionID: widget.functionIndex.value,
                  repTarget: widget.repTarget.value,
                  recoveryPeriod: widget.recoveryPeriod.value,
                  setTarget: widget.setTarget.value,

                  //---
                  lastTimeStamp: LastTimeStamp.newDateTime(),
                ),
              );

              //exit pop up
              widget.navSpread.value = false;
              Navigator.pop(context);
            }
            else{
              widget.nameError.value = true;
              setState(() {});
            }
          },
          child: Text(
            "Save",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}