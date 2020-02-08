//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:carousel_slider/carousel_slider.dart';
import 'package:swol/other/functions/helper.dart';

//widget
class ChangeFunction extends StatefulWidget {
  ChangeFunction({
    @required this.predictionID,
    @required this.arrowsUpDown,
  });

  final ValueNotifier<int> predictionID;
  final bool arrowsUpDown;

  @override
  _ChangeFunctionState createState() => _ChangeFunctionState();
}

class _ChangeFunctionState extends State<ChangeFunction> {
  /*
  setState(() {
          widget.functionString.value = newValue;
          widget.functionIndex.value = Functions.functionToIndex[widget.functionString.value];
        });
  */

  Widget carousel;

  @override
  void initState() {
    //super init
    super.initState();

    //make carousel
    carousel = CarouselSlider(
      height: 36,
      enableInfiniteScroll: false,
      autoPlay: false,
      scrollPhysics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      viewportFraction: 1.0,
      items: Functions.functions.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Center(
              child: Container(
                height: 36,
                child: Center(
                  child: Text(
                    i,
                    style: TextStyle(
                      fontSize: widget.arrowsUpDown ? 18 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  nextFunction() {}

  prevFunction() {}

  @override
  Widget build(BuildContext context) {
    if (widget.arrowsUpDown) {
      return Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Icon(Icons.arrow_drop_up),
              ),
              carousel,
              Container(
                width: MediaQuery.of(context).size.width,
                child: Icon(Icons.arrow_drop_down),
              )
            ],
          ),
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () => nextFunction(),
                    child: Container(),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => prevFunction(),
                    child: Container(),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                    Expanded(
                      child: carousel,
                    ),
                    Container(
                      child: Icon(
                        Icons.arrow_drop_up,
                      ),
                    )
                  ],
                ),
              ),
              Positioned.fill(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () => nextFunction(),
                        child: Container(
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => prevFunction(),
                        child: Container(
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}