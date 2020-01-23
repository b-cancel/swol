//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

//internal
import 'package:swol/learn/expandableTile/header.dart';
import 'package:swol/learn/expandableTile/body.dart';

//widget
class ExpandableTile extends StatefulWidget {
  const ExpandableTile({
    Key key,
    @required this.autoScrollController,
    @required this.index,
    @required this.isOpen,
    @required this.headerIcon,
    @required this.headerText,
    @required this.expandedChild,
    this.theOnlyException: true,
    this.size,
  }) : super(key: key);

  final AutoScrollController autoScrollController;
  final int index;
  final ValueNotifier<bool> isOpen;
  final IconData headerIcon;
  final String headerText;
  final Widget expandedChild;
  final double size;
  final bool theOnlyException;
  //style options

  @override
  _ExpandableTileState createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  @override
  Widget build(BuildContext context) {
    //eventhough it looks kinda ugly when no sections are open
    //not letting the user do this messes with usability
    openOrClose(){
      widget.isOpen.value = !widget.isOpen.value;
      setState(() {});
    }

    //build
    return AutoScrollTag(
      controller: widget.autoScrollController,
      key: ValueKey(widget.index),
      index: widget.index,
      child: SliverStickyHeader(
        header: AnimatedBuilder(
          animation: widget.isOpen,
          builder: (context, child){
            return TileHeader(
              headerIcon: widget.headerIcon,
              headerText: widget.headerText,
              size: widget.size,
              openOrClose: () => openOrClose(),
              isOpen: widget.isOpen,
            );
          },
        ),
        sliver: new SliverList(
          delegate: new SliverChildListDelegate([
            AnimatedBuilder(
              animation: widget.isOpen,
              builder: (context, child){
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (widget, animation){
                    return SizeTransition(
                      child: widget,
                      sizeFactor: Tween<double>(
                        begin: 0, 
                        end: 1,
                      ).animate(animation),
                    );
                  },
                  child: (widget.isOpen.value) 
                  ? TileBody(
                    child: widget.expandedChild,
                    theOnlyException: widget.theOnlyException,
                  )
                  : Container(
                    key: UniqueKey(),
                    height: 0,
                    width: MediaQuery.of(context).size.width,
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}