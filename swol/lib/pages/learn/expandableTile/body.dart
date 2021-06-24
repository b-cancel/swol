//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shimmer/shimmer.dart';

//widget
class TileBody extends StatelessWidget {
  const TileBody({
    required this.child,
    required this.theOnlyException,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final bool theOnlyException;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  color: Theme.of(context).cardColor,
                  padding: EdgeInsets.only(
                    bottom: 24,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                color: theOnlyException
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).cardColor,
              ),
            ),
            Container(
              height: 128,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
                color: Theme.of(context).primaryColorDark,
              ),
              child: Center(
                child: Shimmer.fromColors(
                  direction: ShimmerDirection.ltr,
                  baseColor: Theme.of(context).primaryColor,
                  highlightColor: Theme.of(context).cardColor,
                  child: Icon(
                    MaterialCommunityIcons.getIconData("chevron-double-down"),
                    size: 36,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
