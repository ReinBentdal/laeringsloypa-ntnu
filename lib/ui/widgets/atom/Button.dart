import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:styled_widget/styled_widget.dart';

class $Button extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final bool error;
  final Color? color;
  final bool laster;

  const $Button({
    Key? key,
    required this.onPressed,
    required this.text,
    this.error = false,
    this.color,
    this.laster = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return (laster
            ? CircularProgressIndicator(
                color: Colors.grey,
                strokeWidth: 2,
              )
            : Text(
                text,
                style: GoogleFonts.oswald().copyWith(
                  color: disabled ? Colors.black54 : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ))
        .center()
        .ripple()
        .decorated(
          color: disabled
              ? Colors.grey[400]
              : error
                  ? Theme.of(context).errorColor
                  : color ?? Theme.of(context).accentColor,
          animate: true,
        )
        .clipRRect(all: 10)
        .animate(Duration(milliseconds: 300), Curves.easeOut)
        .gestures(onTap: laster ? null : onPressed)
        .constrained(width: 200, height: 50);
  }
}
