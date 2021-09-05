import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loypa/data/model/Lokasjon.dart';

final lokasjonStreamProvider = StreamProvider<Position>((ref) {
  return Geolocator.getPositionStream();
});

final harLokasjonTillatelseProvider =
    StateNotifierProvider<LokasjonTillatelseController, LokasjonModel>(
  (ref) => LokasjonTillatelseController(),
);

class LokasjonTillatelseController extends StateNotifier<LokasjonModel> {
  LokasjonTillatelseController()
      : super(LokasjonModel(LokasjonTilstand.Venter)) {
    _sporrTillatelse();
  }

  Future sporIgjen() async => await _sporrTillatelse();

  Future _sporrTillatelse() async {
    LocationPermission permission;

    // Test if location services are enabled.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      state = LokasjonModel(LokasjonTilstand.IkkeTilgang);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        state = LokasjonModel(LokasjonTilstand.Avvist);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      state = LokasjonModel(LokasjonTilstand.AvvistForaltid);
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    state = LokasjonModel(LokasjonTilstand.Tillatelse);
    return;
  }
}
