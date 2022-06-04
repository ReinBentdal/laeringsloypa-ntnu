import 'package:flutter/material.dart';
import 'package:loypa/control/provider/loyperProvider.dart';
import 'package:loypa/ui/Dashbord/LoypeCard.dart';
import 'package:loypa/ui/OpprettSpill/OpprettGruppe.dart';
import 'package:loypa/ui/widgets/atom/LasterIndikator.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VelgLoype extends StatelessWidget {
  static const rute = 'Velg løype';
  const VelgLoype({Key? key}) : super(key: key);

  void velgLoype(BuildContext context, String id) {
    Navigator.pushNamed(context, OpprettGruppe.rute, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SColumn(
          separator: const SizedBox(height: 30),
          children: <Widget>[
            SubpageAppBar(
              title: 'Velg løype',
              titleColor: Theme.of(context).primaryColor,
            ).padding(top: 40),
            Text('Velg hvilke løype du vil spille.'),
            context
                .read(loyperStreamProvider)
                .when(
                  data: (loyper) {
                    return SColumn(
                      children: loyper
                          .map((loype) => LoypeCard(
                                loype,
                                erGruppespill: true,
                                onVelg: (_) => velgLoype(context, loype.id),
                              ))
                          .toList(),
                    );
                  },
                  loading: () => LasterIndikator(beskrivelse: 'Laster løyper'),
                  error: (_, __) => Text('Feilet med å laste løype'),
                )
                .padding(horizontal: 20),
          ],
        ),
      ),
    );
  }
}
