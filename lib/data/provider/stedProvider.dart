import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Person.dart';
import 'package:loypa/data/model/Sted.dart';
import 'package:loypa/data/provider/loypeProvider.dart';
import 'package:loypa/data/provider/oppgaveProvider.dart';

final stedIndexProvider = StateProvider<int>((ref) {
  ref.watch(valgtLoypeProvider);

  return 0;
});

final valgtStedProvider = Provider<StedsModel>((ref) {
  final valgtStedIndex = ref.watch(stedIndexProvider).state;
  final loypeData = ref.watch(valgtLoypeProvider);

  return loypeData.data!.value!.steder[valgtStedIndex];
});

final valgtPersonIndexProvider = StateProvider<int>((ref) {
  ref.watch(valgtStedProvider);

  return 0;
});

final valgtPersonProvider = Provider<PersonModel>((ref) {
  final stedsdata = ref.watch(valgtStedProvider);
  final personIndex = ref.watch(valgtPersonIndexProvider).state;
  return stedsdata.personer[personIndex];
});

final alleOppgaverLostProvider = Provider<bool>((ref) {
  final valgtSted = ref.watch(valgtStedProvider);

  // ser om alle oppgaver er løst etter at en oppgave er løst
  ref.watch(valgtOppgaveProvider);
  final ferdig = !valgtSted.personer.any((e) => !e.oppgave.oppgaveLost);
  return ferdig;
});

final personSamtaleLestProvider = StateProvider.family<bool, int>((ref, index) {
  ref.watch(stedIndexProvider);
  return false;
});
