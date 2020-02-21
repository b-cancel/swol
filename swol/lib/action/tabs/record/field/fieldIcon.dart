//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/action/shared/tooltips/setToolTips.dart';

//widget
class TappableIcon extends StatefulWidget {
  const TappableIcon({
    Key key,
    @required this.focusNode,
    @required this.iconSize,
    @required this.borderSize,
    @required this.icon,
    @required this.isLeft,
  }) : super(key: key);

  final FocusNode focusNode;
  final double iconSize;
  final double borderSize;
  final Widget icon;
  final bool isLeft;

  @override
  _TappableIconState createState() => _TappableIconState();
}

class _TappableIconState extends State<TappableIcon> {
  updateState() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    //super inits
    super.initState();

    //add listener
    widget.focusNode.addListener(updateState);
  }

  @override
  void dispose() {
    //remove listener
    widget.focusNode.removeListener(updateState);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Radius tinyCurve = Radius.circular(12);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.isLeft)
          showWeightToolTip(context);
        else
          showRepsToolTip(context);
      },
      child: Container(
        padding: EdgeInsets.only(
          right: widget.isLeft ? 8 : 0,
          left: widget.isLeft ? 0 : 8,
          bottom: widget.isLeft ? 4 : 0,
          top: widget.isLeft ? 0 : 4,
        ),
        child: Container(
          width: widget.iconSize,
          height: widget.iconSize,
          decoration: BoxDecoration(
            color: widget.focusNode.hasFocus ? Theme.of(context).accentColor : Colors.transparent,
            borderRadius: BorderRadius.only(
              topRight: widget.isLeft ? tinyCurve : Radius.zero,
              bottomLeft: widget.isLeft ? Radius.zero : tinyCurve,
            ),
            border: Border.all(
              color: widget.focusNode.hasFocus
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColorLight,
              width: widget.borderSize,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Transform.translate(
                  offset:
                      Offset(widget.borderSize * (widget.isLeft ? -1 : 1), 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.focusNode.hasFocus ? Theme.of(context).accentColor : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topRight: widget.isLeft ? tinyCurve : Radius.zero,
                        bottomLeft: widget.isLeft ? Radius.zero : tinyCurve,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: widget.isLeft ? 0 : 4,
                    right: widget.isLeft ? 4 : 0,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: widget.icon,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}