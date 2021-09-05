import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:loypa/ui/Sted/StedShowcase.dart';
import 'package:loypa/ui/Sted/StedSide.dart';
import 'package:loypa/ui/widgets/atom/SRow.dart';
import 'package:styled_widget/styled_widget.dart';

class PersonSelector extends StatelessWidget {
  final String personNavn;
  final Future<void> Function(
      {required Duration duration, required Curve curve}) prevPage;
  final Future<void> Function(
      {required Duration duration, required Curve curve}) nextPage;

  const PersonSelector({
    Key? key,
    required this.personNavn,
    required this.prevPage,
    required this.nextPage,
  }) : super(key: key);

  static const duration = Duration(milliseconds: 400);
  static const curve = Curves.linearToEaseOut;

  @override
  Widget build(BuildContext context) {
    return SRow(
      separator: const SizedBox(width: 20),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          FontAwesome.caret_left,
          size: 42,
          color: Theme.of(context).errorColor,
        )
            .constrained(width: 35)
            .padding(right: 3, vertical: 8)
            .decorated(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 3, color: Theme.of(context).errorColor),
            )
            .ripple()
            .clipRRect(all: 10)
            .gestures(onTap: () => prevPage(duration: duration, curve: curve)),
        Text(
          personNavn,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3?.copyWith(
                color: Theme.of(context).errorColor,
              ),
        ).width(200),
        Icon(
          FontAwesome.caret_right,
          size: 42,
          color: Theme.of(context).errorColor,
        )
            .constrained(width: 35)
            .padding(left: 3, vertical: 8)
            .decorated(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 3, color: Theme.of(context).errorColor),
            )
            .ripple()
            .clipRRect(all: 10)
            .gestures(
              key: personerNavigerRef,
              onTap: () => nextPage(duration: duration, curve: curve),
            ),
      ],
    ).constrained(minHeight: 73);
  }
}
