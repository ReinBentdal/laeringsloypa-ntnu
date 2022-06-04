import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Person.dart';
import 'loypeStateProvider.dart';
import 'oppgaveProvider.dart';
import 'stedProvider.dart';

final nestePersonProvider = Provider<PersonModel>((ref) {
  final stedsdata = ref.watch(valgtStedProvider);
  final index = ref.watch(nestePersonIndexProvider);
  return stedsdata.personer.elementAt(index);
});


final nestePersonIndexProvider = Provider<int>((ref) {
  final valgtSted = ref.watch(valgtStedProvider);
  final stedState = ref.watch(stedStateProvider);
  ref.watch(valgtOppgaveProvider);

  int? lavestRekkefolge;
  int? lavestIndex;

  for (int i = 0; i < valgtSted.personer.length; i++) {
    final personState = stedState.personer[valgtSted.personer[i].id];
    assert(personState != null);
    bool oppgaveLost = personState!.oppgaveLost;
    if (oppgaveLost == false &&
        (lavestRekkefolge == null ||
            valgtSted.personer[i].oppgave.rekkefolge < lavestRekkefolge)) {
      lavestRekkefolge = valgtSted.personer[i].oppgave.rekkefolge;
      lavestIndex = i;
    }
  }

  return lavestIndex ?? 0;
});