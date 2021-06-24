//flutter
import 'package:flutter/material.dart';

class SectionDescription extends StatelessWidget {
  const SectionDescription({
    Key key,
    @required this.children,
  }) : super(key: key);

  final List<TextSpan> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            child: RichText(
                textScaleFactor: MediaQuery.of(
                  context,
                ).textScaleFactor,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  children: children,
                )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.white.withOpacity(0.5),
              ))),
            ),
          )
        ],
      ),
    );
  }
}
