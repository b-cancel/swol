import 'package:flutter/material.dart';
import 'package:swol/other/functions/helper.dart';


  //ratio (for 1 by 1 square we need about 5 times less data on the x axis)
  //screen: 19:9
  //data: 351:37 = > 100:10

  List<List> theValues;

  testing() async{
    theValues = new List<List>();
    Map<int,int> percentDeviationToCount = new Map<int,int>();
    Map<int,int> percentDeviationToSmallestRepCountWithIt = new Map<int,int>();
    int differentDeviationValues = 0;
    
    //Max Weight: guesstimate of largest lift for average lifter for any excercise
    for(int weight = 0; weight < 750; weight++){ 
      bool inWeightRange = 25 < weight && weight < 50;

      //Max Reps: up to before 37 because any larger will crash it
      for(int reps = 0; reps < 38; reps++){ 
        //NOTE: actual data is weight + 1, reps + 1
        List res = Functions.getOneRepMaxValues(weight + 1, reps + 1);
        //NOTE: we use standard deviation BECAUSE... ultimately what we are trying to explain is that
        //the more weight AND less reps you do (as a consequence) the more accurate your calculation will be
        //regardless of the equation used      

        //For each of the values we can calculate a percent to refer to how significant the standard deviation is
        //HOWEVER, once again... we aren't trying to discourage users from using a particular equation here
        //we are simply trying to get the to do less reps (or atleas a managable ammount)
        //so we work off of the mean passed in possition 1
        int deviation = res[2].toInt();
        int percentDeviation = ((res[1] == 0 || deviation == 0) ? 0 : (res[2] / res[1]) * 100).toInt();

        /*
        print(
          (weight + 1).toString() 
          + " x " 
          + (reps + 1).toString()
          //+ " => max: " + res[0].toString()
          + "\n& dev: " + deviation.toString()
          + "\nwhich is: " + percentDeviation.toString() + "%"
        );
        */ 

        //make sure this percent deviation has been found before
        if(percentDeviationToCount.containsKey(percentDeviation) == false){
          print(
            (weight + 1).toString() 
            + " x " 
            + (reps + 1).toString()
            //+ " => max: " + res[0].toString()
            + "\n& dev: " + deviation.toString()
            + "\nwhich is: " + percentDeviation.toString() + "%"
          );

          differentDeviationValues += 1;
          percentDeviationToCount[percentDeviation] = 0;
          percentDeviationToSmallestRepCountWithIt[percentDeviation] = reps;
        }

        //keep track of how many times this percent deviation has been found before
        percentDeviationToCount[percentDeviation] = (percentDeviationToCount[percentDeviation] + 1);

        //keep track of the smallest rep count that can produce this percentDeviation
        if(reps < percentDeviationToSmallestRepCountWithIt[percentDeviation]){
          percentDeviationToSmallestRepCountWithIt[percentDeviation] = reps;
        }

        //make sure this row exits
        if(reps == 0){
          theValues.add(new List());
        }

        //add col value to this row (Right Now: just adding the standard deviation)
        theValues[weight].add(res[2]);
      }
      if(inWeightRange) print("----------------");
    }

    //indicates we can go to our data analysis page
    print("----------------------------DONE---------------");
    print(differentDeviationValues.toString() + " VS " + percentDeviationToCount.keys.toList().length.toString());

    List theKeys = percentDeviationToCount.keys.toList();
    List<int> theKeysInt = theKeys as List<int>;
    theKeysInt.sort();
    for(int i = 0; i < theKeys.length; i++){
      int key = theKeysInt[i];
      print(
        key.toString() 
        + " appeared " 
        + percentDeviationToCount[key].toString() 
        + " times, start at rep count " 
        + (percentDeviationToSmallestRepCountWithIt[key] + 1).toString()
      );
    }

    //Conclusions
    //1. no matter how large we make the weight
    //    as long as we keep the rep count below 36
    //    we get consistently that the more reps you do the less accurate the equation becomes
    //    this is simply because since we are within all of the equations limits
    //    when we get mean and std dev and percent dev all the equations essentially become one very large one
    //2. no matter how "small" our weight is if we increase reps about 36 we will get wonky results
    //    since some of the functions now becoem peice wise
    //    @100 reps max: this where consistent until 24% std dev appeared 748 times, start at rep count 24
    //      this behavior starts when the reps (passed to the functions) are above 38
    //      because ofcourse the "bryzcki" function can't use the nearly identical "mcGlothinOrLanders" function
    //      to cover its gaps
    //    NOTE: this will only get worse when you reach the limits of the almazan function 
    //      and have to use "epleyOrBaechle" for 3 results (bryzcki, mcGlothinOrLanders, almazan) => epleyOrBaechle
    //      NOTE: only using the functions that aren't using backups to get stdDev and mean made no difference
    //3. any percent of error larger than 25 is red
    //- larger than 25 -> red
    //- larger than 20 -> orange
    //- larger than 15 -> yellow
    //- larger than 10 -> green
    //- larger than 5 -> blue
    //- anything else not 0 -> purple

    print("----------------------------DONE2---------------");
  }

class TestWidget extends StatelessWidget {
  TestWidget({
    @required this.values,
  });

  List<List> values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
      ),
    );
  }
}