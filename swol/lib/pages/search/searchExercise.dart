//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:diacritic/diacritic.dart';
import 'package:swol/pages/selection/widgets/workoutSection.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/exerciseListTile/exerciseTile.dart';
import 'package:swol/shared/methods/exerciseData.dart';
import 'package:swol/shared/structs/anExercise.dart';

//internal: other
import 'package:swol/pages/search/searchesData.dart';
import 'package:swol/pages/search/recents.dart';
import 'package:swol/main.dart';

//widget
class SearchExercise extends StatefulWidget {
  @override
  _SearchExerciseState createState() => _SearchExerciseState();
}

class _SearchExerciseState extends State<SearchExercise> {
  //query vars
  List<int> queryResults = new List<int>();
  TextEditingController search = new TextEditingController();

  //NOTE: since they don't change while we are searching
  //we can grab them once and done
  Map<int, AnExercise> exercises = ExerciseData.getExercises();

  //use the text field
  performQuery() {
    query(search.text);
  }

  //async search
  query(String searchString) async {
    //make the search string easier to work with
    searchString = removeDiacritics(searchString).toLowerCase().trim();

    //clear the previous query results
    queryResults.clear();

    //find matching results
    if (searchString.length > 0) {
      //iterate through keys
      List<int> keys = exercises.keys.toList();
      for (int key = 0; key < keys.length; key++) {
        //grab basic data
        int keyIsID = keys[key];
        AnExercise thisExercise = exercises[keyIsID];

        //extract thing we are searching for
        String exerciseName =
            removeDiacritics(thisExercise.name).toLowerCase().trim();
        if (exerciseName.contains(searchString)) {
          queryResults.add(keyIsID);
        }
      }
    }

    //show the query results
    setState(() {});
  }

  //init
  @override
  void initState() {
    search.addListener(performQuery);
    super.initState();
  }

  @override
  void dispose() {
    search.removeListener(performQuery);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showRecentsSearches = (search.text == null || search.text == "");
    bool noRecentSearches = (SearchesData.getRecentSearches().length == 0);
    bool noRecentsToShow = (showRecentsSearches && noRecentSearches);

    //build
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        App.navSpread.value = false;
        return true; //can still pop
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            color: Theme.of(context).primaryColorDark,
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.0),
                    ),
                    color: Theme.of(context).cardColor,
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          App.navSpread.value = false;
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(Icons.keyboard_arrow_left),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: TextField(
                            scrollPadding: EdgeInsets.all(0),
                            textInputAction: TextInputAction.search,
                            onSubmitted: (str) {
                              if (search.text != null && search.text != "") {
                                SearchesData.addToSearches(search.text);
                              }
                            },
                            controller: search,
                            autofocus: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              hintText: "Search",
                            ),
                          ),
                        ),
                      ),
                      (search.text == "")
                          ? Icon(
                              Icons.search,
                            )
                          : GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                search.text = "";
                              },
                              child: Icon(Icons.close)),
                    ],
                  ),
                ),
                Expanded(
                    child: Stack(children: [
                  SearchBody(
                    noRecentsToShow: noRecentsToShow,
                    showRecentsSearches: showRecentsSearches,
                    search: search,
                    queryResults: queryResults,
                    exercises: exercises,
                    updateState: () => setState(() {}),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: (noRecentsToShow)
                        ? Container()
                        : RecentsOrResultsHeader(
                            showRecentsSearches: showRecentsSearches,
                            resultCount: queryResults.length,
                          ),
                  ),
                ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBody extends StatelessWidget {
  const SearchBody({
    Key key,
    @required this.noRecentsToShow,
    @required this.showRecentsSearches,
    @required this.search,
    @required this.exercises,
    @required this.queryResults,
    @required this.updateState,
  }) : super(key: key);

  final bool noRecentsToShow;
  final bool showRecentsSearches;
  final Map<int, AnExercise> exercises;
  final TextEditingController search;
  final List<int> queryResults;
  final Function updateState;

  @override
  Widget build(BuildContext context) {
    if (noRecentsToShow)
      return NoRecentSearches();
    else {
      if (showRecentsSearches) {
        return RecentSearches(
          updateState: () => updateState(),
          search: search,
        );
      } else {
        return SearchResults(
          queryResults: queryResults,
          exercises: exercises,
        );
      }
    }
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({
    Key key,
    @required this.queryResults,
    @required this.exercises,
  }) : super(key: key);

  final List<int> queryResults;
  final Map<int, AnExercise> exercises;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        //spacer for header so that the stack thing lets the curves stay above
        Container(
          height: 56,
        ),
        Card(
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: queryResults.length,
            itemBuilder: (context, index) {
              AnExercise exercise = exercises[queryResults[index]];
              return ExerciseTile(
                key: ValueKey(exercise.id),
                exercise: exercise,
                tileInSearch: true,
              );
            },
            separatorBuilder: (context, index) => ListTileDivider(),
          ),
        ),
      ],
    );
  }
}
