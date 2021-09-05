import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loypa/data/loypedata/laeringsloypa/gjenstander.dart';
import 'package:loypa/data/model/Oppgave.dart';
import 'package:loypa/data/model/Person.dart';
import 'package:loypa/data/model/PersonHint.dart';
import 'package:loypa/data/model/Sted.dart';
import 'package:loypa/data/type/InputType.dart';

final ravnkloa = StedsModel(
  stedsnavn: 'Ravnkloa',
  stedsbeskrivelse:
      'Det har foregått handel med fisk i Ravnkloa i mange hundre år. På 1800-tallet foregikk det også torghandel her. Dette startet i 1841. I 1896 ble det anlagt et fisketorg i Ravnkloa, som ble flyttet innendørs i en midlertidig fiskehall i 1945. På 1960-tallet ble fiskehallen erstattet med en ny, midlertidig fiskehall, som ble revet først i 1999. Dagens fiskhall ble åpnet i desember 2000.',
  kartmarkering: [
    LatLng(63.434075, 10.392523),
    LatLng(63.433892, 10.391740),
    LatLng(63.433618, 10.392205),
    LatLng(63.433750, 10.392743),
    LatLng(63.433674, 10.393350),
    LatLng(63.433886, 10.393602),
    LatLng(63.434283, 10.393340),
    LatLng(63.434255, 10.393225),
    LatLng(63.434155, 10.393243),
    LatLng(63.433948, 10.393209),
    LatLng(63.433952, 10.392727),
  ],
  personer: [
    PersonModel(
      navn: 'Fisker',
      bilde: 'Fisker.svg',
      samtale: PersonSamtaleModel(
        tittel: 'Fiskeren sier:',
        dialog: [
          'Hei, jeg heter Roar og er en fisker som holder til her på Ravnkloa.\n\nJeg har glemt navnet på båten til bestefaren min, kan du hjelpe meg å ut av hva navnet er?',
        ],
      ),
      oppgave: OppgaveModel(
        oppgavetekst: "Hva heter båten til fiskeren sin bestefar?",
        riktigSvar: "Frøya",
        typespesifikk: TekstInputType(),
        rekkefolge: 1,
        hint: [
          OppgaveHintModel(hint: 'Se på bilde i ryggsekken.'),
        ],
        belonning: [torsk],
      ),
    ),
    PersonModel(
      navn: 'Kokk',
      bilde: 'Kokk.svg',
      samtale: PersonSamtaleModel(
        tittel: 'Kokken sier',
        dialog: [
          'Heisann! Mitt navn er Mathilde og jeg er kokk her på Ravnkloa. Vi lager alle typer sjømat med lokal fisk.\n\nEn Gjest lurte på om han kan få en fiskerett fra 1955, men jeg vet ikke hvilken han mener. Kan du hjelpe meg?'
        ],
      ),
      oppgave: OppgaveModel(
        oppgavetekst: "Hva heter fiskeretten fra 1955?",
        riktigSvar: "Fiskepinner",
        typespesifikk: TekstInputType(),
        rekkefolge: 1,
        hint: [
          OppgaveHintModel(
              hint:
                  'Slå opp i reiseboka og se om du finner svaret i teksten om "Mattradisjoner".')
        ],
        belonning: [meny],
      ),
    ),
    PersonModel(
      navn: 'Kjøpmann\nPeder Raffnklau',
      bilde: 'Kjopmann.svg',
      samtale: PersonSamtaleModel(
        tittel: 'Peder Raffnklau sier:',
        dialog: [
          'God dag! Jeg heter Peder Raffnklau og er kjøpmann. Visste du at Ravnkloa er oppkalt etter meg og min slekt?',
          'Jeg vil gjerne kjøpe torsken din. Hvor mye skal du har for den?',
        ],
      ),
      oppgave: OppgaveModel(
        oppgavetekst: "Hvor mye koster torsken din?",
        riktigSvar: "120",
        typespesifikk: HeltallInputType(
          enhet: "kr",
        ),
        rekkefolge: 2,
        hint: [
          OppgaveHintModel(
              hint:
                  'Se på fisken i ryggsekken, mottatt fra Kokken. Finn ut hvor mye den veier.'),
          OppgaveHintModel(
              hint:
                  'Les "Prisnivå i Norge"-siden i Reiseboka for å finne prisen på fisken i kg.'),
        ],
        belonning: [kort],
      ),
    ),
  ],
);
