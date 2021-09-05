import 'package:flutter/material.dart';
import 'package:loypa/data/model/Gruppe.dart';
import 'package:loypa/data/provider/gruppeProvider.dart';
import 'package:loypa/data/provider/loypeProvider.dart';
import 'package:loypa/ui/OpprettSpill/VelgBrukernavn.dart';
import 'package:loypa/ui/widgets/atom/varslinger.dart';
import 'package:loypa/ui/widgets/atom/LasterIndikator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';

class VerifiserPin extends StatelessWidget {
  static const rute = 'Verifiser pin';
  const VerifiserPin({Key? key}) : super(key: key);

  Future<void> visVerifiseringFeilmelding(BuildContext context) {
    return varslingFeilmelding(
      context,
      tittel: 'Feilmelding',
      beskrivelse: 'Feilet med å verifisere PIN-koden',
    );
  }

  Future<void> feilPinDialog(BuildContext context) {
    return varslingFeilmelding(
      context,
      tittel: 'Feil PIN',
      beskrivelse: 'Pinkoden oppgitt stemmer ikke med en aktiv gruppe.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      child: Scaffold(
        body: LasterIndikator(beskrivelse: 'Verifiserer pin').center(),
      ),
      provider: grupperProvider(context.read(gruppepinVerdiProvider).state),
      onChange: (context, AsyncValue<List<GruppeModel>> provider) async {
        await Future.delayed(Duration(milliseconds: 400));
        provider.when(
          loading: () => null,
          data: (data) {
            if (data.length == 0) {
              Navigator.pop(context);
              feilPinDialog(context);
            } else if (data.length > 1) {
              context.read(gruppepinVerdiProvider).state = '';
              Navigator.pop(context);
              visVerifiseringFeilmelding(context);
            } else {
              context.read(gruppeIdProvider).state = data.first.docId;
              context.read(loypeIdProvider).state = data.first.loypeId;
              Navigator.popAndPushNamed(context, VelgBrukernavn.rute);
            }
          },
          error: (err, __) {
            context.read(gruppepinVerdiProvider).state = '';
            Navigator.pop(context);
            visVerifiseringFeilmelding(context);
          },
        );
      },
    );
  }
}
