//Format for a word and definition
import 'package:flutter/material.dart';

//widgets
class ADefinition extends StatelessWidget {
  ADefinition({
    this.word,
    this.definition,
    this.extra,
    this.lessBottomPadding: false,
  });

  final String word;
  final List<TextSpan> definition;
  final List<TextSpan> extra;
  final bool lessBottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: lessBottomPadding ? 8 : 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _WordToDefine(word: word),
          Container(
            width: 16,
          ),
          Expanded(
            child: _DefinitionOfWord(definition: definition, extra: extra),
          )
        ],
      ),
    );
  }
}

class _DefinitionOfWord extends StatelessWidget {
  const _DefinitionOfWord({
    Key key,
    @required this.definition,
    @required this.extra,
  }) : super(key: key);

  final List<TextSpan> definition;
  final List<TextSpan> extra;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(12.0),
          bottomLeft: const Radius.circular(12.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 2,
            ),
            child: RichText(
              textScaleFactor: MediaQuery.of(
                context,
              ).textScaleFactor,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                ),
                children: definition,
              ),
            ),
          ),
          (extra == null)
              ? Container(
                  height: 8,
                )
              : Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8,
                        bottom: 12,
                      ),
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 4,
                        bottom: 8,
                      ),
                      child: RichText(
                        textScaleFactor: MediaQuery.of(
                          context,
                        ).textScaleFactor,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                          children: extra,
                        ),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}

class _WordToDefine extends StatelessWidget {
  const _WordToDefine({
    Key key,
    @required this.word,
  }) : super(key: key);

  final String word;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: new BorderRadius.only(
          bottomRight: const Radius.circular(12.0),
          topRight: const Radius.circular(12.0),
        ),
      ),
      child: Stack(
        children: <Widget>[
          //longest term to keep divider in same location
          Opacity(
            opacity: 0,
            child: Text(
              "1 Rep Max",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          //actual term
          Text(
            word,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
