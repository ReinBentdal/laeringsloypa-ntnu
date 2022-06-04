import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/config/theme/inputDecoration.dart';
import 'package:loypa/control/loypeControl.dart';
import 'package:loypa/control/provider/gruppeProvider.dart';
import 'package:loypa/ui/OpprettSpill/Lobby.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/varslinger.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:styled_widget/styled_widget.dart';

final brukernavnFeltProvider = StateProvider<String>((ref) => '');

class VelgBrukernavnGruppe extends StatelessWidget {
  static const String rute = 'Velg brukernavn';
  const VelgBrukernavnGruppe({Key? key}) : super(key: key);

  void velgBrukernavn(BuildContext context) async {
    final brukernavn = context.read(brukernavnFeltProvider).state.trim();

    if (brukernavn == '') {
      return varslingFeilmelding(
        context,
        tittel: 'Brukernavn ikke valgt',
        beskrivelse: 'Du må skrive inn et brukernavn for å fortsette',
      );
    }
    
    final pin = context.read(gruppepinVerdiProvider).state;
    context.read(gruppepinVerdiProvider).state = '';
    final gruppeId = await LoypeControl.deltaMedPin(context, pin, brukernavn);

    if (gruppeId != null) {
      Navigator.popAndPushNamed(context, Lobby.rute);
    } else {
      await varslingFeilmelding(context, tittel: 'Feilet', beskrivelse: 'En utventet feil førte til at du ikke kunne legges til i gruppen.');
      Navigator.pop(context);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SColumn(
          separator: const SizedBox(height: 20),
          children: [
            SubpageAppBar(
              title: 'Velg brukernavn',
              titleColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(),
            TextField(
              decoration: inputDecoration(context, 'Velg et brukernavn..'),
              onChanged: (value) => context.read(brukernavnFeltProvider).state = value,
            ).constrained(maxWidth: 300),
            $Button(onPressed: () => velgBrukernavn(context), text: 'Velg'),
          ],
        ).center().padding(top: 40),
      ).scrollable(),
    );
  }
}
