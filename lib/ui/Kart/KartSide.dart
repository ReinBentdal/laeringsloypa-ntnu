import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/control/provider/lokasjonProvider.dart';
import 'package:loypa/ui/Kart/Kart.dart';
import 'package:loypa/ui/widgets/atom/LasterIndikator.dart';
import 'package:styled_widget/styled_widget.dart';

class KartSide extends StatelessWidget {
  static const String rute = 'Maps side';

  KartSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, _) {
          final tillatelse = watch(harLokasjonTillatelseProvider);
          return tillatelse.map(
            tillatelse: () => Kart(),
            avvist: () => Text(
              'Applikasjonen trenger tilgang til posisjonstjenesten for å fungere riktig.',
            ).center(),
            avvistForaltid: () => Text(
              'Applikasjonen trenger tilgang til posisjonstjenesten for å fungere riktig. For å gi applikasjonen tilgnag til posisjon må du gå inn på telefonens instillinger.',
            ).center(),
            venter: () {
              return LasterIndikator(
                beskrivelse: 'Venter på posisjonstillatelse',
              ).center();
            },
            ikkeTilgang: () => Text(
              'Applikasjonen har ikke tilgang til posisjonstjenesten. Aktiver posisjonstjenesten for å bruke applikasjonen.',
            ).center(),
          );
        },
      ),
    );
  }
}
