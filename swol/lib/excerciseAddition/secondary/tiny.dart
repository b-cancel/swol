import 'package:flutter/material.dart';

class Pill extends StatefulWidget {
  const Pill({
    Key key,
    @required this.sectionSize,
    @required this.setTarget,
    @required this.actives,
    @required this.name,
    @required this.onTap,
    @required this.leftMultiplier,
    @required this.rightMultiplier,
  }) : super(key: key);

  final double sectionSize;
  final ValueNotifier<int> setTarget;
  final List<int> actives;
  final String name;
  final Function onTap;
  final double leftMultiplier;
  final double rightMultiplier;

  @override
  _PillState createState() => _PillState();
}

class _PillState extends State<Pill> {
  bool active;

  setTargetToActive(){
    active = widget.actives.contains(widget.setTarget.value);
  }

  updateState(){
    if(mounted){
      setTargetToActive();
      setState(() {});
    }
  }

  @override
  void initState() {
    //init
    setTargetToActive();

    //by update
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
    return Theme(
      data: ThemeData.dark(),
      child: DarkPills(
        sectionSize: widget.sectionSize,
        setTarget: widget.setTarget,
        actives: widget.actives,
        name: widget.name,
        onTap: widget.onTap,
        leftMultiplier: widget.leftMultiplier,
        rightMultiplier: widget.rightMultiplier,
        active: active,
      ),
      );
  }
}

class DarkPills extends StatelessWidget {
  const DarkPills({
    Key key,
    @required this.sectionSize,
    @required this.setTarget,
    @required this.actives,
    @required this.name,
    @required this.onTap,
    @required this.leftMultiplier,
    @required this.rightMultiplier,
    @required this.active,
  }) : super(key: key);

  final double sectionSize;
  final ValueNotifier<int> setTarget;
  final List<int> actives;
  final String name;
  final Function onTap;
  final double leftMultiplier;
  final double rightMultiplier;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: leftMultiplier * sectionSize,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).primaryColor,
                ),
                color: active ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    width: (sectionSize * 3),
                    height: 24,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 4.0,
                              ),
                              child: Icon(
                                Icons.info,
                                size: 16,
                                color: active ? Theme.of(context).primaryColor : Colors.white,
                              ),
                            ),
                            Text(
                              name,
                              style: TextStyle(
                                color: active ? Theme.of(context).primaryColor : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: rightMultiplier * sectionSize,
          )
        ],
      ),
    );
  }
}

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