import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/config/theme/inputDecoration.dart';
import 'package:loypa/data/provider/gruppeProvider.dart';
import 'package:loypa/data/provider/loypeProvider.dart';
import 'package:loypa/ui/Dashbord/LoypeLaster.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/varslinger.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:styled_widget/styled_widget.dart';

final brukernavnFeltProvider = StateProvider<String>((ref) => '');
final lasterProvider = StateProvider.autoDispose((ref) => false);

class VelgBrukernavnSingle extends StatelessWidget {
  static const String rute = 'Velg brukernavn single';
  const VelgBrukernavnSingle({Key? key}) : super(key: key);

  Future<void> velgBrukernavn(BuildContext context) async {
    final brukernavn = context.read(brukernavnFeltProvider).state.trim();

    if (brukernavn == '') {
      return await varslingFeilmelding(
        context,
        tittel: 'Ugyldig brukernavn',
        beskrivelse: 'Du må velge et brukernavn for å fortsette',
      );
    } else if (brukernavn.length > 20) {
      return await varslingFeilmelding(
        context,
        tittel: 'Ugyldig brukernavn',
        beskrivelse:
            'Lengden på brukernavnet kan ikke være mer enn 20 karakterer.',
      );
    }

    context.read(lasterProvider).state = true;

    final brukerId = FirebaseAuth.instance.currentUser!.uid;

    final docRef = await FirebaseFirestore.instance.collection('grupper').add({
      'gruppenavn': brukernavn,
      'løype_id': context.read(loypeIdProvider).state,
      'status': 'startet',
      'tidsstempel': DateTime.now(),
      'pin': '',
      'gyldig': true,
      'hint_brukt': 0,
    });
    final gruppeId = docRef.id;
    context.read(gruppeIdProvider).state = gruppeId;

    await FirebaseFirestore.instance
        .collection('grupper')
        .doc(gruppeId)
        .collection('deltakere')
        .doc(brukerId)
        .set({
      'brukernavn': brukernavn,
    });
    // Navigator.pushReplacementNamed(context, LoypeInfo.rute);
    Navigator.popAndPushNamed(context, LoypeLaster.rute);
    context.read(lasterProvider).state = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read(loypeIdProvider).state = null;
        context.read(gruppeIdProvider).state = null;
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SColumn(
            separator: const SizedBox(height: 20),
            children: [
              SubpageAppBar(
                title: 'Velg brukernavn',
                titleColor: Theme.of(context).primaryColor,
              ),
              const SizedBox(),
              Text('Når du har fullført løypen, vil tiden brukt publiseres på ledertavlen med det gitte brukernavnet. Velg derfor et passende brukernavn.')
                  .padding(horizontal: 20),
              TextField(
                decoration: inputDecoration(context, 'Velg et brukernavn..'),
                onChanged: (value) =>
                    context.read(brukernavnFeltProvider).state = value,
              ).constrained(maxWidth: 300),
              Consumer(builder: (context, watch, _) {
                return $Button(
                  onPressed: () => velgBrukernavn(context),
                  text: 'Velg',
                  laster: watch(lasterProvider).state,
                );
              }),
            ],
          ).center().padding(top: 40),
        ),
      ),
    );
  }
}
