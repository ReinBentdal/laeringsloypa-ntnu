import 'package:flutter/material.dart';
import 'package:loypa/data/provider/gruppeProvider.dart';
import 'package:loypa/data/provider/kartProvider.dart';
import 'package:loypa/data/provider/loypeProvider.dart';
import 'package:loypa/data/provider/timerProvider.dart';
import 'package:loypa/main.dart';
import 'package:loypa/ui/Dashbord/DashbordSide.dart';
import 'package:loypa/ui/Hjelp/HintSide.dart';
import 'package:loypa/ui/Kart/KartShowcase.dart';
import 'package:loypa/ui/Kart/KartSide.dart';
import 'package:loypa/ui/Sted/StedShowcase.dart';
import 'package:loypa/ui/Sted/StedSide.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/ui/widgets/atom/varslinger.dart';
import 'package:styled_widget/styled_widget.dart';

class HjelpSide extends StatelessWidget {
  static const rute = 'hjelp side';
  const HjelpSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Consumer(builder: (context, watch, _) {
          final kartTilstand = watch(kartTilstandProvider).state;
          return Column(
            children: [
              SubpageAppBar(title: 'Hjelp').padding(vertical: 40),
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
                            Navigator.popUntil(
                                context, ModalRoute.withName(Sted.rute));
                            visStedShowcase(
                                navigatorKey.currentContext ?? context);
                          }
                        : kartTilstand == KartTilstand.PaVei
                            ? () {
                                Navigator.popUntil(context,
                                    ModalRoute.withName(KartSide.rute));
                                visKartShowcase(
                                    navigatorKey.currentContext ?? context);
                              }
                            : null,
                    text: 'Åpne veilederen',
                  ),
                  $Button(
                    onPressed: () {
                      varslingFeilmelding(context,
                          tittel: 'Vil du avslutte?',
                          beskrivelse:
                              'Er du sikker på du vil avslutte spillet? All progresjon vil gå tapt.',
                          knapptekst: 'Avslutt spill', onClick: () async {
                        final timer = context.read(timerProvider.notifier);
                        final gruppe = context.read(gruppeIdProvider);
                        final loype = context.read(loypeIdProvider);
                        Navigator.popUntil(
                            context, ModalRoute.withName(DashbordSide.rute));
                        await Future.delayed(Duration(seconds: 1));
                        timer
                          ..stoppTimer()
                          ..tilbakestill();
                        gruppe.state = null;
                        loype.state = null;
                      });
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
