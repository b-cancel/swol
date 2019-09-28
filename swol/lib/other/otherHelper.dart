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