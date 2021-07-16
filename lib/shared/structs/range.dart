import 'package:flutter/material.dart';

class Range {
  final String name;
  final Widget left;
  final Widget right;
  final Function onTap;
  final int startSeconds;
  final int endSeconds;

  Range({
    required this.name,
    required this.left,
    required this.right,
    required this.onTap,
    required this.startSeconds,
    required this.endSeconds,
  });
}
