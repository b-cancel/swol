//dart
import 'dart:convert';
import 'dart:io';

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:path_provider/path_provider.dart';

double? lerpDouble(num? a, num? b, double t) {
  if (a == null && b == null) {
    return null;
  }

  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}

double timeToLerpValue(
  Duration timePassed, {
  Duration timeTotal: const Duration(minutes: 5),
}) {
  return timePassed.inMicroseconds / timeTotal.inMicroseconds;
}

class StringFilter {
  static String onlyCharactersS2E(String string, int startInc, int endInc) {
    String output = "";
    for (int i = 0; i < string.length; i++) {
      int code = string[i].codeUnitAt(0);
      if (startInc <= code && code <= endInc) {
        output += string[i];
      }
    }
    return output;
  }

  static String onlyNumbers(String string) {
    return onlyCharactersS2E(string, 48, 57);
  }

  static String onlyCharacters(String string) {
    return onlyCharactersS2E(string, 97, 122);
  }
}

class StringPrint {
  static void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static void dprint(String text) {
    debugPrint(text, wrapWidth: 1024);
  }
}

class StringJson {
  static Future<File> nameToFileReference(String fileName) async {
    String localPath = (await getApplicationDocumentsDirectory()).path;
    String filePath = '$localPath/$fileName';
    return File(filePath);
  }

  static String getPrettyJSONString(jsonObject) {
    var encoder = new JsonEncoder.withIndent("     ");
    return encoder.convert(jsonObject);
  }
}
