import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:loypa/data/provider/gruppeProvider.dart';
import 'package:loypa/data/provider/loypeProvider.dart';
import 'package:loypa/ui/OpprettSpill/VelgBrukernavnSingle.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoypeInfo extends StatelessWidget {
  static const String rute = 'loype info';
  const LoypeInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // laste løype mens man går igjennom introduksjon
    context.read(valgtLoypeProvider);

    final dekorasjon = (BuildContext context) => PageDecoration(
          titleTextStyle: Theme.of(context).textTheme.headline2?.copyWith(
                    fontSize: 32,
                  ) ??
              TextStyle(),
          bodyTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );

    return WillPopScope(
      onWillPop: () async {
        context.read(loypeIdProvider).state = null;
        context.read(gruppeIdProvider).state = null;
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SubpageAppBar(
                title: 'Tilbake',
                titleColor: Theme.of(context).primaryColor,
              ).padding(top: 40),
              IntroductionScreen(
                color: Theme.of(context).accentColor,
                skip: const Text('Hopp over'),
                next: const Icon(Icons.navigate_next),
                done: const Text('Start',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                showSkipButton: true,
                curve: Curves.fastLinearToSlowEaseIn,
                onDone: () {
                  Navigator.popAndPushNamed(context, VelgBrukernavnSingle.rute);
                },
                dotsDecorator: DotsDecorator(
                    color: Colors.grey.shade300,
                    activeColor: Theme.of(context).primaryColor),
                dotsFlex: 2,
                pages: [
                  PageViewModel(
                    title: 'Velkommen!',
                    body:
                        'Spillet vil ta deg igjennom en løype hvor hver lokasjon i løypen vil ha forskjellige oppgaver å løse.',
                    decoration: dekorasjon(context),
                    // image: Placeholder().constrained(height: 300),
                  ),
                  PageViewModel(
                    title: 'Løs personenes oppgave',
                    body:
                        'Snakk med personene og løs oppgavene ved å bruke ressursene tilgjengelig i appen.\n\nMerk at ikke alle oppgavene kan løses med en gang. Er det problemer med å løse en oppgave kan dette bety at en annen oppgave må løses først.',
                    image: SvgPicture.asset('assets/Person.svg')
                        .padding(all: 20, top: 40),
                    decoration: dekorasjon(context),
                  ),
                  PageViewModel(
                    title: 'Ryggsekk',
                    body:
                        'Ryggsekken inneholder gjenstander mottatt fra personer underveis i løypen. Bruk disse gjenstandene til å løse nye oppgaver.',
                    image: SvgPicture.asset('assets/Ryggsekk.svg')
                        .padding(all: 20, top: 40),
                    decoration: dekorasjon(context),
                  ),
                  PageViewModel(
                    title: 'Reiseboka',
                    body:
                        'I Reiseboka finner man nyttig informasjon som kan brukes til å løse oppgavene.',
                    image: SvgPicture.asset('assets/Reiseboka.svg')
                        .padding(all: 20, top: 40),
                    decoration: dekorasjon(context),
                  ),
                  PageViewModel(
                    title: 'Hint',
                    body:
                        'Hvis det er noen problemer med å løse en oppgave, kan man velge å bruke et hint. Se etter ikonet ovenfor for å få et hint.\n\nDette vil gi en straffetid til den totale tiden brukt på løypen.',
                    image: Icon(
                      Icons.help_outline,
                      size: 200,
                      color: Theme.of(context).accentColor,
                    ),
                    decoration: dekorasjon(context),
                  ),
                  PageViewModel(
                    title: 'Bruk den tiden du vil',
                    body:
                        'Når løypen er fullført kan man frivillig velge å publisere tiden brukt i ledertavlen. \n\nTiden starter når man ankommer første lokasjon.',
                    image: SvgPicture.asset('assets/Klokke.svg')
                        .padding(all: 20, top: 40),
                    decoration: dekorasjon(context),
                  ),
                ],
              ).expanded(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
