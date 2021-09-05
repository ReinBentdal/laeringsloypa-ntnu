import 'package:flutter/material.dart';

class SColumn extends Column {
  SColumn({
    Key? key,
    List<Widget> children = const <Widget>[],
    Widget? separator,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    TextBaseline? textBaseline,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
  }) : super(
          key: key,
          children: separator != null && children.length > 0
              ? (children.expand((child) => [child, separator]).toList()
                ..removeLast())
              : children,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          textBaseline: textBaseline,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
        );
}
