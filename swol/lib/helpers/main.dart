import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  double closedHeight;
  double openHeight;
  double fullWidth;
  double factor;

  PersistentHeaderDelegate({
    @required this.closedHeight,
    @required this.openHeight,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent){
    return Container(
      height: openHeight,
      color: Theme.of(context).primaryColorDark,
      child: FractionallySizedBox(
        widthFactor: 0.65,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 2,
            ),
            child: Text(
              "Exercises",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => openHeight;

  @override
  double get minExtent => closedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class SWOL extends StatelessWidget {
  const SWOL({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: FittedBox(
        fit: BoxFit.cover,
        child: DefaultTextStyle(
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          child: Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(1, 0),
                child: Text(
                  "S W O L",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(-1, 0),
                child: Text(
                  "S W O L",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              Text(
                "S W O L",
                style: TextStyle(
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PumpingHeart extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  PumpingHeart({
    Key key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 2400),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        assert(size != null),
        super(key: key);

  final Color color;
  final double size;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;
  final AnimationController controller;

  @override
  _PumpingHeartState createState() => _PumpingHeartState();
}

class _PumpingHeartState extends State<PumpingHeart>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _anim1;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
    _anim1 = Tween(begin: 1.0, end: 1.25).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: MyCurve()),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _anim1,
      child: _itemBuilder(0),
    );
  }

  Widget _itemBuilder(int index) {
    return widget.itemBuilder != null
      ? widget.itemBuilder(context, index)
      : Icon(
        FontAwesomeIcons.solidHeart,
        color: widget.color,
        size: widget.size,
      );
  }
}

List<String> indexToChar = [
  "y","m","w","d","h","m","s","milli","micro"
];

String formatDuration(Duration timeSince, {
  bool showYears: true, //365 days
  bool showMonths: true, //30 days
  bool showWeeks: true, //7 days
  bool showDays: true, //24 hrs
  bool showHours: true, //60 minutes
  bool showMinutes: true, //60 seconds
  //TODO: left true for testing later
  bool showSeconds: true, //1000 milliseconds
  bool showMilliseconds: false,
  bool showMicroseconds: false,
}){
  //setup vars
  int years = 0;
  int months = 0;
  int weeks = 0;
  int days = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int milliseconds = 0;
  int microseconds = 0;

  //digest it given the variables
  if(showYears && timeSince.inDays > 0){
    years = timeSince.inDays ~/ 365;
    timeSince = timeSince - Duration(days: (365 * years));
  }

  if(showMonths && timeSince.inDays > 0){
    months = timeSince.inDays ~/ 30;
    timeSince = timeSince - Duration(days: (30 * months));
  }

  if(showWeeks && timeSince.inDays > 0){
    weeks = timeSince.inDays ~/ 7;
    timeSince = timeSince - Duration(days: (7 * weeks));
  }

  if(showDays && timeSince.inDays > 0){
    days = timeSince.inDays;
    timeSince = timeSince - Duration(days: days);
  }

  if(showHours && timeSince.inHours > 0){
    hours = timeSince.inHours;
    timeSince = timeSince - Duration(hours: hours);
  }

  if(showMinutes && timeSince.inMinutes > 0){
    minutes = timeSince.inMinutes;
    timeSince = timeSince - Duration(minutes: minutes);
  }

  if(showSeconds && timeSince.inSeconds > 0){
    seconds = timeSince.inSeconds;
    timeSince = timeSince - Duration(seconds: seconds);
  }

  if(showMilliseconds && timeSince.inMilliseconds > 0){
    milliseconds = timeSince.inMilliseconds;
    timeSince = timeSince - Duration(milliseconds: milliseconds);
  }

  if(showMilliseconds && timeSince.inMicroseconds > 0){
    microseconds = timeSince.inMicroseconds;
  }

  //create string
  String output = "";
  List<int> times = [
    years, 
    months, 
    weeks, 
    days, 
    hours, 
    minutes, 
    seconds, 
    milliseconds, 
    microseconds,
  ];
  
  //loop through and generate
  for(int i = 0; i < times.length; i++){
    if(times[i] != 0){
      output += (times[i].toString() + indexToChar[i] + " ");
    }
  }

  //ret
  return output;
}