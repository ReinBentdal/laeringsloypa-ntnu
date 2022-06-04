import 'package:flutter/material.dart';
import 'package:loypa/ui/Valg/ValgSide.dart';

class ValgIkon extends StatelessWidget {
  const ValgIkon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pushNamed(context, ValgSide.rute),
      iconSize: 36,
      icon: Icon(
        Icons.settings_outlined,
        color: color ?? Theme.of(context).accentColor,
      ),
    );
  }
}
