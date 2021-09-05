import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loypa/data/provider/stedProvider.dart';
import 'package:loypa/data/provider/lokasjonProvider.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mTool;

enum KartTilstand {
  NyLokasjon,
  Ankommet,
  PaVei,
  LokasjonFerdig,
  SpillFerdig,
}

final kartTilstandProvider = StateProvider<KartTilstand>((ref) {
  ref.watch(stedIndexProvider);

  return KartTilstand.NyLokasjon;
});

List<mTool.LatLng> latLngMToolConvert(List<LatLng> points) {
  return points
      .map((element) => mTool.LatLng(element.latitude, element.longitude))
      .toList();
}

final ankommetLokasjonProvider =
    Provider.autoDispose.family<bool, List<LatLng>>((ref, points) {
  ref.watch(kartTilstandProvider);
  final lokasjon = ref.watch(lokasjonStreamProvider);
  final mToolPoints = latLngMToolConvert(points);
  return mTool.PolygonUtil.containsLocation(
    mTool.LatLng(lokasjon.data?.value.latitude ?? 0,
        lokasjon.data?.value.longitude ?? 0),
    mToolPoints,
    false,
  );
});
