import 'package:flutter/material.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:styled_widget/styled_widget.dart';

class BottomBorderButton extends StatelessWidget {
  final double translate;
  final String buttonText;
  final Color? buttonColor;
  final void Function() callback;
  final Widget child;

  const BottomBorderButton({
    Key? key,
    this.translate = -47.5,
    required this.child,
    required this.buttonText,
    this.buttonColor,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        child,
        $Button(
          onPressed: callback,
          text: buttonText,
          color: buttonColor,
        ).translate(offset: Offset(0, translate)),
      ],
    );
  }
}
