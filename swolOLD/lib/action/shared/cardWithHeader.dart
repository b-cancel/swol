//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/functions/goldenRatio.dart';

//widget
class CardWithHeader extends StatelessWidget {
  CardWithHeader({
    @required this.header,
    @required this.child,
    this.aLittleSmaller: false,
    this.topRound: true,
  });

  final String header;
  final Widget child;
  final bool aLittleSmaller;
  final bool topRound;

  @override
  Widget build(BuildContext context) {
    //defautl variables
    Radius cardRadius = Radius.circular(24);
    Radius hideRadius = Radius.circular(48);

    //calculate header size
    List<double> goldenBS = measurementToGoldenRatioBS(
      MediaQuery.of(context).size.width,
    );

    List<double> golden2BS = measurementToGoldenRatioBS(
      goldenBS[1],
    );

    //return
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.only(
          topLeft: topRound ? cardRadius : Radius.zero,
          topRight: topRound ? cardRadius : Radius.zero,
          //guarantee bottom never show
          bottomLeft: hideRadius,
          bottomRight: hideRadius,
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: goldenBS[0] - (aLittleSmaller ? golden2BS[1] : 0),
                  padding: EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: topRound
                            ? Colors.white
                            : Theme.of(context).primaryColorDark,
                      ),
                      child: Text(header),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CloseSetRecordButton(),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.all(cardRadius),
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class CloseSetRecordButton extends StatelessWidget {
  const CloseSetRecordButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.black,
        ),
      ),
      onPressed: () {
        print("done");
      },
      child: Text(
        "Done",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
