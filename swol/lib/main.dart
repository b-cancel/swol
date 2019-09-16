import 'package:flutter/material.dart';
import 'package:swol/excercise.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWOL',
      home: ExcerciseList(),
    );
  }
}

class ExcerciseList extends StatefulWidget {
  @override
  _ExcerciseListState createState() => _ExcerciseListState();
}

class _ExcerciseListState extends State<ExcerciseList> {
  @override
  void initState() {
    //auto navigate to excercise widget
    WidgetsBinding.instance.addPostFrameCallback((_){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context){
            return Excercise();
          },
        ),
      );
    });

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}