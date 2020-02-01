//flutter
import 'package:flutter/material.dart';

//used only by addition
class BasicCard extends StatefulWidget {
  const BasicCard({
    Key key,
    @required this.child,
    this.notifier,
  }) : super(key: key);

  final Widget child;
  final ValueNotifier notifier;

  @override
  _BasicCardState createState() => _BasicCardState();
}

class _BasicCardState extends State<BasicCard> {
    updateState(){
    if(mounted) setState(() {});
  }

  @override
  void initState() {
    if(widget.notifier != null){
      widget.notifier.addListener(updateState);
    }
    super.initState();
  }

  @override
  void dispose() {
    if(widget.notifier != null){
      widget.notifier.removeListener(updateState);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16,
          bottom: 16,
          top: 8,
        ),
        child: widget.child,
      ),
    );
  }
}

class SliderCard extends StatelessWidget {
  SliderCard({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8, //8 is default spacing for add excercsie
          bottom: 8,
        ),
        child: child,
      ),
    );
  }
}