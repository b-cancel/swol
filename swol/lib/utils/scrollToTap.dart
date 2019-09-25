//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:vector_math/vector_math_64.dart' as vect;

//internal
import 'package:swol/utils/vibrate.dart';

class ScrollToTopButton extends StatefulWidget {
  const ScrollToTopButton({
    Key key,
    @required this.onTop,
    @required this.autoScrollController,
  }) : super(key: key);

  final ValueNotifier<bool> onTop;
  final AutoScrollController autoScrollController;

  @override
  _ScrollToTopButtonState createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  @override
  void initState() {
    //whenever on top changes we update the button
    widget.onTop.addListener((){
      setState(() {
        
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 16),
        child:  AnimatedContainer(
          duration: Duration(milliseconds: 200),
          transform: Matrix4.translation(
            vect.Vector3(
              0, 
              (widget.onTop.value) ? (16.0 + 56) : 0.0, 
              0,
            ),
          ),
          child: FloatingActionButton(
            heroTag: 'toTop',
            backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.5),
            onPressed: (){
              vibrate();
              //scrollToIndex -> too slow to find index
              //jumpTo -> happens instant but scrolling to top should have some animation
              //NOTE: I ended up going with jump since animate was not fully opening the prompt
              widget.autoScrollController.jumpTo(0);
            },
            //slightly shift the combo of the two icons
            child: FittedBox(
              fit: BoxFit.contain,
              child: Transform.translate(
                offset: Offset(0,-12), //-4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 12,
                      child: Icon(
                        Icons.minimize,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Container(
                      height: 12,
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white.withOpacity(0.5),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}