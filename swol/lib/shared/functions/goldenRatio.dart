//Golden Ratio naturally looks nice so I'm using it wherever I can
//TODO: apply it for ratio of extended banner
//TODO: apply for stuff in main vertical pages
//TODO: apply for add excercise page
//TODO: actively search for where else to apply it


const int smallNumber = 42219911;
const int largeNumber = 68313251;
const double goldenRatio = largeNumber / smallNumber;
const double total = (smallNumber + largeNumber) * 1.0;
const double smallFraction = smallNumber / total;
const double largeFraction = largeNumber / total;

List<double> measurementToGoldenRatioBS(double number){
  double b = number / (goldenRatio + 1);
  return [number - b, b];
}