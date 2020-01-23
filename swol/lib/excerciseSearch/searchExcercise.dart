//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:diacritic/diacritic.dart';

//internal: shared
import 'package:swol/shared/widgets/simple/scrollToTop.dart';
import 'package:swol/shared/methods/excerciseData.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal: other
import 'package:swol/excerciseListTile/excerciseTile.dart';
import 'package:swol/excerciseSearch/searchesData.dart';
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

  //scroll vars
  final ValueNotifier<bool> onTop = new ValueNotifier(true);
  AutoScrollController autoScrollController;

  performQuery(){
    query(search.text);
  }

  onTopUpdate(){
    ScrollPosition position = autoScrollController.position;
    double currentOffset = autoScrollController.offset;

    //Determine whether we are on the top of the scroll area
    if (currentOffset <= position.minScrollExtent) {
      onTop.value = true;
    }
    else onTop.value = false;
  }

  //init
  @override
  void initState() {
    //query inits
    search.addListener(performQuery);

    //scroll inits
    //auto scroll controller
    autoScrollController = new AutoScrollController();
    autoScrollController.addListener(onTopUpdate);

    //super init
    super.initState();
  }

  @override
  void dispose() { 
    search.removeListener(performQuery);
    autoScrollController.removeListener(onTopUpdate);
    super.dispose();
  }

  query(String searchString) async{
    //make the search string easier to work with
    searchString = removeDiacritics(searchString).toLowerCase().trim();

    //clear the previous query results
    queryResults.clear();

    //find matching results
    if(searchString.length > 0){
      //grab excercises
      Map<int,AnExcercise> temp = ExcerciseData.getExcercises().value;

      //iterate through keys
      List<int> keys = temp.keys.toList();
      for(int key = 0; key < keys.length; key++){
        //grab basic data
        int keyIsID = keys[key];
        AnExcercise thisExcercise = temp[keyIsID]; 
        
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

  //If true clicking the X does nothing
  bool removalLocked = false;
  
  Duration removeDuration = Duration(milliseconds: 300);
  buildSearch(
    BuildContext context, 
    int index, 
    Animation<double> animation,
    {String passedTerm}
  ){
    //make sure we have a valid search term
    String searchTerm;
    if(passedTerm != null) searchTerm = passedTerm;
    else{
      if(SearchesData.getRecentSearches().length == 0){
        searchTerm = "";
      }
      else searchTerm = SearchesData.getRecentSearches()[index];
    }

    //build our widget given that search term
    return SizeTransition(
      sizeFactor: new Tween<double>(
        begin: 0,
        end: 1, 
      ).animate(animation), 
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 16),
        dense: true,
        onTap: (){
          search.text = searchTerm;
          SearchesData.addToSearches(searchTerm);
        },
        title: Text(
          searchTerm,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        trailing: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (){
              //NOTE: this should allow other deletions to complete
              //and therefore letting us confirm lock our or not
              WidgetsBinding.instance.addPostFrameCallback((_){
                if(removalLocked == false){
                  //lock removal
                  removalLocked = true;

                  //make removal
                  AnimatedList.of(context).removeItem(
                    index,
                    (context, animation){
                      return buildSearch(
                        context, 
                        index, 
                        animation,
                        passedTerm: searchTerm,
                      );
                    },
                    duration: removeDuration,
                  );

                  //remove the contact
                  SearchesData.removeFromSearchesAtIndex(index);

                  //NOTE: using a listener doesn't work for some reason
                  Future.delayed(removeDuration, (){
                    //cover edge case
                    if(SearchesData.getRecentSearches().length == 0){
                      setState(() {});
                    }

                    //unlock removal
                    removalLocked = false;
                  });
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Icon(Icons.close),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    bool showRecentsSearches = (search.text == null || search.text == "");
    bool noRecentSearches = (SearchesData.getRecentSearches().length == 0);
    bool noRecentsToShow = (showRecentsSearches && noRecentSearches);

    //create the header IF needed
    Widget cardHeader = Container();
    if(noRecentsToShow == false){
      cardHeader = Container(
        color: Theme.of(context).primaryColorDark,
        padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
        child: DefaultTextStyle(
          style: TextStyle(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                (showRecentsSearches) ? "Recent searches" : "Excercises",
              ),
              (showRecentsSearches) ? Container()
              : Text(
                queryResults.length.toString() + " Found",
              ),
            ],
          ),
        ),
      );
    }

    //create the main content as needed
    Widget mainContent;
    if(noRecentsToShow){
      mainContent = Center(
        child: Text("No recent searches"),
      );
    }
    else{
      if(showRecentsSearches){
        mainContent = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedList(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              reverse: true,
              initialItemCount: SearchesData.getRecentSearches().length,
              itemBuilder: (context, index, animation){
                return buildSearch(context, index, animation);
              },
            ),
            FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: (){
                SearchesData.removeAllSearches();
                setState(() {
                  
                });
              },
              child: Text(
                "Clear search history",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      }
      else{
        mainContent = ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: queryResults.length,
          itemBuilder: (context, index){
            return ExcerciseTile(
              excerciseID: ExcerciseData.getExcercises().value[queryResults[index]].id,
              tileInSearch: true,
            );
          },
        );
      }

      //add styling both list type have
      mainContent = Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: ListView(
              controller: autoScrollController,
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: mainContent,
                ),
                Container(
                  height: 16 + 56.0 + 16,
                )
              ],
            ),
          ),
          ScrollToTopButton(
            onTop: onTop,
            autoScrollController: autoScrollController,
          ),
        ],
      );
    }

    //build
    return WillPopScope(
      onWillPop: ()async{
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
                        onTap: (){
                          search.text = "";
                        },
                        child: Icon(Icons.close)
                      ),
                    ],
                  ),
                ),
                cardHeader,
                Expanded(
                  child: mainContent,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}