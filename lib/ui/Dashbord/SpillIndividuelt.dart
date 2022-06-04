import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/control/loypeControl.dart';
import 'package:loypa/control/provider/loyperProvider.dart';
import 'package:loypa/ui/OpprettSpill/VelgBrukernavnSingle.dart';
import 'package:loypa/ui/widgets/atom/LasterIndikator.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:styled_widget/styled_widget.dart';

import 'LoypeCard.dart';
import 'LoypeLaster.dart';

class SpillIndividuelt extends StatelessWidget {
  const SpillIndividuelt({Key? key}) : super(key: key);

  void velgLoype(BuildContext context, String loypeId, bool fortsett) async {
    if (fortsett == true) {
      final suksess = await LoypeControl.fortsett(context, loypeId);
      if (suksess) {
        Navigator.pushNamed(context, LoypeLaster.rute);
        return;
      } else {
        print("feilet med å fortsette løype");
      }
    } else {
      Navigator.pushNamed(
        context,
        VelgBrukernavnSingle.rute,
        arguments: loypeId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        separator: const SizedBox(height: 20),
        children: [
          Text(
            'Løyper',
            style: Theme.of(context).textTheme.headline1?.copyWith(color: Theme.of(context).errorColor),
          ).padding(top: 20, horizontal: 20),
          Consumer(
            builder: (context, watch, _) {
              final loyper = watch(loyperStreamProvider);
              return loyper.when(
                data: (loyper) => Column(
                  children: loyper
                      .map((loype) => LoypeCard(
                            loype,
                            erGruppespill: false,
                            onVelg: (bool fortsett) => velgLoype(context, loype.id, fortsett),
                          ))
                      .toList(),
                ),
                loading: () {
                  return LasterIndikator(beskrivelse: 'Laster løyper').center();
                },
                error: (_, __) {
                  return Text(
                    'Feilet med å laste inn løyper',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  );
                },
              );
            },
          ).padding(horizontal: 20),
        ],
      ).scrollable(),
    );
  }
}
