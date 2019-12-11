import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding{
  static givePermission() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("permissionGiven", true);
  }

  static discoverBasicFeatures(){
    //TODO: only discovery them if they haven't been discovery before
    /*
    FeatureDiscovery.discoverFeatures(
      context,
      [
        //'swol_logo',
        //'learn_page',
        //'add_excercise',
        'search_excercise',
      ],
    );
    */
  }
}

class OnBoardingText extends StatelessWidget {
  OnBoardingText({
    @required this.text,
    this.toLeft: true,
  });

  final String text;
  final bool toLeft;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        toLeft == false ?  Expanded(
          child: Container(),
        ) : Container(),
        Text(
          text,
          textAlign: toLeft ? TextAlign.left : TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        toLeft ?  Expanded(
          child: Container(),
        ) : Container(),
      ],
    );
  }
}

class OnBoardingImage extends StatelessWidget {
  OnBoardingImage({
    @required this.width,
    @required this.multiplier,
    @required this.imageUrl,
    this.isLeft,
  });

  final double width;
  final double multiplier;
  final String imageUrl;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        width: width,
        height: width,
        alignment: (isLeft == null) ? Alignment.center
        : (isLeft) ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          width: width * multiplier,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Image.asset(
              imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}