//O'Conner
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const int defaultFunctionIndex = 4; 

List<String> functions = [
  "Brzycki Formula", // 0
  "McGlothin (or Landers) Formula", // 1
  "Almazan Formula", // 2
  "Epley (or Baechle) Formula", // 3
  "O'Conner Formula", // 4
  "Wathan Formula", // 5
  "Mayhew Formula", // 6
  "Lombardi Formula", // 7
];

Map<String, int> functionToIndex = {
  functions[0] : 0,
  functions[1] : 1,
  functions[2] : 2,
  functions[3] : 3,
  functions[4] : 4,
  functions[5] : 5,
  functions[6] : 6,
  functions[7] : 7,
};