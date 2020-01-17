//Golden Ratio naturally looks nice so I'm using it wherever I can

const double goldenRatio = 1.61803398875;

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

List<double> measurementToGoldenRatio(double number){
  double b = number / (goldenRatio + 1);
  return [number - b, b];
}