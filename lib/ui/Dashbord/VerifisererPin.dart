import 'package:flutter/material.dart';
import 'package:loypa/control/loypeControl.dart';
import 'package:loypa/control/provider/gruppeProvider.dart';
import 'package:loypa/ui/OpprettSpill/VelgBrukernavnGruppe.dart';
import 'package:loypa/ui/widgets/atom/varslinger.dart';
import 'package:loypa/ui/widgets/atom/LasterIndikator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';

class VerifiserPin extends StatelessWidget {
  static const rute = 'Verifiser pin';
  const VerifiserPin({Key? key}) : super(key: key);

  Future<void> feilPinDialog(BuildContext context) {
    return varslingFeilmelding(
      context,
      tittel: 'Feil PIN',
      beskrivelse: 'Pinkoden oppgitt stemmer ikke med en aktiv gruppe.',
    );
  }

  Future<void> verifiserPin(BuildContext context) async {
    final pin = context.read(gruppepinVerdiProvider).state;
    
    final eksisterer = await LoypeControl.gruppePinEksisterer(context, pin);
  
    if (eksisterer) {
      Navigator.popAndPushNamed(context, VelgBrukernavnGruppe.rute);
    } else {
      Navigator.pop(context);
      feilPinDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    verifiserPin(context);
    return LasterIndikator(beskrivelse: 'Verifiserer pin').center();
  }
}
