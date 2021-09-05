import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Oppgave.dart';
import 'package:loypa/data/model/PersonHint.dart';
import 'package:loypa/data/provider/hintProvider.dart';
import 'package:loypa/data/provider/stedProvider.dart';

final valgtOppgaveProvider =
    StateNotifierProvider<OppgaveNotifier, OppgaveModel>((ref) {
  final valgtSted = ref.watch(valgtStedProvider);
  final valgtPerson = ref.watch(valgtPersonIndexProvider).state;

  return OppgaveNotifier(valgtSted.personer[valgtPerson].oppgave);
});

class OppgaveNotifier extends StateNotifier<OppgaveModel> {
  OppgaveNotifier(OppgaveModel state) : super(state);

  void setOppgaveLost() => state = (state..oppgaveLost = true);
}

final oppgaveHintProvider =
    StateNotifierProvider<OppgaveHintController, List<OppgaveHintModel>>((ref) {
  final oppgavehint = ref.watch(nestePersonProvider).oppgave.hint;

  return OppgaveHintController(oppgavehint);
});

class OppgaveHintController extends StateNotifier<List<OppgaveHintModel>> {
  OppgaveHintController(List<OppgaveHintModel> state) : super(state);

  void setOppgaveHintApnet(int i) {
    state = (state..elementAt(i).brukt = true);
  }
}

final alleHintBruktProvider = Provider.autoDispose<bool>((ref) {
  return !ref.watch(oppgaveHintProvider).any((hint) {
    return !hint.brukt;
  });
});
