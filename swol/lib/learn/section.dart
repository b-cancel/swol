import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:sticky_headers/sticky_headers.dart';

/*
class InfoSection extends StatelessWidget {
  const InfoSection({
    Key key,
    @required this.headerIcon,
    @required this.headerText,
    @required this.thisExpanded,
    @required this.expandableController,
    @required this.closeOthers,
    this.size,
  }) : super(key: key);

  final IconData headerIcon;
  final String headerText;
  final Widget thisExpanded;
  final ExpandableController expandableController;
  final Function closeOthers;
  final double size;

  @override
  Widget build(BuildContext context) {
    expandableController.addListener((){
      if(expandableController.expanded){
        print(expandableController.toString() + " open so closing others");
        closeOthers(expandableController);
      }
    });

    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnCollapse: false,
        child: Card(
          color: Theme.of(context).primaryColor,
          margin: EdgeInsets.all(8),
          child: ExpandablePanel(
            controller: expandableController,
            //basic booleans
            tapHeaderToExpand: true, //(permanentlyOpen == false),
            tapBodyToCollapse: false,
            hasIcon: true, //(permanentlyOpen == false),
            //other
            header: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 22 + 8.0,
                    child: Icon(
                      headerIcon,
                      size: (size == null) ? 24 : size,
                    ),
                  ),
                  Text(
                    headerText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            /*
            collapsed: Text(
              "collapsed", 
              softWrap: true, 
              maxLines: 2, 
              overflow: TextOverflow.ellipsis,
            ),
            */
            expanded: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  Scrollable.ensureVisible(context);
                },
                child: Container(
                  color: Theme.of(context).cardColor,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(
                    16,
                  ),
                  child: thisExpanded,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/