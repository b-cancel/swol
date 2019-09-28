import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Excercise extends StatefulWidget {
  @override
  _ExcerciseState createState() => _ExcerciseState();
}

class _ExcerciseState extends State<Excercise> {
  //control
  TextEditingController controlWeight = new TextEditingController();
  int weight;
  TextEditingController controlReps = new TextEditingController();
  int reps;

  //functions
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

  int strToInt(String str){
    String justNumbers = onlyNumbers(str);
    if(justNumbers == null || justNumbers.length == 0){
      return 0;
    }
    else return int.parse(justNumbers);
  }

  //init
  @override
  void initState() {
    //inits
    weight = 0;
    reps = 0;

    //listen to changes
    controlWeight.addListener((){
      weight = strToInt(controlWeight.text);
      setState(() {
        
      });
    });

    controlReps.addListener((){
      reps = strToInt(controlReps.text);
      setState(() {
        
      });
    });

    //super init
    super.initState();
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Swol Equation Testing"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              //control
              Row(children: <Widget>[
                TextField(
                  controller: controlWeight,
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: controlReps,
                  keyboardType: TextInputType.number,
                )
              ],)
              //equations
              //TODO: add equation drop down
              //TODO: add slider between 1 and 35 reps
            ],
          ),
        ),
      ),
    );
  }
}

/*
1 Brzycki Function
2 McGlothin (or Landers) Function
3 Almazan Function *our own*
4 Epley (or Baechle) Function
5 O`Conner Function
6 Wathan Function
7 Mayhew Function
8 Lombardi Function
*/

/*
% of max 1 Rep Max
1 ->
25 ->
50 ->
75 ->
100
Function Links

muscular tension 
0%
20%
20%
60%
90%
https://www.desmos.com/calculator/ajcgllfbbo

muscular damage
10%
20%
60%
20%
10%
https://www.desmos.com/calculator/yf2tl8pq3b

metabolic stress
90%
60%
20%
20%
0%
https://www.desmos.com/calculator/tkwifmbtpi
*/