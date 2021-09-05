import 'package:flutter/material.dart';

enum LokasjonTilstand {
  Avvist,
  AvvistForaltid,
  Venter,
  Tillatelse,
  IkkeTilgang,
}

class LokasjonModel {
  final LokasjonTilstand _tilstand;

  LokasjonModel(this._tilstand);

  Widget map({
    required Widget Function() tillatelse,
    required Widget Function() avvist,
    required Widget Function() avvistForaltid,
    required Widget Function() venter,
    required Widget Function() ikkeTilgang,
  }) {
    switch (_tilstand) {
      case LokasjonTilstand.Tillatelse:
        return tillatelse();
      case LokasjonTilstand.Avvist:
        return avvist();
      case LokasjonTilstand.AvvistForaltid:
        return avvistForaltid();
      case LokasjonTilstand.Venter:
        return venter();
      case LokasjonTilstand.IkkeTilgang:
        return ikkeTilgang();
    }
  }
}
