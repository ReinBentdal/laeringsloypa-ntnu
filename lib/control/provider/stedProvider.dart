import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Person.dart';
import 'package:loypa/data/model/Sted.dart';
import 'gruppeProvider.dart';
import 'loypeProvider.dart';
import 'loypeStateProvider.dart';

/* infers current place from finished places */
final stedIndexProvider = Provider<int>((ref) {
  final gruppeId = ref.watch(gruppeIdProvider).state;
  assert(gruppeId != null);
  final loypeState = ref.watch(loypeStateProvider(gruppeId!));

  final steder = ref.watch(valgtLoypeProvider).data?.value?.steder;

  if (steder == null) {
    return 0;
  }

  /* count the number of finished places and set current place accordingly */
  int fullfortCount = 0;
  for (int i = 0; i < steder.length; i++) {
    if (loypeState.steder[steder[i].id]?.fullfort ?? false) {
      fullfortCount++;
    } else {
      break;
    }
  }
  return fullfortCount;
});

final valgtStedProvider = Provider<StedsModel>((ref) {
  final valgtStedIndex = ref.watch(stedIndexProvider);
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
  final stedState = ref.watch(stedStateProvider);

  return !stedState.personer.values.any((person) {

    print(person.oppgaveLost);

    return !person.oppgaveLost;
  });
});