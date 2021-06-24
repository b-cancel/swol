import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swol/shared/widgets/simple/scrollToTop.dart';

class CardWithScrollToTop extends StatefulWidget {
  const CardWithScrollToTop({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _CardWithScrollToTopState createState() => _CardWithScrollToTopState();
}

class _CardWithScrollToTopState extends State<CardWithScrollToTop> {
  //scroll vars
  final ValueNotifier<bool> onTop = new ValueNotifier(true);
  final AutoScrollController autoScrollController = new AutoScrollController();

  //on top udpate
  onTopUpdate() {
    ScrollPosition position = autoScrollController.position;
    double currentOffset = autoScrollController.offset;

    //Determine whether we are on the top of the scroll area
    if (currentOffset <= position.minScrollExtent) {
      onTop.value = true;
    } else
      onTop.value = false;
  }

  @override
  void initState() {
    autoScrollController.addListener(onTopUpdate);
    super.initState();
  }

  @override
  void dispose() {
    autoScrollController.removeListener(onTopUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            controller: autoScrollController,
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                clipBehavior: Clip.hardEdge,
                child: widget.child,
              ),
              Container(
                height: 16 + 56.0 + 16,
              )
            ],
          ),
        ),
        ScrollToTopButton(
          onTop: onTop,
          autoScrollController: autoScrollController,
        ),
      ],
    );
  }
}
