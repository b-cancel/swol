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

String onlyCharactersS2E(String string, int startInc, int endInc){
  String output = "";
  for(int i = 0; i < string.length; i++){
    int code = string[i].codeUnitAt(0);
    if(startInc <= code && code <= endInc){
      output += string[i];
    }
  }
  return output;
}

String onlyNumbers(String string){
  return onlyCharactersS2E(string, 48, 57);
}

String onlyCharacters(String string){
  return onlyCharactersS2E(string, 97, 122);
}

Future<File> nameToFileReference(String fileName) async{
  String localPath = (await getApplicationDocumentsDirectory()).path;
  String filePath = '$localPath/$fileName';
  return File(filePath);
}

String getPrettyJSONString(jsonObject){
   var encoder = new JsonEncoder.withIndent("     ");
   return encoder.convert(jsonObject);
}

void printWrapped(String text) {
  final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}


void dprint(String text){
  debugPrint(text, wrapWidth: 1024);
}