import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:styled_widget/styled_widget.dart';

class SubpageAppBar extends StatelessWidget {
  final String title;
  final Color? titleColor;
  const SubpageAppBar({
    Key? key,
    required this.title,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h2 = Theme.of(context).textTheme.headline2;
    return Row(
      children: [
        Icon(
          FontAwesome.caret_left,
          size: 54,
          color: Theme.of(context).accentColor,
        ).ripple().gestures(
              onTap: () => Navigator.maybePop(context),
            ),
        SizedBox(width: 10),
        Text(
          title,
          style: titleColor == null
              ? h2
              : h2?.copyWith(color: Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}
