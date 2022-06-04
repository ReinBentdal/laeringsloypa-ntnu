import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/control/provider/stedProvider.dart';
import 'package:loypa/control/provider/gruppeProvider.dart';
import 'package:loypa/control/provider/kartProvider.dart';
import 'package:loypa/control/provider/timerProvider.dart';
import 'package:loypa/main.dart';
import 'package:loypa/ui/Kart/Dialoger/FerdigMedLokasjon.dart';
import 'package:loypa/ui/Kart/Dialoger/FremmeVedLokasjon.dart';
import 'package:loypa/ui/Kart/GoogleMaps.dart';
import 'package:loypa/ui/Kart/KartShowcase.dart';
import 'package:loypa/ui/Kart/KartSide.dart';
import 'package:loypa/ui/Kart/Dialoger/NyLokasjon.dart';
import 'package:loypa/ui/Kart/Dialoger/SpillFerdig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Kart extends StatefulWidget {
  const Kart({Key? key}) : super(key: key);

  @override
  _KartState createState() => _KartState();
}

class _KartState extends State<Kart> {
  final googleMaps = GoogleMaps();
  bool visDialoger = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();

      final harSettShowcase = prefs.getBool('kart-showcase') ?? false;

      if (harSettShowcase == false) {
        visKartShowcase(context, () {
          setState(() {
            visDialoger = true;
          });
          final ctx = navigatorKey.currentContext ?? context;
          final tilstand = ctx.read(kartTilstandProvider);
          if (tilstand.state == KartTilstand.Ankommet) {
            visTilstandDialog(context, tilstand);
          }
        });
      } else {
        setState(() {
          visDialoger = true;
        });
      }

      prefs.setBool('kart-showcase', true);
    });
    super.initState();
  }

  Future<void> startTid(BuildContext context) async {
    // antar gruppe veldefinert
    final gruppeId = context.read(gruppeIdProvider).state;
    final gruppe = await context.read(gruppeProvider.future);
    final tid = DateTime.now();
    context.read(timerProvider.notifier).start();
    if (gruppe.startTid == null) {
      FirebaseFirestore.instance.collection('grupper').doc(gruppeId).update({
        'start_tid': tid,
      });
    }
  }

  void visTilstandDialog(
    BuildContext context,
    StateController<KartTilstand> tilstand,
  ) async {
    final stedIndex = context.read(stedIndexProvider);
    final timer = context.read(timerProvider.notifier);
    if (!timer.active) {
      if (stedIndex > 0) {
        final gruppe = await context.read(gruppeProvider.future);
        timer.sett(gruppe.startTid ?? DateTime.now());
        startTid(context);
      } else if (stedIndex == 0 && (tilstand.state != KartTilstand.NyLokasjon || tilstand.state != KartTilstand.PaVei)) {
        startTid(context);
      }
    }
    
    switch (tilstand.state) {
      case KartTilstand.NyLokasjon:
        bottomSheet(
          context: context,
          builder: (context) => NyLokasjon(),
        );
        break;
      case KartTilstand.Ankommet:
        Navigator.popUntil(context, ModalRoute.withName(KartSide.rute));
        bottomSheet(
          context: context,
          builder: (context) => FremmeVedLokasjon(),
        );
        break;
      case KartTilstand.PaVei:
        break;
      case KartTilstand.LokasjonFerdig:
        bottomSheet(
          context: context,
          builder: (context) => FerdigMedLokasjon(),
        );
        break;
      case KartTilstand.SpillFerdig:
        bottomSheet(
          context: context,
          builder: (context) => SpillFerdig(),
        );
        break;
    }
  }

  Future<void> bottomSheet({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
  }) {
    return showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: builder,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (visDialoger)
      return ProviderListener<StateController<KartTilstand>>(
        provider: kartTilstandProvider,
        onChange: visTilstandDialog,
        child: googleMaps,
      );
    return googleMaps;
  }
}
