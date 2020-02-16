import 'package:flutter/material.dart';

class OnBoardingText extends StatelessWidget {
  OnBoardingText({
    @required this.text,
    this.isLeft: true,
    @required this.isTop,
    this.onTapNext,
    this.onTapPrev,
    @required this.showDone,
  });

  final String text;
  final bool isLeft;
  final bool isTop;
  final Function onTapNext;
  final Function onTapPrev;
  final bool showDone;

  @override
  Widget build(BuildContext context) {
    //NOTE: its seperate so we can change it quickly later
    //if need be
    Function secondaryOnTapNext = (onTapNext == null) ? (){} : () => onTapNext();

    Widget invisibleExpandedButton = Expanded(
      child: GestureDetector(
        onTap: () => secondaryOnTapNext(),
        behavior: HitTestBehavior.opaque, 
        child: Container(
          color: Colors.transparent,
          child: Text(""),
        ),
      ),
    );

    //build
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isLeft 
        ? CrossAxisAlignment.start 
        : CrossAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            onTap: () => secondaryOnTapNext(),
            child: Container(
              color: Colors.transparent,
              alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
              child: Text(
                text,
                textAlign: isLeft ? TextAlign.left : TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                (isLeft == false) ? invisibleExpandedButton : Container(),
                (onTapPrev == null) ? Container()
                : GestureDetector(
                  onTap: () => onTapPrev(),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            highlightColor: Theme.of(context).accentColor,
                            onTap: () => onTapPrev(),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                border: Border.all(
                                  color: isTop ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
                                  width: 2,
                                )
                              ),
                              child: Text(
                                "Back",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (onTapNext == null) ? (){} : () => onTapNext(),
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: (onTapPrev == null) ? 0 : 16,
                        right: 0,
                        top: 16,
                        bottom: 16,
                      ),
                      child: Center(
                        child: Container(
                          child: Text(
                            showDone ? "Got It!" : "Next",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                isLeft ? invisibleExpandedButton : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}