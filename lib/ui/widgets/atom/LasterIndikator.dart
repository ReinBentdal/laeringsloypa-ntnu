import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class LasterIndikator extends StatelessWidget {
  const LasterIndikator({
    Key? key,
    required this.beskrivelse,
    this.scaleFactor = 1,
  }) : super(key: key);

  final String beskrivelse;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          color: Theme.of(context).accentColor,
        ).scale(all: scaleFactor),
        const SizedBox(height: 10),
        Text(
          beskrivelse,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
