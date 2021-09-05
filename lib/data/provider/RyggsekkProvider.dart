import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Ryggsekk.dart';
import 'package:loypa/data/provider/loypeProvider.dart';

final ryggsekkGjenstandProvider =
    StateProvider.family<RyggsekkGjenstandModel, int>((ref, index) {
  return ref.watch(ryggsekkInnholdProvider).elementAt(index);
});

final ryggsekkInnholdProvider = StateNotifierProvider<RyggsekkInnholdNotifier,
    List<RyggsekkGjenstandModel>>((ref) {
  final startinnhold =
      ref.watch(valgtLoypeProvider).data!.value!.ryggsekkStartinnhold;

  return RyggsekkInnholdNotifier(
    ryggsekkStartinnhold: startinnhold,
  );
});

final ryggsekkHasNewProvider = StateProvider<bool>((ref) {
  return ref.watch(ryggsekkInnholdProvider).any((element) => !element.sett);
});

class RyggsekkInnholdNotifier
    extends StateNotifier<List<RyggsekkGjenstandModel>> {
  RyggsekkInnholdNotifier(
      {List<RyggsekkGjenstandModel> ryggsekkStartinnhold = const []})
      : super(ryggsekkStartinnhold);

  void leggTilGjenstander(
    BuildContext context,
    List<RyggsekkGjenstandModel> ryggsekkGjenstand,
  ) {
    state = [...state, ...ryggsekkGjenstand];
  }

  void gjenstandSett(int index) {
    state = (state..elementAt(index).sett = true);
  }
}
