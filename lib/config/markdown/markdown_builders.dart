import 'package:flutter/material.dart';
import 'package:loypa/ui/widgets/molekyl/FirebaseImage.dart';
import 'package:styled_widget/styled_widget.dart';

final Widget Function(Uri, String?, String?) imageBuilder =
    (Uri uri, String? s, String? ss) {
  // Parametere som kan sendes med bildet
  double? width, height;
  AlignmentGeometry align = Alignment.center;
  String? semanticsLabel;

  uri.queryParameters.forEach((key, value) {
    if (key == 'w') {
      width = double.parse(value);
    } else if (key == 'h') {
      height = double.parse(value);
    } else if (key == 'align') {
      if (value == 'left') {
        align = Alignment.topLeft;
      } else if (value == 'right') {
        align = Alignment.topRight;
      }
    } else if (key == 'label') {
      semanticsLabel = value;
    }
  });

  return FirebaseImage(
    path: uri.path,
    width: width,
    height: height,
    semanticsLabel: semanticsLabel ?? 'Ingen beskrivelse av bilde',
  ).padding(vertical: 15).alignment(align);
};
