import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loypa/config/theme/lighttheme.dart';
import 'package:loypa/ui/Dashbord/AvsluttLoype.dart';
import 'package:loypa/ui/Dashbord/LoypeLedertavle.dart';
import 'package:loypa/ui/Valg/HintSide.dart';
import 'package:loypa/ui/Valg/ValgSide.dart';
import 'package:loypa/ui/OpprettSpill/AdminLobby.dart';
import 'package:loypa/ui/Dashbord/DashbordSide.dart';
import 'package:loypa/ui/OpprettSpill/GruppespillInfo.dart';
import 'package:loypa/ui/OpprettSpill/Lobby.dart';
import 'package:loypa/ui/OpprettSpill/OpprettGruppe.dart';
import 'package:loypa/ui/OpprettSpill/VelgBrukernavnSingle.dart';
import 'package:loypa/ui/OpprettSpill/VelgLoype.dart';
import 'package:loypa/ui/OpprettSpill/VelgBrukernavnGruppe.dart';
import 'package:loypa/ui/Dashbord/VerifisererPin.dart';
import 'package:loypa/ui/Oppgave/OppgaveSide.dart';
import 'package:loypa/ui/Reiseboka/ReisebokaSide.dart';
import 'package:loypa/ui/Ryggsekk/RyggsekkSide.dart';
import 'package:loypa/ui/Kart/KartSide.dart';
import 'package:loypa/ui/Dashbord/LoypeLaster.dart';
import 'package:loypa/ui/Sted/StedSide.dart';

Future<void> main() async {
  // Forhindre landskapsmodus
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /* initialize firebase */
  await Firebase.initializeApp();

  /* initialize local storage and load to memory */
  await Hive.initFlutter();
  await Hive.openBox<Map<dynamic, dynamic>>('loyper');

  // ønsker å logge inn brukeren slik at man kan identifisere brukeren med en id
  await FirebaseAuth.instance.signInAnonymously();

  runApp(
    // river_pod provider
    ProviderScope(
      child: App(),
    ),
  );
}

// bruker til å få tak i BuildContext fra hvor som helst
final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Læringsløype',
      theme: lightTheme,
      initialRoute: DashbordSide.rute,
      navigatorKey: navigatorKey,
      routes: {
        LoypeLaster.rute: (_) => LoypeLaster(),
        Sted.rute: (_) => Sted(),
        OppgaveSide.rute: (_) => OppgaveSide(),
        Ryggsekk.rute: (_) => Ryggsekk(),
        Reiseboka.rute: (_) => Reiseboka(),
        KartSide.rute: (_) => KartSide(),
        ValgSide.rute: (_) => ValgSide(),
        HintSide.rute: (_) => HintSide(),
        DashbordSide.rute: (_) => DashbordSide(),
        VelgLoype.rute: (_) => VelgLoype(),
        VerifiserPin.rute: (_) => VerifiserPin(),
        Lobby.rute: (_) => Lobby(),
        AdminLobby.rute: (_) => AdminLobby(),
        AvsluttLoype.rute: (_) => AvsluttLoype(),
        GruppespillInfo.rute: (_) => GruppespillInfo(),
        VelgBrukernavnGruppe.rute: (_) => VelgBrukernavnGruppe(),
        VelgBrukernavnSingle.rute: (_) => VelgBrukernavnSingle(),
        OpprettGruppe.rute: (_) => OpprettGruppe(),
        LoypeLedertavle.rute: (context) {
          return LoypeLedertavle(
            loypeId: ModalRoute.of(context)?.settings.arguments as String?,
          );
        },
      },
    );
  }
}
