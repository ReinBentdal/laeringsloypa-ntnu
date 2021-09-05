import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/config/theme/inputDecoration.dart';
import 'package:loypa/data/provider/RyggsekkProvider.dart';
import 'package:loypa/data/provider/stedProvider.dart';
import 'package:loypa/data/provider/oppgaveProvider.dart';
import 'package:loypa/main.dart';
import 'package:loypa/ui/Oppgave/GjomtTekst.dart';
import 'package:loypa/ui/Oppgave/OppgaveFullfortDialog.dart';
import 'package:loypa/ui/Oppgave/input/DesimalInput.dart';
import 'package:loypa/ui/Oppgave/input/HeltallInput.dart';
import 'package:loypa/ui/Oppgave/input/MarkdownInput.dart';
import 'package:loypa/ui/Sted/StedSide.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/HjelpIkon.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/ShowAnimatedDialog.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:loypa/ui/widgets/molekyl/MultiInput.dart';
import 'package:styled_widget/styled_widget.dart';

final _losningProvider = StateProvider.family<String, int>((ref, personIndex) {
  ref.watch(stedIndexProvider);
  return '';
});

final _feilLosningProvider = StateProvider<bool>((ref) => false);

class OppgaveSide extends StatelessWidget {
  static const String rute = 'Løs oppgave';

  Future<void> losOppgave(BuildContext context, String riktigSvar) async {
    final personIndex = context.read(valgtPersonIndexProvider).state;
    final read = context.read(_losningProvider(personIndex)).state;
    if (read.toLowerCase() == riktigSvar.toLowerCase()) {
      final ryggsekkGjenstand = context.read(valgtOppgaveProvider).belonning;
      final oppgaveController = context.read(valgtOppgaveProvider.notifier);
      final ryggsekkController = context.read(ryggsekkInnholdProvider.notifier);

      Navigator.popUntil(context, ModalRoute.withName(Sted.rute));

      if (ryggsekkGjenstand != null) {
        ryggsekkController.leggTilGjenstander(
          context,
          ryggsekkGjenstand,
        );

        await Future.delayed(Duration(milliseconds: 150));

        await $showAnimatedDialog(
          context: navigatorKey.currentContext ?? context,
          builder: (context) => OppgaveFullfortDialog(ryggsekkGjenstand),
        );
      }

      oppgaveController.setOppgaveLost();
    } else {
      final feilLosning = context.read(_feilLosningProvider);
      feilLosning.state = true;
      Future.delayed(
        Duration(seconds: 1),
        () => feilLosning.state = false,
      );
    }
  }

  void inputOnChange(BuildContext context, String value) {
    final valgtPerson = context.read(valgtPersonIndexProvider).state;
    context.read(_losningProvider(valgtPerson)).state = value;
  }

  @override
  Widget build(BuildContext context) {
    final oppgave = context.read(valgtOppgaveProvider);
    final valgtPerson = context.read(valgtPersonIndexProvider);
    final startverdi = context.read(_losningProvider(valgtPerson.state)).state;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            HjelpIkon().positioned(top: 10, right: 10),
            SColumn(
              separator: const SizedBox(height: 30),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SubpageAppBar(
                  title: 'Løs oppgave',
                ),
                Text(
                  oppgave.oppgavetekst,
                  style: Theme.of(context).textTheme.bodyText1,
                ),

                // Inputfelt
                SColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  separator: const SizedBox(height: 10),
                  children: [
                    oppgave.typespesifikk.map(
                      tekstInput: () {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Skriv inn svaret',
                                style: Theme.of(context).textTheme.headline4),
                            const SizedBox(height: 10),
                            TextField(
                              controller:
                                  TextEditingController(text: startverdi),
                              decoration:
                                  inputDecoration(context, 'Skriv her...'),
                              onChanged: (value) =>
                                  inputOnChange(context, value),
                            ),
                          ],
                        );
                      },
                      markdownTekstInput: (markdownInput) {
                        return MarkdownInput(
                          onChange: (value) => inputOnChange(context, value),
                          value: startverdi,
                          markdownInput: markdownInput,
                        );
                      },
                      heltallInput: (heltallInput) {
                        return HeltallInput(
                          onChange: (value) => inputOnChange(context, value),
                          value: startverdi,
                          heltallInput: heltallInput,
                        );
                      },
                      desimalInput: (desimalInput) {
                        return DesimalInput(
                          onChange: (value) => inputOnChange(context, value),
                          value: startverdi,
                          desimalInput: desimalInput,
                        );
                      },
                      pinkodeInput: (pinkodeInput) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Skriv inn svaret',
                                style: Theme.of(context).textTheme.headline4),
                            const SizedBox(height: 10),
                            MultiInput(
                              length: pinkodeInput.antall,
                              digits: pinkodeInput.antallPerFelt,
                              placeholder: pinkodeInput.hintTekst,
                              onChange: (value) =>
                                  inputOnChange(context, value),
                              value: startverdi,
                            ),
                          ],
                        );
                      },
                      gjomtTekst: (gjomtTekst) {
                        return GjomtTekst(
                          value: startverdi,
                          tekst: gjomtTekst.tekst,
                          placeholder: gjomtTekst.hintTekst,
                          onChange: (value) => inputOnChange(context, value),
                        );
                      },
                    ),
                  ],
                ),
                Consumer(builder: (context, watch, _) {
                  final feil = watch(_feilLosningProvider).state;
                  return $Button(
                    error: feil,
                    onPressed: () => losOppgave(context, oppgave.riktigSvar),
                    text: 'Sjekk svar',
                  ).center();
                }),
              ],
            ).padding(horizontal: 30, vertical: 40),
          ],
        ),
      ).scrollable(),
    );
  }
}
