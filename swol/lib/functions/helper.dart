//O'Conner
int defaultFunctionIndex = 4; 

List<String> functions = [
  "Brzycki", // 0
  "McGlothin (or Landers)", // 1
  "Almazan", // 2
  "Epley (or Baechle)", // 3
  "O'Conner", // 4
  "Wathan", // 5
  "Mayhew", // 6
  "Lombardi", // 7
];

Map<String, int> functionToIndex = {
  "Brzycki" : 0,
  "McGlothin (or Landers)" : 1,
  "Almazan" : 2,
  "Epley (or Baechle)" : 3,
  "O'Conner" : 4,
  "Wathan" : 5,
  "Mayhew" : 6,
  "Lombardi" : 7,
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