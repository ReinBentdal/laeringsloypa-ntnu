import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:styled_widget/styled_widget.dart';

class $IconButton extends StatelessWidget {
  final String asset;
  final void Function() onTap;

  const $IconButton({
    Key? key,
    required this.asset,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: 60,
      height: 60,
    )
        .padding(all: 10)
        .ripple()
        .decorated(color: Colors.blueGrey[50])
        .clipRRect(all: 20)
        .gestures(onTap: onTap);
  }
}
