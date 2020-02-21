//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/excerciseListTile/excerciseTile.dart';
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/widgets/simple/chip.dart';

//widget
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.sectionType,
    @required this.highlightTop,
    @required this.topColor,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final TimeStampType sectionType;
  final bool highlightTop;
  final Color topColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: topColor,
      padding: new EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 8,
      ),
      alignment: Alignment.bottomLeft,
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 16,
          color: highlightTop ? Theme.of(context).primaryColor : Colors.white,
          fontWeight: highlightTop  ? FontWeight.bold : FontWeight.normal,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              title,
            ),
            (subtitle == null)
            ? MyChip(
              chipString: LastTimeStamp.timeStampTypeToString(sectionType).toUpperCase(), 
              inverse: highlightTop,
            )
            : Text(
              subtitle,
            )
          ],
        ),
      ),
    );
  }
}

class SectionBody extends StatelessWidget {
  const SectionBody({
    Key key,
    @required this.topColor,
    @required this.bottomColor,
    @required this.thisGroup,
    @required this.sectionType,
  }) : super(key: key);

  final Color topColor;
  final Color bottomColor;
  final List<AnExcercise> thisGroup;
  final TimeStampType sectionType;

  @override
  Widget build(BuildContext context) {
    return new SliverList(
      delegate: new SliverChildListDelegate([
        Stack(
          children: <Widget>[
            Positioned.fill(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: topColor,
                      child: Container(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: bottomColor,
                      child: Container(),
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
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: thisGroup.length,
                //ONLY false IF Hidden Section
                reverse: (sectionType != TimeStampType.Hidden),
                itemBuilder: (context, index){
                  return ExcerciseTile(
                    excercise: thisGroup[index],
                  );
                },
                separatorBuilder : (context, index) => ListTileDivider(),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class ListTileDivider extends StatelessWidget {
  const ListTileDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Container(
        height: 1,
        color: Theme.of(context).scaffoldBackgroundColor,
      )
    );
  }
}