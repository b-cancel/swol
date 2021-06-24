import 'package:flutter/material.dart';
import 'package:swol/pages/notes/fieldEditButtons.dart';

class EditOneAtATimeButtons extends StatelessWidget {
  const EditOneAtATimeButtons({
    Key? key,
    required this.undo,
    required this.showTopButton,
    required this.isEditing,
  }) : super(key: key);

  final Function undo;
  final bool showTopButton;
  final ValueNotifier<bool> isEditing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 8,
      ),
      child: ClipRRect(
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(16.0),
          bottomLeft: const Radius.circular(16.0),
        ),
        child: FieldEditButtons(
          darkButtons: false,
          onPressTop: () => undo(),
          topIcon: Icons.undo,
          showTopButton: showTopButton,
          onPressBottom: () {
            isEditing.value = !isEditing.value;
          },
          bottomIcon: (isEditing.value) ? Icons.check : Icons.edit,
        ),
      ),
    );
  }
}
