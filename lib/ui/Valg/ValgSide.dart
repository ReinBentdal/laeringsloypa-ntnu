import 'package:flutter/material.dart';
import 'package:loypa/control/loypeControl.dart';
import 'package:loypa/control/provider/kartProvider.dart';
import 'package:loypa/control/provider/timerProvider.dart';
import 'package:loypa/main.dart';
import 'package:loypa/ui/Dashbord/DashbordSide.dart';
import 'package:loypa/ui/Kart/KartShowcase.dart';
import 'package:loypa/ui/Kart/KartSide.dart';
import 'package:loypa/ui/Sted/StedShowcase.dart';
import 'package:loypa/ui/Sted/StedSide.dart';
import 'package:loypa/ui/Valg/HintSide.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/ui/widgets/atom/varslinger.dart';
import 'package:styled_widget/styled_widget.dart';

class ValgSide extends StatelessWidget {
  static const rute = 'valg side';
  const ValgSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Consumer(builder: (context, watch, _) {
          final kartTilstand = watch(kartTilstandProvider).state;
          return Column(
            children: [
              SubpageAppBar(title: 'Valg').padding(vertical: 40),
              const SizedBox(height: 20),
              SColumn(
                separator: const SizedBox(height: 20),
                children: [
                  $Button(
                    onPressed: kartTilstand == KartTilstand.Ankommet
                        ? () {
                            Navigator.pushNamed(context, HintSide.rute);
                          }
                        : null,
                    text: 'Hint',
                  ),
                  $Button(
                    onPressed: kartTilstand == KartTilstand.Ankommet
                        ? () {
                            Navigator.popUntil(context, ModalRoute.withName(Sted.rute));
                            visStedShowcase(navigatorKey.currentContext ?? context);
                          }
                        : kartTilstand == KartTilstand.PaVei
                            ? () {
                                Navigator.popUntil(context, ModalRoute.withName(KartSide.rute));
                                visKartShowcase(navigatorKey.currentContext ?? context);
                              }
                            : null,
                    text: 'Åpne veilederen',
                  ),
                  $Button(
                    onPressed: () {
                      varslingFeilmelding(
                        context,
                        tittel: 'Vil du avslutte?',
                        beskrivelse: 'Er du sikker på du vil avslutte spillet? Du kan når som helst gjenoppta spillet.',
                        knapptekst: 'Avslutt spill',
                        onClick: () async {
                          final timer = context.read(timerProvider.notifier);
                          LoypeControl.avsluttLoype(context);
                          Navigator.popUntil(context, ModalRoute.withName(DashbordSide.rute));
                          await Future.delayed(Duration(seconds: 1));
                          timer
                            ..stopp()
                            ..tilbakestill();
                        },
                      );
                    },
                    color: Theme.of(context).errorColor,
                    text: 'Avslutt spill',
                  ),
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}
