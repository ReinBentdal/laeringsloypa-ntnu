import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/control/loypeControl.dart';
import 'package:loypa/control/provider/gruppeProvider.dart';
import 'package:loypa/control/provider/timerProvider.dart';
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
  String? gruppeId;
  String? loypeId;

  @override
  void initState() {
    super.initState();
    () async {
 
      final gruppe = await context.read(gruppeProvider.future);

      setState(() {
        gruppeId = gruppe.gruppeId;
        loypeId = gruppe.loypeId;
      });

       await LoypeControl.fullforLoype(context);
    
      final gruppeOppdatert = await context.read(gruppeProvider.future);

      setState(() {
        this.tidsbruk = Duration(
          milliseconds: gruppeOppdatert.sluttTid!.millisecondsSinceEpoch -
              gruppeOppdatert.startTid!.millisecondsSinceEpoch,
        );
      });

      if (!gruppeOppdatert.gyldig) {
        await varsling(
          context,
          tittel: 'Løypen ble ikke publisert',
          beskrivelse: 'Fordi det ble brukt hjelpemiddel for å automatisk fullføre en oppgave kvalifiserer ikke gjennomførelsen til å bli publisert på ledertavlen.',
        );
      }

      LoypeControl.forlat(context, gruppe.gruppeId);

      setState(() {
        resultatPublisert = true;
      });

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
                    loypeId: loypeId!,
                    gruppeId: gruppeId,
                    rangeringCallback: (plassering) {
                      Future.delayed(Duration.zero).then((_) {
                        setState(() {
                          this.plassering = plassering;
                        });
                      });
                    },
                  ).padding(horizontal: 30).expanded(flex: 2),

                  $Button(
                    onPressed: () async {
                      Navigator.popUntil(context, (_) => false);
                      await Navigator.pushNamed(context, DashbordSide.rute);
                    },
                    text: 'Gå til startmenyen',
                  )
                ],
              ).padding(vertical: 40),
            ),
    );
  }
}
