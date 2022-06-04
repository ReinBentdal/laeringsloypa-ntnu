import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Oppgave.dart';
import 'package:loypa/data/model/OppgaveHint.dart';
import 'hintProvider.dart';
import 'stedProvider.dart';

final valgtOppgaveProvider = Provider<OppgaveModel>((ref) {
  final valgtSted = ref.watch(valgtStedProvider);
  final valgtPerson = ref.watch(valgtPersonIndexProvider).state;

  return valgtSted.personer[valgtPerson].oppgave;
});

final oppgaveHintProvider = Provider<List<OppgaveHintModel>>((ref) {
  return ref.watch(nestePersonProvider).oppgave.hint;
});