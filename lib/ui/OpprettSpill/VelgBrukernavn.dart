import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/config/theme/inputDecoration.dart';
import 'package:loypa/data/provider/gruppeProvider.dart';
import 'package:loypa/data/provider/loypeProvider.dart';
import 'package:loypa/ui/OpprettSpill/Lobby.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/varslinger.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:styled_widget/styled_widget.dart';

final brukernavnFeltProvider = StateProvider<String>((ref) => '');

class VelgBrukernavn extends StatelessWidget {
  static const String rute = 'Velg brukernavn';
  const VelgBrukernavn({Key? key}) : super(key: key);

  void velgBrukernavn(BuildContext context) async {
    final brukernavn = context.read(brukernavnFeltProvider).state.trim();

    if (brukernavn == '') {
      return varslingFeilmelding(
        context,
        tittel: 'Brukernavn ikke valgt',
        beskrivelse: 'Du må skrive inn et brukernavn for å fortsette',
      );
    }

    final gruppeid = context.read(gruppeIdProvider).state;

    final brukerId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('grupper')
        .doc(gruppeid)
        .collection('deltakere')
        .doc(brukerId)
        .set({
      'brukernavn': brukernavn,
    });

    Navigator.popAndPushNamed(context, Lobby.rute);
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
              TextField(
                decoration: inputDecoration(context, 'Velg et brukernavn..'),
                onChanged: (value) =>
                    context.read(brukernavnFeltProvider).state = value,
              ).constrained(maxWidth: 300),
              $Button(onPressed: () => velgBrukernavn(context), text: 'Velg'),
            ],
          ).center().padding(top: 40),
        ).scrollable(),
      ),
    );
  }
}
