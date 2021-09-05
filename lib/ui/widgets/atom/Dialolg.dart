import 'package:flutter/material.dart';
import 'package:loypa/ui/widgets/atom/SRow.dart';
import 'package:styled_widget/styled_widget.dart';

class $Dialog extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final List<Widget> bottomBorder;
  final Offset bottomBorderOffset;
  final bool lukkKnapp;

  const $Dialog({
    Key? key,
    required this.child,
    this.borderColor,
    this.bottomBorder = const [],
    this.bottomBorderOffset = const Offset(0, -27.5),
    this.lukkKnapp = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        child
            .padding(vertical: 30, horizontal: 40)
            .decorated(
              border: Border.all(
                width: 3,
                color: borderColor ?? Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).backgroundColor,
            )
            .constrained(maxWidth: 400)
            .padding(bottom: 20),
        if (bottomBorder.length != 0)
          SRow(
            separator: const SizedBox(width: 10),
            mainAxisAlignment: MainAxisAlignment.center,
            children: bottomBorder,
          ).padding(horizontal: 30),
        if (lukkKnapp)
          Icon(
            Icons.clear,
            color: Theme.of(context).errorColor,
          )
              .padding(all: 3)
              .decorated(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).errorColor,
                ),
              )
              .ripple(
                  customBorder: CircleBorder(), splashColor: Color(0xFFF19776))
              .decorated(
                shape: BoxShape.circle,
                color: Color(0xFFF19776),
              )
              .gestures(onTap: () => Navigator.maybePop(context))
              .positioned(top: -10, left: -10),
      ],
    ).constrained(maxWidth: 400);
  }
}
