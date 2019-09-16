import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swol/utils/data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //its specifically designed for portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    //build main
    return MaterialApp(
      title: 'SWOL',
      theme: ThemeData.dark(),
      home: ExcerciseSelect(),
    );
  }
}

class ExcerciseSelect extends StatelessWidget {
  final AutoScrollController autoScrollController = new AutoScrollController();

  @override
  Widget build(BuildContext context) {
    double expandHeight = MediaQuery.of(context).size.height / 3;
    expandHeight = (expandHeight < 40) ? 40 : expandHeight; 

    return Scaffold(
      body: CustomScrollView(
        controller: autoScrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColorDark,
            expandedHeight: expandHeight,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text("Workouts"),
            ),
          ),
          ExcerciseList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){

        },
        icon: Icon(Icons.add),
        label: Text("Add New"),
      ),
    );
  }
}

class ExcerciseList extends StatefulWidget {
  @override
  _ExcerciseListState createState() => _ExcerciseListState();
}

class _ExcerciseListState extends State<ExcerciseList> {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: workoutsInit(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          //create list of items
          List<Widget> inSliver = new List<Widget>();
          for(int i = 0; i < 100; i ++) inSliver.add(Text(i.toString()));

          //add spacer to not occlude lower items
          inSliver.add(
            Container(
              height: 16 + 48.0 + 16,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16),
              child: Text(
                inSliver.length.toString() + " Workouts",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          );

          //build
          return SliverList(
            delegate: new SliverChildListDelegate(
              inSliver,
            ),
          );
        }
        else{
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }
    );
  }
}