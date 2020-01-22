import 'package:flutter/material.dart';

class OnBoardingImage extends StatelessWidget {
  OnBoardingImage({
    @required this.width,
    @required this.multiplier,
    @required this.imageUrl,
    this.isLeft,
    this.onTap,
  });

  final double width;
  final double multiplier;
  final String imageUrl;
  final bool isLeft;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (onTap == null) ? (){} : () => onTap(),
      //NOTE: invisible container required to make tap target large
      child: Container(
        color: Colors.transparent,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            width: width,
            height: width,
            alignment: (isLeft == null) ? Alignment.center
            : (isLeft) ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: width * multiplier,
              child: Image.asset(
                imageUrl,
              ),
            ),
          ),
        ),
      ),
    );
  }
}