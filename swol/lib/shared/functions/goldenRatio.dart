//Golden Ratio naturally looks nice so I'm using it wherever I can
//TODO: apply it for ratio of extended banner
//TODO: apply for stuff in main vertical pages
//TODO: apply for add excercise page
//TODO: actively search for where else to apply it

const double goldenRatio = 1.61803398875;
const double total = (42219911 + 68313251.0);
const double smallFraction = 42219911 / total;
const double largeFraction = 68313251 / total;

//the golden ratio = 1.61803398875
//its fraction version = 68313251/42219911
//its total = 68313251 + 42219911 = 110533162

//so a > b
//1. a / b = 1.61803398875
//2. a + b = total

//solution
//from 2: a = total - b
//replace a in 1
//from 1: (total - b) / b = 1.61803398875

//reconfigure with symolab

List<double> measurementToGoldenRatioBS(double number){
  double b = number / (goldenRatio + 1);
  return [number - b, b];
}