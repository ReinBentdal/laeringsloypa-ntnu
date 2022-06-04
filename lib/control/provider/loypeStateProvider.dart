import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/LoypeState.dart';
import 'package:loypa/data/model/Ryggsekk.dart';
import 'loypeProvider.dart';
import 'stedProvider.dart';
import 'package:loypa/data/storage/loype_local_storage.dart';

import 'gruppeProvider.dart';

final loypeStateProvider = StateNotifierProvider.family<LoypeStateController, LoypeStateModel, String>((ref, gruppeId) {
  /* assumes provider only accesed within a game and thus the id is not null */
  
  print("løype state refresh med gruppe id $gruppeId");
  
  final loypeId = ref.watch(loypeIdProvider).state;
  assert(loypeId != null);

  final localState = LoypeLocalStorage.getRoute(loypeId: loypeId!);

  /* retrieve state from local storage or generated from route data */
  if (localState != null && localState.gruppeId == gruppeId) {
    print("fortsetter lokal state");
    // TODO: merge with current route data in the case the route has changed
    return LoypeStateController(localState);
  } else {
    print("lager ny lokal state");
    final valgtLoype = ref.read(valgtLoypeProvider).data?.value;
    assert(valgtLoype != null);
    final loypeState = LoypeStateModel.fromLoypeModel(gruppeId, valgtLoype!);
    LoypeLocalStorage.newRoute(loypeState);
    return LoypeStateController(loypeState);
  }
});

final stedStateProvider = Provider<StedStateModel>((ref) {
  final gruppeId = ref.watch(gruppeIdProvider).state;
  assert(gruppeId != null);
  final loypeState = ref.watch(loypeStateProvider(gruppeId!));

  final stedId = ref.watch(valgtStedProvider).id;

  assert(loypeState.steder.containsKey(stedId));

  return loypeState.steder[stedId]!;
});

final personStateProvider = Provider<PersonStateModel>((ref) {
  final stedState = ref.watch(stedStateProvider);
  final valgtPerson = ref.watch(valgtPersonProvider);

  assert(stedState.personer.containsKey(valgtPerson.id));

  return stedState.personer[valgtPerson.id]!;
});

class LoypeStateController extends StateNotifier<LoypeStateModel> {
  LoypeStateController(LoypeStateModel state) : super(state) {
    _oppdaterLocalLoype();
  }

  void _oppdaterLocalLoype() {
    print("oppdaterer lokal løype");
    LoypeLocalStorage.updateRoute(loype: state);
  }

  void _oppdaterValgtSted(BuildContext context, {bool? fullfort, Map<String, PersonStateModel>? personer}) {
    final stedState = context.read(stedStateProvider);
    final valgtSted = context.read(valgtStedProvider);

    state = state.copyWith(
      gyldig: state.gyldig,
      ryggsekkgjenstanderSett: state.ryggsekkgjenstanderSett,
      steder: {
        valgtSted.id: stedState.copyWith(
          fullfort: fullfort,
          personer: personer,
        )
      },
    );
  }

  void _oppdaterValgtPerosn(BuildContext context, {bool? oppgaveLost, bool? samtaleLest, List<bool>? hintBrukt}) {
    final stedState = context.read(stedStateProvider);
    final valgtSted = context.read(valgtStedProvider);

    final personState = context.read(personStateProvider);
    final valgtPerson = context.read(valgtPersonProvider);

    state = state.copyWith(steder: {
      valgtSted.id: stedState.copyWith(personer: {
        valgtPerson.id: personState.copyWith(
          oppgaveLost: oppgaveLost,
          samtaleLest: samtaleLest,
          hintBrukt: hintBrukt,
        )
      })
    });
  }

  void _leggTilRyggsekkgjenstand(BuildContext context, RyggsekkGjenstandModel gjenstand) {
    print("Legger til gjenstand i ryggsekk");
    final oppdatertGjenstander =  Map<String, bool>.from(state.ryggsekkgjenstanderSett)..addAll({gjenstand.id: false});
    state = state.copyWith(
      ryggsekkgjenstanderSett: oppdatertGjenstander,
    );

    _oppdaterLocalLoype();
  }

  void settOppgavenLost(BuildContext context) {

    /* legg til person gjenstader i ryggsekk */
    final gjenstander = context.read(valgtPersonProvider).oppgave.belonning;
    gjenstander?.forEach((gjenstand) {
      _leggTilRyggsekkgjenstand(context, gjenstand);
    });

    _oppdaterValgtPerosn(context, oppgaveLost: true);

    _oppdaterLocalLoype();
  }

  void settSamtalenLest(BuildContext context) {
    _oppdaterValgtPerosn(context, samtaleLest: true);
    _oppdaterLocalLoype();
  }

  void settHintBrukt(BuildContext context, int index) {
    final personState = context.read(personStateProvider);

    final hint = List<bool>.from(personState.hintBrukt);
    assert(index < hint.length);
    hint[index] = true;

    _oppdaterValgtPerosn(context, hintBrukt: hint);
    _oppdaterLocalLoype();
  }

  void settStedFullfort(BuildContext context) {
    _oppdaterValgtSted(context, fullfort: true);
    // context.read(stedIndexProvider).state++;
    _oppdaterLocalLoype();
  }

  void settLoypeUgyldig(BuildContext context) {
    /* oppdater database status */
    final gruppeId = context.read(gruppeIdProvider).state;
    FirebaseFirestore.instance.collection('grupper').doc(gruppeId).update({
      'gyldig': false,
    });

    state = state.copyWith(gyldig: false);

    _oppdaterLocalLoype();
  }

  void settRyggsekkgjenstandSett(BuildContext context, String id) {
    final ryggsekk = Map<String, bool>.from(state.ryggsekkgjenstanderSett);
    assert(ryggsekk.containsKey(id));
    ryggsekk.update(id, (value) => true);

    state = state
      .copyWith(
        ryggsekkgjenstanderSett: ryggsekk,
      );

    _oppdaterLocalLoype();
  }
}
