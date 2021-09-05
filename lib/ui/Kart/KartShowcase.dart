import 'package:flutter/material.dart';
import 'package:loypa/ui/widgets/molekyl/PositionedMultipageDialog.dart';
import 'package:loypa/ui/widgets/molekyl/Showcase.dart';

final dinLokasjonRef = GlobalKey();
final nesteLokasjonRef = GlobalKey();
final tidsbrukRef = GlobalKey();

void visKartShowcase(BuildContext context,
    [void Function()? onShowcaseFerfig]) {
  Navigator.push(
    context,
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (contex, _, __t) {
        return Showcase(
          ferdig: () {
            Navigator.pop(context);
            if (onShowcaseFerfig != null) onShowcaseFerfig();
          },
          steg: [
            PositionedDialogStegModel(
              tittel: 'Velkommen!',
              beskrivelse:
                  'Velkommen til løypa! Løypa består av flere lokasjoner hvor hver lokasjon har forskjellige oppgaver å løse.\nKartet vil veilede deg mellom disse lokasjonene.\n\nTrykk på “Neste” for å gå videre.',
            ),
            PositionedDialogStegModel(
              widgetRef: dinLokasjonRef,
              tittel: 'Din lokasjon',
              beskrivelse:
                  'Vis din lokasjon på kartet ved å trykke på den fremhevede knappen.\n\nTrykk på “Neste” for å gå videre.',
            ),
            PositionedDialogStegModel(
              widgetRef: nesteLokasjonRef,
              tittel: 'Neste lokasjon',
              beskrivelse:
                  'Vis lokasjonen du er på vei til ved å trykke på den fremhevede knappen.\n\nTrykk på “Neste” for å gå videre.',
            ),
            PositionedDialogStegModel(
              widgetRef: tidsbrukRef,
              tittel: 'Tidsbruk',
              beskrivelse:
                  'Når man ankommer den første lokasjonen i spillet, vil tiden starte. Når hele løypen er fullført, vil resultatet publiseres på ledertavlen.\nØnsker du et godt resultat er det lurt å være rask!\n\nTrykk på “Neste” for å gå videre.',
            ),
            PositionedDialogStegModel(
              tittel: 'Lykke til!',
              beskrivelse:
                  'Lykke til med løypen!\n\nTrykk på “Lukk” for å avslutte veilederen.',
            ),
          ],
        );
      },
    ),
  );
}
