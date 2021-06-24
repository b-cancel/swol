//flutter
import 'package:flutter/material.dart';

//used only by addition
class ReloadingCard extends StatefulWidget {
  const ReloadingCard({
    Key? key,
    required this.child,
    required this.notifier,
  }) : super(key: key);

  final Widget child;
  final ValueNotifier notifier;

  @override
  _ReloadingCardState createState() => _ReloadingCardState();
}

class _ReloadingCardState extends State<ReloadingCard> {
  updateState() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    widget.notifier.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    widget.notifier.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NonReloadingCard(child: widget.child);
  }
}

class NonReloadingCard extends StatelessWidget {
  const NonReloadingCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16,
          bottom: 16,
          top: 8,
        ),
        child: child,
      ),
    );
  }
}

class SliderCard extends StatelessWidget {
  SliderCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8, //8 is default spacing for add exercsie
          bottom: 8,
        ),
        child: child,
      ),
    );
  }
}
