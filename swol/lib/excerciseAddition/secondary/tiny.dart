import 'package:flutter/material.dart';



class Tick extends StatefulWidget {
  const Tick({
    Key key,
    @required this.tickWidth,
    @required this.setTarget,
    @required this.value,
  }) : super(key: key);

  final double tickWidth;
  final ValueNotifier<int> setTarget;
  final int value;

  @override
  _TickState createState() => _TickState();
}

class _TickState extends State<Tick> {
  bool tickActive;

  updateState(){
    if(mounted){
      setTargetToTickActive();
      setState(() {});
    }
  }

  setTargetToTickActive(){
    tickActive = (widget.setTarget.value == widget.value);
  }

  @override
  void initState() {
    //init
    setTargetToTickActive();

    //update
    widget.setTarget.addListener(updateState);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.setTarget.removeListener(updateState);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.tickWidth,
      color: (tickActive) ? Theme.of(context).accentColor : Theme.of(context).backgroundColor,
    );
  }
}