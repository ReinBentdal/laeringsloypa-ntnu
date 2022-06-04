import 'package:flutter/material.dart';
import 'package:loypa/config/theme/inputDecoration.dart';
import 'package:loypa/control/loypeControl.dart';
import 'package:loypa/ui/OpprettSpill/AdminLobby.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/varslinger.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gruppenavnProvider = StateProvider((ref) => '');
final brukernavnProvider = StateProvider((ref) => '');

final lasterProvider = StateProvider((ref) => false);

class OpprettGruppe extends StatelessWidget {
  static const rute = 'Opprett gruppe';
  const OpprettGruppe({Key? key}) : super(key: key);

  Future<void> opprettGruppe(BuildContext context) async {
    final brukernavn = context.read(brukernavnProvider).state;
    final gruppenavn = context.read(gruppenavnProvider).state;

    if (gruppenavn == '' || brukernavn == '') {
      return await varslingFeilmelding(
        context,
        tittel: 'Brukernavnet eller gruppenavnet er ikke valgt',
        beskrivelse: 'Du må velge både ett gyldig gruppenavn og brukernavn.',
      );
    } else if (brukernavn.length > 20) {
      return await varslingFeilmelding(
        context,
        tittel: 'Ugyldig brukernavn',
        beskrivelse: 'Lengden på brukernavnet kan ikke være mer enn 20 karakterer.',
      );
    } else if (gruppenavn.length > 20) {
      return await varslingFeilmelding(
        context,
        tittel: 'Ugyldig gruppenavn',
        beskrivelse: 'Lengden på gruppenavnet kan ikke være mer enn 20 karakterer.',
      );
    }

    context.read(lasterProvider).state = true;

    final loypeId = ModalRoute.of(context)?.settings.arguments as String?;

    if (loypeId == null) {
      Navigator.pop(context);
      context.read(lasterProvider).state = false;
      return;
    }

    final gruppeId = await LoypeControl.lag(context, loypeId, gruppenavn, true);

    if (gruppeId != null) {
      bool suksess = await LoypeControl.deltaMedGruppeId(context, gruppeId, brukernavn);
      if (suksess) {
        Navigator.popAndPushNamed(context, AdminLobby.rute);
        return;
      }
    }

    await varslingFeilmelding(context,
        tittel: 'Feilet', beskrivelse: 'En utventet feil førte til at gruppen ikke ble opprettet.');
    Navigator.pop(context);

    context.read(lasterProvider).state = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SColumn(
          separator: const SizedBox(height: 30),
          children: <Widget>[
            SubpageAppBar(
              title: 'Opprett gruppe',
              titleColor: Theme.of(context).primaryColor,
            ).padding(top: 40),
            SColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              separator: const SizedBox(height: 8),
              children: [
                Text(
                  'Velg et gruppenavn',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('Velg et passende navn som representerer gruppen du oppretter. Når spillet er ferdig kan andre spille kunne se navnet på gruppen.')
                    .constrained(maxWidth: 300),
                TextField(
                  decoration: inputDecoration(context, 'Gruppenavn..'),
                  onChanged: (value) => context.read(gruppenavnProvider).state = value,
                ).constrained(maxWidth: 300),
              ],
            ),
            SColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              separator: const SizedBox(height: 8),
              children: [
                Text(
                  'Velg ditt brukernavn',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('Dette er navnet du som spiller vil ha i spillet'),
                TextField(
                  decoration: inputDecoration(context, 'Brukernavn..'),
                  onChanged: (value) => context.read(brukernavnProvider).state = value,
                ).constrained(maxWidth: 300),
              ],
            ),
            Consumer(builder: (context, watch, _) {
              return $Button(
                onPressed: () => opprettGruppe(context),
                text: 'Opprett gruppe',
                laster: watch(lasterProvider).state,
              );
            }),
          ],
        ),
      ).scrollable(),
    );
  }
}
