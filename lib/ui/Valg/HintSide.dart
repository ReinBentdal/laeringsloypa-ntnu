import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loypa/data/model/OppgaveHint.dart';
import 'package:loypa/control/provider/gruppeProvider.dart';
import 'package:loypa/control/provider/hintProvider.dart';
import 'package:loypa/control/provider/loypeStateProvider.dart';
import 'package:loypa/control/provider/oppgaveProvider.dart';
import 'package:loypa/main.dart';
import 'package:loypa/ui/Oppgave/OppgaveFullfortDialog.dart';
import 'package:loypa/ui/Sted/StedSide.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/ShowAnimatedDialog.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:loypa/ui/widgets/atom/varslinger.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nestePersonHintApenProvider = StateProvider<bool>((ref) {
  ref.watch(nestePersonProvider);
  return false;
});

class HintSide extends StatelessWidget {
  static const rute = 'hint side';
  const HintSide({Key? key}) : super(key: key);

  void onLosOppgave(BuildContext context) async {
    final ryggsekkGjenstand = context.read(valgtOppgaveProvider).belonning;
    final gruppeId = context.read(gruppeIdProvider).state;
    assert(gruppeId != null);
    final loypeState = context.read(loypeStateProvider(gruppeId!).notifier);

    loypeState.settLoypeUgyldig(context);

    Navigator.popUntil(context, ModalRoute.withName(Sted.rute));

    if (ryggsekkGjenstand != null) {
      await Future.delayed(Duration(milliseconds: 150));

      await $showAnimatedDialog(
        context: navigatorKey.currentContext ?? context,
        builder: (context) => OppgaveFullfortDialog(ryggsekkGjenstand),
      );
    }
    loypeState.settOppgavenLost(navigatorKey.currentContext ?? context);
  }

  Future<void> hintDialog(BuildContext context, OppgaveHintModel oppgavehint) {
    return varsling(
      context,
      tittel: 'Hintet er:',
      beskrivelse: oppgavehint.hint,
    );
  }

  Future<void> apneDialog(
    BuildContext context,
    void Function() onPressed,
  ) {
    return varslingAdvarsel(
      context,
      tittel: 'Advarsel',
      beskrivelse:
          'Når du låser opp et hint vil det bli lagt til 5 minutter til tiden din. Er du sikker på at du vil gjøre dette?',
      onClick: onPressed,
      knapptekst: 'Åpne hint',
    );
  }

  Future<void> nestePersonDialog(
    BuildContext context,
  ) {
    final person = context.read(nestePersonProvider);
    return varsling(
      context,
      tittel: 'Neste person',
      beskrivelse: 'Neste oppgave å løse: ${person.navn}',
    );
  }

  Future<void> losOppgaveDialog(
    BuildContext context,
  ) {
    return varslingAdvarsel(
      context,
      tittel: 'Advarsel',
      beskrivelse:
          'Hvis du bruker denne funksjonen vil ikke lenger spillet ditt være gyldig. Da vil spillet ikke havne på ledertavlen når du fullfører spillet.\n\nHvis du velger å gjøre dette kan du forstatt fullføre spillet på vanlig vis.\n\nEr du sikker på at du vil fortsette?',
      onClick: () => onLosOppgave(context),
      knapptekst: 'Løs oppgaven',
    );
  }

  Future<void> losOppgaveLaastDialog(
    BuildContext context,
  ) {
    return varslingAdvarsel(
      context,
      tittel: 'Advarsel',
      beskrivelse:
          'Denne funksjonen skal kun brukes hvis du ikke får til oppgaven.\n\nFor å åpne oppgaven må alle hintene først brukes.',
    );
  }

  void apneNestePersonHint(BuildContext context) {
    context.read(nestePersonHintApenProvider).state = true;

    final gruppeId = context.read(gruppeIdProvider).state;
    FirebaseFirestore.instance.collection('grupper').doc(gruppeId).update({
      'hint_brukt': FieldValue.increment(1),
    });
    Navigator.pop(context);
  }

  void apneHint(BuildContext context, int i) {
    final gruppeId = context.read(gruppeIdProvider).state;
    assert(gruppeId != null);
    context.read(loypeStateProvider(gruppeId!).notifier).settHintBrukt(context, i);
    FirebaseFirestore.instance.collection('grupper').doc(gruppeId).update({
      'hint_brukt': FieldValue.increment(1),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SubpageAppBar(title: 'Hint'),
            const SizedBox(height: 20),
            Consumer(
              builder: (context, watch, _) {
                final oppgavehint = watch(oppgaveHintProvider);
                final nestePersonApen = watch(nestePersonHintApenProvider).state;
                final personState = watch(personStateProvider);

                return SColumn(
                  separator: const SizedBox(height: 10),
                  children: [
                    Text(
                      'Få et hint som forteller hvilke oppgave som nå kan løses',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (!nestePersonApen)
                      $Button(
                        text: 'Neste oppgave hint',
                        onPressed: () => apneDialog(context, () {
                          apneNestePersonHint(context);
                        }),
                        color: Theme.of(context).errorColor,
                      ).padding(bottom: 20),
                    if (nestePersonApen)
                      $Button(
                        text: 'Vis neste oppgave',
                        onPressed: () => nestePersonDialog(context),
                        color: Theme.of(context).accentColor,
                      ).padding(bottom: 20),
                    Text(
                      'Få hint for hvordan neste oppgave kan løses',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    /* button for each available person hint */
                    ...oppgavehint
                        .asMap()
                        .map((i, hint) {
                          return MapEntry(i, () {
                            if (personState.hintBrukt[i] == false) {
                              return $Button(
                                text: 'Åpne hint',
                                onPressed: () => apneDialog(context, () => apneHint(context, i)),
                                color: Theme.of(context).errorColor,
                              );
                            } else {
                              return $Button(
                                text: 'Les hint',
                                onPressed: () => hintDialog(context, hint),
                              );
                            }
                          }());
                        })
                        .values
                        .toList()
                  ],
                );
              },
            ),
            const Divider(
              height: 40,
              color: Colors.black,
              thickness: 1,
            ).constrained(width: 100),
            Consumer(builder: (context, watch, _) {
              // final alleHintBrukt = watch(alleHintBruktProvider);
              final alleHintBrukt = true;
              return $Button(
                color: alleHintBrukt ? Theme.of(context).errorColor : Colors.grey,
                text: 'Løs oppgaven',
                // onPressed: () => alleHintBrukt ? losOppgaveDialog(context) : losOppgaveLaastDialog(context),
                onPressed: () => losOppgaveDialog(context),
              );
            }),
          ],
        ),
      ).padding(horizontal: 30, vertical: 40).scrollable(),
    );
  }
}
