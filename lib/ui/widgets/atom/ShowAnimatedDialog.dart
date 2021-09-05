import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

Future<void> $showAnimatedDialog({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) async {
  await showAnimatedDialog(
    barrierDismissible: true,
    context: context,
    duration: Duration(milliseconds: 400),
    animationType: DialogTransitionType.scale,
    curve: Curves.easeOut,
    builder: builder,
  );
}
