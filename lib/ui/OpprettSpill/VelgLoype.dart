import 'package:flutter/material.dart';
import 'package:loypa/data/model/Loype.dart';
import 'package:loypa/data/provider/loypeProvider.dart';
import 'package:loypa/data/provider/loyperProvider.dart';
import 'package:loypa/ui/OpprettSpill/OpprettGruppe.dart';
import 'package:loypa/ui/widgets/atom/BottomBorderButton.dart';
import 'package:loypa/ui/widgets/atom/LasterIndikator.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:loypa/utils/tid_formattering.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VelgLoype extends StatelessWidget {
  static const rute = 'Velg løype';
  const VelgLoype({Key? key}) : super(key: key);

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
                                velgLoype: (loypeId) {
                                  context.read(loypeIdProvider).state = loypeId;
                                  Navigator.pushNamed(
                                      context, OpprettGruppe.rute);
                                },
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

class LoypeCard extends StatelessWidget {
  const LoypeCard(
    this.loype, {
    required this.velgLoype,
    Key? key,
  }) : super(key: key);

  final LoypeInfoModel loype;
  final void Function(String) velgLoype;

  @override
  Widget build(BuildContext context) {
    return BottomBorderButton(
      callback: () => velgLoype(loype.id),
      buttonText: 'Velg',
      translate: -27.5,
      child: Styled.builder(
        builder: (context, child) {
          return child.ripple().decorated(
                border: Border.all(
                  width: 3,
                  color: Theme.of(context).errorColor,
                ),
                borderRadius: BorderRadius.circular(20),
              );
        },
        child: SColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          separator: const SizedBox(height: 5),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loype.navn,
                  // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  'ca. ' + formaterTid(loype.estimertTid),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            Text(
              'Løypen starter ved ${loype.startlokasjon}.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ).padding(top: 15, horizontal: 20, bottom: 40),
      ),
    );
  }
}
