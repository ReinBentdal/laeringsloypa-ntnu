import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Ryggsekk.dart';
import 'gruppeProvider.dart';
import 'loypeProvider.dart';
import 'loypeStateProvider.dart';

final ryggsekkGjenstandProvider = Provider.family<RyggsekkGjenstandModel, int>((ref, index) {
  return ref.watch(ryggsekkInnholdProvider).elementAt(index);
});

final ryggsekkInnholdProvider = Provider<List<RyggsekkGjenstandModel>>((ref) {
  final startinnhold = ref.read(valgtLoypeProvider).data!.value!.ryggsekkStartinnhold;
  final gruppeId = ref.watch(gruppeIdProvider).state;
  assert(gruppeId != null);
  final loypeState = ref.watch(loypeStateProvider(gruppeId!));
  final loypeData = ref.watch(valgtLoypeProvider).data?.value;

  assert(loypeData != null);
  final steder = loypeData!.steder;

  List<RyggsekkGjenstandModel> gjenstander = [];
  gjenstander.addAll(startinnhold);

  /* loop through each completed person and find coresponding gjenstander */
  loypeState.steder.forEach((stedId, stedState) {
    stedState.personer.forEach((personId, personState) {
      if (personState.oppgaveLost) {
        /* finn oppgaven til denne personen */
        for (int i = 0; i < steder.length; i++) {
          if (steder[i].id == stedId) {
            final personer = steder[i].personer;
            for (int j = 0; j < personer.length; j++) {
              if (personer[j].id == personId) {
                final belonninger = personer[j].oppgave.belonning;
                if (belonninger != null) {
                  gjenstander.addAll(belonninger);
                }
                break;
              }
            }
            break;
          }
        }
      }
    });
  });

  return gjenstander;
});

final ryggsekkHasNewProvider = Provider<bool>((ref) {
  final gruppeId = ref.watch(gruppeIdProvider).state;
  assert(gruppeId != null);
  final loypeState = ref.watch(loypeStateProvider(gruppeId!));
  final ryggsekk = loypeState.ryggsekkgjenstanderSett.values.toList();

  bool nyeGjenstander = false;
  for (int i = 0; i < ryggsekk.length; i++) {
    if (ryggsekk[i] == false) {
      nyeGjenstander = true;
      break;
    }
  }

  return nyeGjenstander;
});
