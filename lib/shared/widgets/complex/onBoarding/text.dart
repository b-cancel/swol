import 'package:flutter/material.dart';

class OnBoardingText extends StatelessWidget {
  OnBoardingText({
    required this.text,
    this.isLeft: true,
    required this.isTop,
    this.onTapNext,
    this.onTapPrev,
    required this.showDone,
  });

  final String text;
  final bool isLeft;
  final bool isTop;
  final Function? onTapNext;
  final Function? onTapPrev;
  final bool showDone;

  @override
  Widget build(BuildContext context) {
    //NOTE: its seperate so we can change it quickly later
    //if need be(onTapNext == null) ? null : () => onTapNext!(),

    Widget invisibleExpandedButton = Expanded(
      child: Container(
        color: Colors.transparent,
        child: Text(""),
      ),
    );

    //build
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: <Widget>[
          Container(
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
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  (isLeft == false) ? invisibleExpandedButton : Container(),
                  (onTapPrev == null)
                      ? Container()
                      : Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            highlightColor: Theme.of(context).accentColor,
                            onTap:
                                onTapPrev != null ? () => onTapPrev!() : null,
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
                                    color: isTop
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).primaryColorDark,
                                    width: 2,
                                  )),
                              child: Text(
                                "Back",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                  Material(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    color: Colors.blue,
                    child: InkWell(
                      onTap: (onTapNext == null) ? null : () => onTapNext!(),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Center(
                          child: Container(
                            child: Text(
                              showDone ? "Got It!" : "Next",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
          ),
        ],
      ),
    );
  }
}
