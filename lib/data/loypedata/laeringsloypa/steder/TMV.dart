// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:loypa/data/loypedata/laeringsloypa/gjenstander.dart';
// import 'package:loypa/data/model/Oppgave.dart';
// import 'package:loypa/data/model/Person.dart';
// import 'package:loypa/data/model/OppgaveHint.dart';
// import 'package:loypa/data/model/Sted.dart';
// import 'package:loypa/data/type/InputType.dart';

// final tmv = StedsModel(
//   id: 'p8bk52if35GpU8OZCfCp',
//   stedsnavn: 'Trondheim Mekaniske Verksted',
//   stedsbeskrivelse:
//       'Fabrikken ble opprinnelig grunnlagt i 1843 på Øvre Bakklandet under navnet "Fabriken ved Nidelven", og var en av de første mekaniske verkstedene i landet. Det første norsk-konstruerte dampskipet ble bygd av Nidelvens, og noen år senere også det første damplokomotivet "Thrønderen". Verkstedet ble i 1890 flyttet til Rosenborgbassenget. Her ble det bygget skip, både passasjer- og lasteskip, for kyst og fjordfart. Trondheim Mekaniske Vekstedet ble lagt ned i 1983.',
//   kartmarkering: [
//     LatLng(63.43526335402777, 10.408759014004492),
//     LatLng(63.43539643628126, 10.408652188641929),
//     LatLng(63.435459564826346, 10.409613616905),
//     LatLng(63.43500445345511, 10.410836041574717),
//     LatLng(63.4349084918556, 10.410723388792722),
//     LatLng(63.43466858644007, 10.411538780321216),
//     LatLng(63.434563506613486, 10.411383691569588),
//   ],
//   personer: [
//     PersonModel(
//       id: '07M311HjJUu9FfOrKkftvg',
//       navn: 'Arbeider',
//       bilde: 'Arbeider.svg',
//       samtale: PersonSamtaleModel(
//         tittel: 'Arbeideren sier:',
//         dialog: [
//           'Velkommen til Trondheim Mekaniske Verksted! Mitt navn er Halvor Eriksen.\n\nNå er det restauranter og butikker på Solsiden, men for mange år siden var dette et skipsverft. Her bygget og reparerte man skip. Verkstedet kunne bygge skip opp mot 4500 tonn! Dessverre ble TMV nedlagt i 1983 og mange arbeidere mistet jobben sin.',
//           'Jeg har mistet arbeidslisten min fra 1885 og husker ikke hvor mye jeg fikk i månedslønn.\n\nKan du hjelpe meg?',
//         ],
//       ),
//       oppgave: OppgaveModel(
//         oppgavetekst: 'Hvor mye skal jeg få i månedslønn?',
//         typespesifikk: DesimalInputType(
//           enhet: 'kr',
//         ),
//         riktigSvar: '51.92',
//         rekkefolge: 2,
//         hint: [
//           OppgaveHintModel(
//               hint:
//                   'Slå opp i Reiseboka og finn ut hvor mye arbeideren skal få i dagslønn.'),
//           OppgaveHintModel(
//               hint:
//                   'Se på timelisten mottatt fra Servitøren for å finne ut hvor mye Arbeideren tjener i løpet av en måned.'),
//         ],
//         belonning: [
//           tannhjul,
//           fastnokkel,
//         ],
//       ),
//     ),
//     PersonModel(
//       id: 'NsJKt-uuBEWT1bpxvvP7jw',
//       navn: 'Servitør',
//       bilde: 'Servitor.svg',
//       samtale: PersonSamtaleModel(
//         tittel: 'Servitøren sier:',
//         dialog: [
//           'Hei, jeg heter Nora og er servitør på et av utestedene her på solsiden.\n\nEn av kundene spør om han kan få en nummer 9, men jeg vet ikke hva det er. Kan du hjelpe meg?',
//         ],
//       ),
//       oppgave: OppgaveModel(
//         oppgavetekst: 'Hvilken matrett er nummer 9?',
//         riktigSvar: 'Rekesmørbrød',
//         typespesifikk: TekstInputType(),
//         rekkefolge: 1,
//         hint: [
//           OppgaveHintModel(
//               hint: 'Se på menyen i ryggsekken, mottatt fra Kokken'),
//         ],
//         belonning: [
//           timeliste,
//         ],
//       ),
//     ),
//     PersonModel(
//       id: 'NltlxgovU0KMvwPoBJv1jw',
//       navn: 'Kiste',
//       bilde: 'Kiste.svg',
//       oppgave: OppgaveModel(
//         oppgavetekst: 'Finn koden til kisten og skriv den inn.',
//         riktigSvar: '5-9-4-3',
//         oppgaveKnappTekst: 'Åpne',
//         typespesifikk: PinkodeInputType(
//           antall: 4,
//           hintTekst: ['♦', '♣', '♥', '♠'],
//         ),
//         rekkefolge: 4,
//         hint: [
//           OppgaveHintModel(hint: 'Let etter et kort i Reiseboka.'),
//           OppgaveHintModel(
//               hint: 'Se på bilde mottatt fra Ingeniør John Trenery'),
//         ],
//         belonning: [
//           slektstre,
//           ravnkloaBilde,
//           kart,
//         ],
//       ),
//     ),
//     PersonModel(
//       id: 'jFk818ZipkOBT5HdXPcmUA',
//       navn: 'Ingeniør John Trenery',
//       bilde: 'Ingenior.svg',
//       samtale: PersonSamtaleModel(
//         tittel: 'John Trenery sier:',
//         dialog: [
//           'God aften! Jeg heter John Trenery og jeg var faglig ansvarlig på Fabrikken ved Nidelven. Denne fabrikken ble slått sammen med Trondheim Mekaniske Verksted og jeg tok over som teknisk direktør.\n\nJeg skal bestille noen deler til verkstedet, men jeg trenger hjelp med å finne ut hvilke deler jeg skal bestille. Kan du hjelpe med?',
//           'Jeg skal ha:\n\n1. Antall "tenner" på tannhjulet\n2. Størrelsen på fastnøkkelen.\n3. Lengden på skruen.',
//         ],
//       ),
//       oppgave: OppgaveModel(
//         oppgavetekst:
//             'Koden er:\n1. Antall "tenner" på tannhjulet\n2. Størrelsen på fastnøkkelen.\n3. Lengden på skruen.',
//         riktigSvar: '8-12-16',
//         typespesifikk: PinkodeInputType(
//           antall: 3,
//           antallPerFelt: 2,
//           // hintTekst: ['1', '2', '3'],
//         ),
//         rekkefolge: 3,
//         hint: [
//           OppgaveHintModel(hint: 'Se på gjenstandene mottatt fra Arbeideren'),
//           OppgaveHintModel(
//               hint: 'Slå opp i Reiseboka for å finne lengden til skruen.'),
//         ],
//         belonning: [pokerBilde],
//       ),
//     ),
//   ],
// );
