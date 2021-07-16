//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:swol/shared/widgets/simple/popUpAdjustments.dart';

//widget
class MyAwesomeDialog {
  final DialogType? dialogType;
  final Widget? customHeader;
  final BuildContext context;
  final Widget body;
  final bool barrierDismissible;
  final Function? onDissmissCallback;
  final AnimType animType;
  final AlignmentGeometry aligment;
  final bool isDense;
  final bool headerAnimationLoop;
  final bool useRootNavigator;

  MyAwesomeDialog(
      {required this.context,
      this.dialogType,
      this.customHeader,
      required this.body,
      this.onDissmissCallback,
      this.isDense = false,
      this.barrierDismissible = true,
      this.headerAnimationLoop = true,
      this.aligment = Alignment.center,
      this.animType = AnimType.SCALE,
      this.useRootNavigator = false});

  Future show() {
    return showDialog(
        context: this.context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          switch (animType) {
            case AnimType.SCALE:
              return ScaleFade(
                //TODO: check
                //scalebegin: 0.1,
                curve: Curves.fastLinearToSlowEaseIn,
                child: _buildDialog(),
              );
            case AnimType.LEFTSLIDE:
              return Slide(
                from: SlideFrom.LEFT,
                child: _buildDialog(),
              );
            case AnimType.RIGHSLIDE:
              return Slide(
                from: SlideFrom.RIGHT,
                child: _buildDialog(),
              );
            case AnimType.BOTTOMSLIDE:
              return Slide(
                from: SlideFrom.BOTTOM,
                child: _buildDialog(),
              );
            case AnimType.TOPSLIDE:
              return Slide(
                from: SlideFrom.TOP,
                child: _buildDialog(),
              );
            default:
              return _buildDialog();
          }
        }).then((_) {
      if (onDissmissCallback != null) {
        onDissmissCallback!();
      }
    });
  }

  _buildDialog() {
    return MyVerticalStackDialog(
      header: customHeader ??
          FlareHeader(
            loop: headerAnimationLoop,
            dialogType: dialogType ?? DialogType.NO_HEADER,
          ),
      body: this.body,
      isDense: isDense,
      aligment: aligment,
    );
  }

  dissmiss() {
    Navigator.of(context, rootNavigator: useRootNavigator).pop();
  }
}

class MyVerticalStackDialog extends StatelessWidget {
  final Widget header;
  final Widget body;
  final bool isDense;
  final AlignmentGeometry aligment;
  const MyVerticalStackDialog({
    Key? key,
    required this.body,
    required this.aligment,
    required this.isDense,
    required this.header,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double topOuter = 16;
    double bottomOuter = 56;
    double size = 56;
    return Container(
      alignment: aligment,
      child: Stack(
        children: <Widget>[
          FadeIn(
            from: SlideFrom.BOTTOM,
            delay: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDense ? 16 : 36,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: size + topOuter,
                  bottom: bottomOuter,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    24.0,
                  ),
                  child: Material(
                    elevation: 0.5,
                    color: Theme.of(context).cardColor,
                    child: ScrollViewWithShadow(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: size,
                            bottom: 8.0,
                          ),
                          child: body,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: topOuter,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FadeIn(
                  from: SlideFrom.TOP,
                  delay: 1,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).cardColor,
                    radius: size,
                    child: header,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
