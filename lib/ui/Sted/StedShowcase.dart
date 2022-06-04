import 'package:flutter/material.dart';
import 'package:loypa/ui/widgets/molekyl/PositionedMultipageDialog.dart';
import 'package:loypa/ui/widgets/molekyl/Showcase.dart';

final ryggsekkRef = GlobalKey();
final reisebokaRef = GlobalKey();
final losOppgaveRef = GlobalKey();
final snakkRef = GlobalKey();
final personerNavigerRef = GlobalKey();
final hjelpRef = GlobalKey();

void visStedShowcase(BuildContext context,
    [void Function()? onSHowcaseFerfig]) {
  Navigator.push(
    context,
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (contex, _, __t) {
        return Showcase(
          ferdig: () {
            Navigator.pop(context);
            if (onSHowcaseFerfig != null) onSHowcaseFerfig();
          },
          steg: [
            PositionedDialogStegModel(
              widgetRef: snakkRef,
              tittel: 'Velkommen!',
              beskrivelse:
                  'Velkommen til første lokasjon! På hver lokasjon vil du møte flere personer som har en oppgave til deg som du må løse. Du kan snakke med en person ved å trykke på “Snakk”-knappen under.\n\nTrykk på “Neste” for å gå videre.',
            ),
            PositionedDialogStegModel(
              widgetRef: losOppgaveRef,
              tittel: 'Løs oppgavene',
              beskrivelse:
                  'Du kan trykke på “Løs oppgave”-knappen for å forsøke å løse oppgaven en person har gitt deg. Når du har løst alle oppgavene vil du kunne gå videre til neste lokasjon.\n\nTrykk på “Neste” for å gå videre.',
            ),
            PositionedDialogStegModel(
              widgetRef: personerNavigerRef,
              tittel: 'Navigasjon',
              beskrivelse:
                  'Du kan navigere mellom personene ved å klikke på pilene under bildet.\n\nTrykk på “Neste” for å gå videre.',
            ),
            PositionedDialogStegModel(
              widgetRef: ryggsekkRef,
              tittel: 'Ryggsekken',
              beskrivelse:
                  'Når du løser en oppgave kan det hende at du mottar en gjenstand. Alle gjenstandene du mottar vil legges i ryggsekken. Du kan klikke på ryggsekk-ikonet for å se alle gjenstandene du har mottatt. \n\nDu må søke etter informasjon, skjulte symboler og tall på gjenstandene for å løse oppgavene!\n\nTrykk på “Neste” for å gå videre.',
            ),
            PositionedDialogStegModel(
              widgetRef: reisebokaRef,
              tittel: 'Reiseboka',
              beskrivelse:
                  'I Reiseboka er det samlet informasjon om ulike temaer. Du må lete i boka etter informasjon, skjulte symboler og tall for å løse oppgavene,\n\nTrykk på “Neste” for å gå videre.',
            ),
            PositionedDialogStegModel(
              widgetRef: hjelpRef,
              tittel: 'Hjelp',
              beskrivelse:
                  'Dersom du trenger hjelp kan du trykke på tannhjul-ikonet øverst til høyre. Her vil du ha muligheten til å få et hint hvis du trenger det. \nDersom du benytter deg av et hint vil 5 minutter bli lagt til tiden din!\n\nDu kan også trykke på tannhjul-ikonet for å åpne denne veilederen på nytt.\n\nLykke til med første oppgave i løypen!',
            ),
          ],
        );
      },
    ),
  );
}
