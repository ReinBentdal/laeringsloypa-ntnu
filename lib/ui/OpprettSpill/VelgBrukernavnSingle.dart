import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/config/theme/inputDecoration.dart';
import 'package:loypa/control/loypeControl.dart';
import 'package:loypa/ui/Dashbord/LoypeLaster.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/varslinger.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:styled_widget/styled_widget.dart';

final brukernavnFeltProvider = StateProvider<String>((ref) => '');
final lasterProvider = StateProvider.autoDispose((ref) => false);

class VelgBrukernavnSingle extends StatelessWidget {
  static const String rute = 'Velg brukernavn single';
  const VelgBrukernavnSingle({Key? key}) : super(key: key);


  Future<void> velgBrukernavn(BuildContext context) async {
    final brukernavn = context.read(brukernavnFeltProvider).state.trim();

    if (brukernavn == '') {
      return await varslingFeilmelding(
        context,
        tittel: 'Ugyldig brukernavn',
        beskrivelse: 'Du må velge et brukernavn for å fortsette',
      );
    } else if (brukernavn.length > 20) {
      return await varslingFeilmelding(
        context,
        tittel: 'Ugyldig brukernavn',
        beskrivelse:
            'Lengden på brukernavnet kan ikke være mer enn 20 karakterer.',
      );
    }

    context.read(lasterProvider).state = true;

    final loypeId = ModalRoute.of(context)?.settings.arguments as String?;

    if (loypeId == null) {
      Navigator.pop(context);
      context.read(lasterProvider).state = false;
      return;
    }

    final gruppeId = await LoypeControl.lag(context, loypeId, brukernavn, false);

    if (gruppeId != null) {
      bool suksess = await LoypeControl.deltaMedGruppeId(context, gruppeId, brukernavn);
      if (suksess) {
        context.read(lasterProvider).state = false;
        LoypeControl.start(gruppeId);
        Navigator.popAndPushNamed(context, LoypeLaster.rute);
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
          separator: const SizedBox(height: 20),
          children: [
            SubpageAppBar(
              title: 'Velg brukernavn',
              titleColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(),
            Text('Når du har fullført løypen, vil tiden brukt publiseres på ledertavlen med det gitte brukernavnet. Velg derfor et passende brukernavn.')
                .padding(horizontal: 20),
            TextField(
              decoration: inputDecoration(context, 'Velg et brukernavn..'),
              onChanged: (value) =>
                  context.read(brukernavnFeltProvider).state = value,
            ).constrained(maxWidth: 300),
            Consumer(builder: (context, watch, _) {
              return $Button(
                onPressed: () => velgBrukernavn(context),
                text: 'Velg',
                laster: watch(lasterProvider).state,
              );
            }),
          ],
        ).center().padding(top: 40),
      ),
    );
  }
}
