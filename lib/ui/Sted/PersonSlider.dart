import 'package:flutter/material.dart';
import 'package:loypa/data/model/Person.dart';
import 'package:loypa/data/provider/stedProvider.dart';
import 'package:loypa/data/provider/oppgaveProvider.dart';
import 'package:loypa/ui/Oppgave/OppgaveSide.dart';
import 'package:loypa/ui/Sted/PersonSelector.dart';
import 'package:loypa/ui/Sted/PersonSnakkDialog.dart';
import 'package:loypa/ui/Sted/StedShowcase.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/ShowAnimatedDialog.dart';
import 'package:loypa/ui/widgets/atom/UpdateAlert.dart';
import 'package:loypa/ui/widgets/molekyl/FirebaseImage.dart';
import 'package:loypa/ui/widgets/molekyl/PageSlider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonSlider extends StatefulWidget {
  const PersonSlider({
    Key? key,
    required this.personer,
  }) : super(key: key);

  final List<PersonModel> personer;

  @override
  _PersonSliderState createState() => _PersonSliderState();
}

class _PersonSliderState extends State<PersonSlider> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final initialIndex = 1000 - (1000 % widget.personer.length);
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SColumn(
      separator: const SizedBox(height: 20),
      children: [
        PageSlider(
          controller: _pageController,
          onPageChange: (i) => context.read(valgtPersonIndexProvider).state = i,
          children: widget.personer.map((person) {
            return FirebaseImage(
              prefix: 'personer/',
              path: person.bilde,
              semanticsLabel: 'Bilde av ${person.navn}',
            );
          }).toList(),
        ).expanded(),
        Consumer(
          builder: (context, watch, _) {
            final valgtPerson = watch(valgtPersonProvider);
            final samtaleLest = watch(personSamtaleLestProvider(
                context.read(valgtPersonIndexProvider).state));
            final oppgaveLost = watch(valgtOppgaveProvider).oppgaveLost;

            return SColumn(
              separator: const SizedBox(height: 10),
              children: [
                // valg av person å snakke med
                PersonSelector(
                  nextPage: _pageController.nextPage,
                  prevPage: _pageController.previousPage,
                  personNavn: valgtPerson.navn,
                ).center(),

                // Snakk knapp. Bare vis hvis samtale tilgjengelig
                SizedBox(
                  key: snakkRef,
                  child: valgtPerson.samtale != null
                      ? $UpdateAlert(
                          showAlert: !samtaleLest.state,
                          child: $Button(
                            onPressed: () {
                              samtaleLest.state = true;
                              $showAnimatedDialog(
                                context: context,
                                builder: (_) => $PersonSnakkDialog(),
                              );
                            },
                            text: 'Snakk',
                          ),
                        )
                      : SizedBox(height: 50, width: 200)
                          .decorated(color: Colors.blueGrey[100])
                          .clipRRect(all: 10),
                ),

                // Løs oppgave knapp
                $Button(
                  key: losOppgaveRef,
                  onPressed: oppgaveLost
                      ? null
                      : () => Navigator.pushNamed(context, OppgaveSide.rute),
                  text: valgtPerson.oppgave.oppgaveKnappTekst ?? 'Løs oppgave',
                ),
              ],
            );
          },
        ),
      ],
    ).expanded();
  }
}
