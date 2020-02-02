import 'package:flutter/material.dart';
import 'package:swol/shared/widgets/simple/heros/curveMod.dart';

class NotesHero extends StatelessWidget {
  const NotesHero({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'note',
      createRectTween: (begin, end) {
        return CustomRectTween(a: begin, b: end);
      },
      child: Material(
        color: Colors.transparent,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            "Notes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}