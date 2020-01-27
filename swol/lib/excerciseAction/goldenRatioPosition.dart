import 'package:flutter/material.dart';
import 'package:swol/shared/functions/goldenRatio.dart';

class GoldenRatioPosition extends StatelessWidget {
  const GoldenRatioPosition({
    Key key,
    @required this.spaceToRedistribute,
    @required this.child,
    this.extendCard: false,
  }) : super(key: key);

  final double spaceToRedistribute;
  final Widget child;
  final bool extendCard;

  @override
  Widget build(BuildContext context) {
    //calculate golden ratio
    List<double> bigToSmall = measurementToGoldenRatioBS(spaceToRedistribute);
    
    //card radius
    Radius cardRadius = Radius.circular(24);

    //return
    return Container(
      height: spaceToRedistribute,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: extendCard ? Theme.of(context).cardColor : Colors.transparent,
            height: bigToSmall[1] - 8,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: 16,
            //color: Colors.red,
            width: MediaQuery.of(context).size.width,
            child: OverflowBox(
              maxHeight: spaceToRedistribute,
              minHeight: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.all(cardRadius),
                ),
                child: child,
              ),
            ),
          ),
          Container(
            //color: Colors.green,
            height: bigToSmall[0] - 8,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}