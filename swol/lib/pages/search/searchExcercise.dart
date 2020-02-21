//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:diacritic/diacritic.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/excerciseListTile/excerciseTile.dart';
import 'package:swol/shared/methods/excerciseData.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal: other
import 'package:swol/pages/search/searchesData.dart';
import 'package:swol/pages/search/recents.dart';
import 'package:swol/main.dart';

//widget
class SearchExcercise extends StatefulWidget {
  @override
  _SearchExcerciseState createState() => _SearchExcerciseState();
}

class _SearchExcerciseState extends State<SearchExcercise> {
  //query vars
  List<int> queryResults = new List<int>();
  TextEditingController search = new TextEditingController();

  //NOTE: since they don't change while we are searching 
  //we can grab them once and done
  Map<int, AnExcercise> excercises = ExcerciseData.getExcercises();

  //use the text field
  performQuery(){
    query(search.text);
  }

  //async search
  query(String searchString) async{
    //make the search string easier to work with
    searchString = removeDiacritics(searchString).toLowerCase().trim();

    //clear the previous query results
    queryResults.clear();

    //find matching results
    if(searchString.length > 0){
      //TODO: there is a much better way to do this if this slows things down
      //iterate through keys
      List<int> keys = excercises.keys.toList();
      for(int key = 0; key < keys.length; key++){
        //grab basic data
        int keyIsID = keys[key];
        AnExcercise thisExcercise = excercises[keyIsID]; 
        
        //extract thing we are searching for
        String excerciseName = removeDiacritics(thisExcercise.name).toLowerCase().trim(); 
        if(excerciseName.contains(searchString)){
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
  Widget build(BuildContext context){
    bool showRecentsSearches = (search.text == null || search.text == "");
    bool noRecentSearches = (SearchesData.getRecentSearches().length == 0);
    bool noRecentsToShow = (showRecentsSearches && noRecentSearches);

    //build
    return WillPopScope(
      onWillPop: () async{
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
                        onTap: (){
                          App.navSpread.value= false;
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
                            onSubmitted: (str){
                              if(search.text != null && search.text != ""){
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
                      (search.text == "") ? Icon(
                        Icons.search,
                      )
                      : GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          search.text = "";
                        },
                        child: Icon(Icons.close)
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      SearchBody(
                        noRecentsToShow: noRecentsToShow, 
                        showRecentsSearches: showRecentsSearches, 
                        search: search, 
                        queryResults: queryResults, 
                        excercises: excercises,
                        updateState: () => setState(() {}),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: (noRecentsToShow) ? Container() : RecentsOrResultsHeader(
                          showRecentsSearches: showRecentsSearches, 
                          resultCount: queryResults.length,
                        ),
                      ),
                    ]
                  )
                ),
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
    @required this.excercises,
    @required this.queryResults,
    @required this.updateState,
    
  }) : super(key: key);

  final bool noRecentsToShow;
  final bool showRecentsSearches;
  final Map<int, AnExcercise> excercises;
  final TextEditingController search;
  final List<int> queryResults;
  final Function updateState;
  

  @override
  Widget build(BuildContext context) {
    if(noRecentsToShow) return NoRecentSearches();
    else{
      if(showRecentsSearches){
        return RecentSearches(
          updateState: () => updateState(),
          search: search,
        );
      }
      else{
        return SearchResults(
          queryResults: queryResults, 
          excercises: excercises,
        );
      }
    }
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({
    Key key,
    @required this.queryResults,
    @required this.excercises,
  }) : super(key: key);

  final List<int> queryResults;
  final Map<int, AnExcercise> excercises;

  @override
  Widget build(BuildContext context) {
    Radius cardRadius = Radius.circular(24);
    return ListView(
      children: <Widget>[
        //spacer for header so that the stack thing lets the curves stay above
        Container(
          height: 56,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: queryResults.length,
          itemBuilder: (context, index){
            return ClipRRect(
              borderRadius: BorderRadius.only(
                //top
                topLeft: index == 0 ? cardRadius : Radius.zero,
                topRight: index == 0 ? cardRadius : Radius.zero,
                //bottom
                bottomLeft: index == (queryResults.length - 1) ? cardRadius : Radius.zero,
                bottomRight: index == (queryResults.length - 1) ? cardRadius : Radius.zero,
              ),
              child: Container(
                color: Theme.of(context).cardColor,
                child: ExcerciseTile(
                  excercise: excercises[queryResults[index]],
                  tileInSearch: true,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}