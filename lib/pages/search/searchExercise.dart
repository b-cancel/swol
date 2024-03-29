//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:diacritic/diacritic.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:swol/pages/selection/widgets/workoutSection.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/exerciseListTile/exerciseTile.dart';
import 'package:swol/shared/methods/exerciseData.dart';
import 'package:swol/shared/structs/anExercise.dart';

//internal: other
import 'package:swol/pages/search/searchesData.dart';
import 'package:swol/pages/search/recents.dart';
import 'package:swol/main.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';

//widget
class SearchExercise extends StatefulWidget {
  @override
  _SearchExerciseState createState() => _SearchExerciseState();
}

class _SearchExerciseState extends State<SearchExercise> {
  //query vars
  List<int> queryResults = [];
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
        AnExercise? thisExercise = exercises[keyIsID];

        //extract thing we are searching for
        if (thisExercise != null) {
          String exerciseName =
              removeDiacritics(thisExercise.name).toLowerCase().trim();
          if (exerciseName.contains(searchString)) {
            queryResults.add(keyIsID);
          }
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
    bool showRecentsSearches = (search.text == "");
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
        backgroundColor: Theme.of(context).primaryColorDark,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SearchBar(
                search: search,
              ),
              Expanded(
                child: (noRecentsToShow ||
                        (search.text.length > 0 && queryResults.length == 0))
                    ? CustomScrollView(
                        physics: BouncingScrollPhysics(),
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            fillOverscroll: true,
                            child: Center(
                              child: Text(
                                noRecentsToShow
                                    ? "No Recent Searches"
                                    : "No Results",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : CustomScrollView(
                        physics: BouncingScrollPhysics(),
                        slivers: [
                          SliverStickyHeader(
                            header: Column(
                              children: <Widget>[
                                Visibility(
                                  visible: noRecentsToShow == false,
                                  child: RecentsOrResultsHeader(
                                    showRecentsSearches: showRecentsSearches,
                                    resultCount: queryResults.length,
                                  ),
                                ),
                              ],
                            ),
                            sliver: SliverList(
                              delegate: new SliverChildListDelegate(
                                [
                                  SearchBody(
                                    noRecentsToShow: noRecentsToShow,
                                    showRecentsSearches: showRecentsSearches,
                                    search: search,
                                    queryResults: queryResults,
                                    exercises: exercises,
                                    updateState: () => setState(() {}),
                                    statusBar:
                                        MediaQuery.of(context).padding.top,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.search,
  }) : super(key: key);

  final TextEditingController search;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorDark,
      child: Container(
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
                    if (search.text != "") {
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
            Conditional(
              condition: (search.text == ""),
              ifTrue: Icon(
                Icons.search,
              ),
              ifFalse: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  search.text = "";
                },
                child: Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBody extends StatelessWidget {
  const SearchBody({
    Key? key,
    required this.noRecentsToShow,
    required this.showRecentsSearches,
    required this.search,
    required this.exercises,
    required this.queryResults,
    required this.updateState,
    required this.statusBar,
  }) : super(key: key);

  final bool noRecentsToShow;
  final bool showRecentsSearches;
  final Map<int, AnExercise> exercises;
  final TextEditingController search;
  final List<int> queryResults;
  final Function updateState;
  final double statusBar;

  @override
  Widget build(BuildContext context) {
    if (noRecentsToShow) {
      return Container();
    } else {
      if (showRecentsSearches) {
        return RecentSearches(
          updateState: () => updateState(),
          search: search,
        );
      } else {
        return SearchResults(
          search: search,
          queryResults: queryResults,
          exercises: exercises,
        );
      }
    }
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({
    Key? key,
    required this.queryResults,
    required this.search,
    required this.exercises,
  }) : super(key: key);

  final List<int> queryResults;
  final TextEditingController search;
  final Map<int, AnExercise> exercises;

  @override
  Widget build(BuildContext context) {
    return Card(
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
          int res = queryResults[index];
          AnExercise exercise = exercises[res]!;
          return ExerciseTile(
            key: ValueKey(exercise.id),
            exercise: exercise,
            search: search,
          );
        },
        separatorBuilder: (context, index) => ListTileDivider(),
      ),
    );
  }
}
