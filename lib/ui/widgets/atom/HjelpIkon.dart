import 'package:flutter/material.dart';
import 'package:loypa/ui/Hjelp/HjelpSide.dart';

class HjelpIkon extends StatelessWidget {
  const HjelpIkon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pushNamed(context, HjelpSide.rute),
      iconSize: 36,
      icon: Icon(
        Icons.help_outline,
        color: color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
