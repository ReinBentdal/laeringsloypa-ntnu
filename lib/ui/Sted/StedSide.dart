import 'package:flutter/material.dart';
import 'package:loypa/control/provider/RyggsekkProvider.dart';
import 'package:loypa/control/provider/stedProvider.dart';
import 'package:loypa/control/provider/kartProvider.dart';
import 'package:loypa/control/provider/loypeProvider.dart';
import 'package:loypa/ui/Kart/KartSide.dart';
import 'package:loypa/ui/Reiseboka/ReisebokaSide.dart';
import 'package:loypa/ui/Ryggsekk/RyggsekkSide.dart';
import 'package:loypa/ui/Sted/PersonSlider.dart';
import 'package:loypa/ui/Sted/StedShowcase.dart';
import 'package:loypa/ui/widgets/atom/HjelpIkon.dart';
import 'package:loypa/ui/widgets/atom/IconButton.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/UpdateAlert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Sted extends StatefulWidget {
  static const String rute = 'Sted';

  @override
  _StedState createState() => _StedState();
}

class _StedState extends State<Sted> {
  Future<void> onOppgaverLost(BuildContext context, bool ferdig) async {
    if (ferdig) {
      final kartTilstand = context.read(kartTilstandProvider);
      final stedIndex = context.read(stedIndexProvider);
      final loype = await context.read(valgtLoypeProvider.future);
      final loypeLengde = loype!.steder.length;
      Navigator.popUntil(context, ModalRoute.withName(KartSide.rute));
      await Future.delayed(Duration(milliseconds: 300));

      if (stedIndex + 1 == loypeLengde) {
        kartTilstand.state = KartTilstand.SpillFerdig;
      } else {
        kartTilstand.state = KartTilstand.LokasjonFerdig;
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();

      final harSettShowcase = prefs.getBool('sted-showcase') ?? false;

      if (harSettShowcase == false) visStedShowcase(context);

      prefs.setBool('sted-showcase', true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stedsdata = context.read(valgtStedProvider);
    return WillPopScope(
      onWillPop: () async => false,
      child: ProviderListener(
        provider: alleOppgaverLostProvider,
        onChange: onOppgaverLost,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              children: [
                ValgIkon(key: hjelpRef).positioned(top: 10, right: 10),
                Styled.builder(
                  builder: (_, child) => child.padding(bottom: 20, top: 45),
                  child: SColumn(
                    separator: const SizedBox(height: 20),
                    children: [
                      Text(
                        stedsdata.stedsnavn,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2?.copyWith(
                              color: Theme.of(context).errorColor,
                            ),
                      ),
                      PersonSlider(personer: stedsdata.personer),

                      // Ryggsekk og reiseboka
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer(
                            builder: (context, watch, _) {
                              return $UpdateAlert(
                                showAlert: watch(ryggsekkHasNewProvider),
                                child: $IconButton(
                                  key: ryggsekkRef,
                                  asset: 'assets/Ryggsekk.svg',
                                  onTap: () => Navigator.pushNamed(
                                      context, Ryggsekk.rute),
                                ),
                              );
                            },
                          ),
                          $IconButton(
                            key: reisebokaRef,
                            asset: 'assets/Reiseboka.svg',
                            onTap: () => Navigator.pushNamed(
                              context,
                              Reiseboka.rute,
                            ),
                          ),
                        ],
                      ).constrained(width: 200)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
