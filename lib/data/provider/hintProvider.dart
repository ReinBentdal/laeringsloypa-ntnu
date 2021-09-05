import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Person.dart';
import 'package:loypa/data/provider/oppgaveProvider.dart';
import 'package:loypa/data/provider/stedProvider.dart';

final nestePersonProvider = Provider<PersonModel>((ref) {
  final stedsdata = ref.watch(valgtStedProvider);
  final index = ref.watch(nestePersonIndexProvider);
  return stedsdata.personer.elementAt(index);
});

final nestePersonIndexProvider = Provider<int>((ref) {
  final stedsdata = ref.watch(valgtStedProvider);
  ref.watch(valgtOppgaveProvider);

  int? lavestRekkefolge;
  int? lavestIndex;

  for (int i = 0; i < stedsdata.personer.length; i++) {
    if (stedsdata.personer[i].oppgave.oppgaveLost == false &&
        (lavestRekkefolge == null ||
            stedsdata.personer[i].oppgave.rekkefolge < lavestRekkefolge)) {
      lavestRekkefolge = stedsdata.personer[i].oppgave.rekkefolge;
      lavestIndex = i;
    }
  }

  return lavestIndex ?? 0;
});
