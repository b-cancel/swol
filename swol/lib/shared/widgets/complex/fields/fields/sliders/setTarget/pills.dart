//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/functions/trainingPopUps.dart';
import 'package:swol/shared/methods/theme.dart';

//widgets
class ThePills extends StatelessWidget {
  const ThePills({
    Key key,
    @required this.setTarget,
    @required this.totalScreenWidth,
  }) : super(key: key);

  final ValueNotifier<int> setTarget;
  final double totalScreenWidth;

  @override
  Widget build(BuildContext context) {
    Function strengthTraining = makeStrengthTrainingPopUp(context, 4);
    Function hypertrophyTraining = makeHypertrophyTrainingPopUp(context, 4);
    Function enduranceTraining = makeEnduranceTrainingPopUp(context, 4);

    //total screenwidth is the right size (1/4 of it is a section)
    return ThePillsDark(
      totalScreenWidth: totalScreenWidth, 
      setTarget: setTarget, 
      strengthTraining: strengthTraining, 
      hypertrophyTraining: hypertrophyTraining, 
      enduranceTraining: enduranceTraining,
    );
  }
}

class ThePillsDark extends StatelessWidget {
  const ThePillsDark({
    Key key,
    @required this.totalScreenWidth,
    @required this.setTarget,
    @required this.strengthTraining,
    @required this.hypertrophyTraining,
    @required this.enduranceTraining,
  }) : super(key: key);

  final double totalScreenWidth;
  final ValueNotifier<int> setTarget;
  final Function strengthTraining;
  final Function hypertrophyTraining;
  final Function enduranceTraining;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyTheme.dark,
      child: Container(
        //seven sections in between since there are 9 clicks
        width: (totalScreenWidth/4) * 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Pill(
              setTarget: setTarget,
              actives: [4,5,6], 
              sectionSize: totalScreenWidth/4,
              name: "Strength Training",
              openPopUp: strengthTraining,
              leftMultiplier: 2.75,
              rightMultiplier: 2.75,
              paddingTop: false,
            ),
            Pill(
              setTarget: setTarget,
              actives: [3,4,5], 
              sectionSize: totalScreenWidth/4,
              name: "Hypertrophy Training",
              openPopUp: hypertrophyTraining,
              leftMultiplier: 1.75,
              rightMultiplier: 3.75,
            ),
            Pill(
              setTarget: setTarget,
              actives: [1,2,3], //+1
              sectionSize: totalScreenWidth/4,
              name: "Endurance Training",
              openPopUp: enduranceTraining,
              leftMultiplier: 0,
              rightMultiplier: 5.75,
              paddingBottom: false,
            ),
          ],
        ),
      ),
    );
  }
}

class Pill extends StatefulWidget {
  const Pill({
    Key key,
    @required this.sectionSize,
    @required this.setTarget,
    @required this.actives,
    @required this.name,
    @required this.openPopUp,
    @required this.leftMultiplier,
    @required this.rightMultiplier,
    this.paddingTop: true,
    this.paddingBottom: true,
  }) : super(key: key);

  final double sectionSize;
  final ValueNotifier<int> setTarget;
  final List<int> actives;
  final String name;
  final Function openPopUp;
  final double leftMultiplier;
  final double rightMultiplier;
  final bool paddingTop;
  final bool paddingBottom;

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
    setTargetToActive();
    widget.setTarget.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    widget.setTarget.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Radius leftRadius = Radius.circular(widget.leftMultiplier == 0 ? 0 : 24);
    Radius rightRadius = Radius.circular(widget.rightMultiplier == 0 ? 0 : 24);
    BorderSide borderSide = BorderSide(
      width: 2,
      color: Theme.of(context).primaryColor,
    );

    return Container(
      padding: EdgeInsets.only(
        top: widget.paddingTop ? 2 : 0,
        bottom: widget.paddingBottom ? 2 : 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            width: widget.leftMultiplier * widget.sectionSize,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: leftRadius,
                bottomLeft: leftRadius,
                topRight: rightRadius,
                bottomRight: rightRadius,
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: leftRadius,
                    bottomLeft: leftRadius,
                    topRight: rightRadius,
                    bottomRight: rightRadius,
                  ),
                  border: Border(
                    left: widget.leftMultiplier == 0 ? borderSide : borderSide,
                    right: widget.rightMultiplier == 0 ? BorderSide.none : borderSide,
                    //defaults
                    top: borderSide,
                    bottom: borderSide,
                  ),
                  color: active ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => widget.openPopUp(),
                    child: Container(
                      padding: EdgeInsets.all(4),
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
                                widget.name,
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
          ),
          Container(
            width: widget.rightMultiplier * widget.sectionSize,
          )
        ],
      ),
    );
  }
}