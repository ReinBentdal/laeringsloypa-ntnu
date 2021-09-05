import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/provider/gruppeProvider.dart';
import 'package:loypa/data/provider/loypeProvider.dart';
import 'package:loypa/data/provider/timerProvider.dart';
import 'package:loypa/ui/Dashbord/DashbordSide.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/LasterIndikator.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/varslinger.dart';
import 'package:loypa/ui/widgets/molekyl/Ledertavle.dart';
import 'package:loypa/utils/tid_formattering.dart';
import 'package:styled_widget/styled_widget.dart';

class AvsluttLoype extends StatefulWidget {
  static const String rute = 'avslutt løype';
  const AvsluttLoype({Key? key}) : super(key: key);

  @override
  _AvsluttLoypeState createState() => _AvsluttLoypeState();
}

class _AvsluttLoypeState extends State<AvsluttLoype> {
  Duration? tidsbruk;
  bool resultatPublisert = false;
  int? plassering;

  @override
  void initState() {
    super.initState();
    () async {
      context.read(timerProvider.notifier).stoppTimer();
      final gruppeId = context.read(gruppeIdProvider).state;
      final gruppe = await context.read(gruppeProvider(gruppeId!).future);

      // hvis spillet ikke er gyldig på grunn av brukte hint, skal tiden ikke lastes opp til ledertavlen
      if (gruppe.gyldig == false) {
        setState(() {
          resultatPublisert = true;
        });
        varsling(
          context,
          tittel: 'Resultat',
          beskrivelse:
              'Siden hjelpemiddelet for å automatisk løse en oppgave ble brukt, er ikke spillet gyldig og resultatet blir ikke publisert.',
        );
      } else {
        final loypeId = context.read(loypeIdProvider).state;

        if (gruppe.sluttTid == null) {
          final tid = DateTime.now();
          final straffetid = gruppe.hintBrukt * 5000;
          final tidBrukt = Duration(
            milliseconds: tid.millisecondsSinceEpoch -
                gruppe.startTid!.millisecondsSinceEpoch +
                straffetid,
          );
          await FirebaseFirestore.instance
              .collection('grupper')
              .doc(gruppeId)
              .update({
            'slutt_tid': tid,
            'status': 'avsluttet',
          });
          await FirebaseFirestore.instance.collection('ledertavle').add({
            'gruppe_id': gruppeId,
            'løype_id': loypeId,
            'navn': gruppe.gruppenavn,
            'tidsstempel': DateTime.now(),
            'tid': tidBrukt.inSeconds,
          });
          setState(() {
            this.tidsbruk = tidBrukt;
            resultatPublisert = true;
          });
        } else {
          setState(() {
            this.tidsbruk = Duration(
              milliseconds: gruppe.sluttTid!.millisecondsSinceEpoch -
                  gruppe.startTid!.millisecondsSinceEpoch,
            );
            resultatPublisert = true;
          });
        }
      }
      context.read(timerProvider.notifier).tilbakestill();
    }();
  }

  String plasseringFormatter(int plassering) {
    if (plassering == 1)
      return 'den beste';
    else if (plassering == 2)
      return 'den nest beste';
    else
      return '$plassering. beste';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: tidsbruk == null || resultatPublisert == false
          ? LasterIndikator(beskrivelse: 'Laster resultat').center()
          : SafeArea(
              child: SColumn(
                mainAxisSize: MainAxisSize.min,
                separator: const SizedBox(height: 20),
                children: [
                  Text('Resultat',
                      style: Theme.of(context).textTheme.headline1),
                  SColumn(
                    separator: const SizedBox(height: 10),
                    children: [
                      Text('Tid brukt på løypen:'),
                      Text(
                        formaterTid(tidsbruk!, format: TidFormat.Digital),
                        style: Theme.of(context).textTheme.headline4,
                      ).center(),
                    ],
                  ),
                  if (plassering != null)
                    Text(
                        'Du har ${plasseringFormatter(plassering!)} tiden på denne løypen!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  Ledertavle(
                    loypeId: context.read(loypeIdProvider).state!,
                    gruppeId: context.read(gruppeIdProvider).state,
                    rangeringCallback: (plassering) {
                      Future.delayed(Duration.zero).then((_) {
                        setState(() {
                          this.plassering = plassering;
                        });
                      });
                    },
                  ).padding(horizontal: 30).expanded(flex: 2),
                  // Consumer(
                  //   builder: (context, watch, child) {
                  //     final erGruppe = watch(erGruppeProvider);
                  //     return erGruppe.when(
                  //       data: (data) => data == true
                  //           ? child!
                  //           : $Button(
                  //               onPressed: () => null,
                  //               text: 'Publiser result',
                  //             ),
                  //       loading: () =>
                  //           LasterIndikator(beskrivelse: 'Laster informasjon'),
                  //       error: (_, __) => SizedBox(),
                  //     );
                  //   },
                  //   child: Text(
                  //       'Kun personen som har opprettet gruppen kan publisere resultatene'),
                  // ),
                  $Button(
                    onPressed: () async {
                      Navigator.popUntil(context, (_) => false);
                      await Navigator.pushNamed(context, DashbordSide.rute);
                      context.read(gruppeIdProvider).state = null;
                      context.read(loypeIdProvider).state = null;
                    },
                    text: 'Gå til startmenyen',
                  )
                ],
              ).padding(vertical: 40),
            ),
    );
  }
}
