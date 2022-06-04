// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:loypa/data/loypedata/laeringsloypa/gjenstander.dart';
// import 'package:loypa/data/model/Oppgave.dart';
// import 'package:loypa/data/model/Person.dart';
// import 'package:loypa/data/model/OppgaveHint.dart';
// import 'package:loypa/data/model/Sted.dart';
// import 'package:loypa/data/type/InputType.dart';

// final stiftsgarden = StedsModel(
//   id: '44K14oJntDU1O5lBB0fJ',
//   stedsnavn: 'Stiftsgården',
//   stedsbeskrivelse:
//       'Stiftsgården i Trondheim ligg sentralt til i paradegata i byen, Munkegata, rett nord for Torget. Dette bypaleet frå 1770-åra er ein av dei største trebygningane i Norden og er i dag den offisielle kongebustaden i byen.',
//   kartmarkering: [
//     LatLng(63.43191562671106, 10.39552950543929),
//     LatLng(63.43188520298612, 10.396714587763155),
//     LatLng(63.43135745270476, 10.396704798457337),
//     LatLng(63.43138239287216, 10.39574571024301),
//   ],
//   personer: [
//     PersonModel(
//       id: 'pTRZ72--qkuGp1zRGdgw3A',
//       navn: 'Husassistent',
//       bilde: 'Husassistent.svg',
//       samtale: PersonSamtaleModel(
//         tittel: 'Husassistenden sier:',
//         dialog: [
//           'Hei, jeg jobber som husassistent på Stiftsgården. Jeg vasker rommene i hele huset slik at de alltid er rene og pene. Kongen ba meg sende et brev for han, men noen av ordene ble vasket ut. Kan du hjelpe meg å fylle ut ordene som mangler?',
//         ],
//       ),
//       oppgave: OppgaveModel(
//         oppgavetekst: 'Fyll inn ordene som mangler',
//         riktigSvar: 'Hund-Fiskemarked-Grønt',
//         typespesifikk: GjomtTekstInputType(
//           tekst: [
//             'Til Peder Raffnklau\nFjordgata 72\n7010 Trondheim\n\n\nTil Peder Raffnklau\n\nJeg mistet et bilde da jeg besøkte deg forrige uke, og jeg håper å kunne få det tilbake. Bilde viser Ravnkloa fra 1907. Klokken på bildet er tre og under klokken går det en mann med',
//             '. Det er mange store skip i havnen, men det er ingen av dem som er ute og seiler. På veggen ved det nærmeste huset står det',
//             'i store bokstaver. Dette huset er farget',
//             'og bokstavene er sorte.\n\Dersom du finner bildet, håper jeg du kan sende det til meg så snart du har mulighet!\n\nVennlig hilsen\n\nKong Harald V'
//           ],
//         ),
//         rekkefolge: 1,
//         hint: [
//           OppgaveHintModel(hint: 'Se på bildene i ryggsekken.'),
//         ],
//         belonning: [krone],
//       ),
//     ),
//     PersonModel(
//       id: 'nL9GbfpxN0SwCRsT9wPZLA',
//       navn: 'Kronprins Håkon',
//       bilde: 'Kronprins.svg',
//       samtale: PersonSamtaleModel(
//         tittel: 'Kronprins Håkon sier:',
//         dialog: [
//           'Hei! Mitt navn er Håkon og jeg er kronprins i Norge. Det betyr at jeg overtar som konge etter min far, kong Harald.\n\nJeg trenger litt hjelp med en gåte, kan du hjelpe meg?',
//           'Du skal finne seks bokstaver og dette er gåten.\n\nDet blå huset, ved min mors gate.\nDet grønne huset, ved min gate.\nDet blå huset, ved min fars gate.\nDet blå huset, ved min gate.\nDet grønne huset, ved min mors gate.\nDet grønne huset, ved min fars gate.',
//         ],
//       ),
//       oppgave: OppgaveModel(
//         oppgavetekst:
//             'Kronprinsens gåte er:\n1. Det blå huset, ved min mors gate.\n2. Det grønne huset, ved min gate.\n3. Det blå huset, ved min fars gate.\n4. Det blå huset, ved min gate.\n5. Det grønne huset, ved min mors gate.\n6. Det grønne huset, ved min fars gate.',
//         riktigSvar: 'fornem',
//         typespesifikk: TekstInputType(),
//         hint: [
//           OppgaveHintModel(
//               hint:
//                   'Se på kartett i ryggsekken og finn bokstavene som samsvarer med beskrivelsene.'),
//         ],
//         rekkefolge: 1,
//         belonning: [notat],
//       ),
//     ),
//     PersonModel(
//       id: 'gyzDiFvWD0yRSiRlS3imzg',
//       navn: 'Hvelv',
//       bilde: 'Hvelv.svg',
//       oppgave: OppgaveModel(
//         oppgavetekst: 'Koden til hvelvet i Stiftsgården.',
//         riktigSvar: '1-4-7-3',
//         oppgaveKnappTekst: 'Åpne hvelv',
//         typespesifikk: PinkodeInputType(
//           antall: 4,
//         ),
//         rekkefolge: 2,
//         hint: [
//           OppgaveHintModel(hint: 'Les notatet mottatt fra Kronprins Håkon.'),
//           OppgaveHintModel(hint: 'Se på bildet mottatt fra Husassistenden.'),
//           OppgaveHintModel(
//               hint:
//                   'Rekkefølgen på de skinnende steinene er det samme som rekkefølgen til steinene i reiseboka.'),
//         ],
//       ),
//     ),
//   ],
// );
