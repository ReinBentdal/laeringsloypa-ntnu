import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loypa/data/provider/stedProvider.dart';
import 'package:loypa/data/provider/kartProvider.dart';
import 'package:loypa/data/provider/timerProvider.dart';
import 'package:loypa/ui/Kart/KartShowcase.dart';
import 'package:loypa/ui/widgets/atom/HjelpIkon.dart';
import 'package:loypa/ui/widgets/atom/LasterIndikator.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/utils/tid_formattering.dart';
import 'package:styled_widget/styled_widget.dart';

class GoogleMaps extends StatefulWidget {
  GoogleMaps({
    Key? key,
  }) : super(key: key);

  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  bool visKart = false;
  double _zoom = 16;
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        visKart = true;
      });
    });
  }

  LatLng polygonCenter(List<LatLng> points) {
    double lat = 0;
    double long = 0;
    points.forEach((p) {
      lat += p.latitude;
      long += p.longitude;
    });
    return LatLng(lat / points.length, long / points.length);
  }

  void nyLokasjon(BuildContext context, bool ankommet) {
    final kartTilstand = context.read(kartTilstandProvider);
    if (ankommet == false && kartTilstand.state == KartTilstand.Ankommet) {
      context.read(kartTilstandProvider).state = KartTilstand.PaVei;
      Navigator.pop(context);
    } else if (ankommet && kartTilstand.state != KartTilstand.Ankommet)
      context.read(kartTilstandProvider).state = KartTilstand.Ankommet;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer(
          builder: (context, watch, _) {
            final markering = watch(valgtStedProvider).kartmarkering;
            final LatLng plasseringSenter = polygonCenter(markering);
            _controller?.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(plasseringSenter.latitude - 0.0007,
                  plasseringSenter.longitude),
              16,
            ));
            return ProviderListener<StateController<KartTilstand>>(
              provider: kartTilstandProvider,
              onChange: (context, tilstand) {
                if (tilstand.state == KartTilstand.PaVei) {
                  _controller?.animateCamera(CameraUpdate.zoomTo(15));
                }
              },
              child: ProviderListener(
                provider: ankommetLokasjonProvider(markering),
                onChange: this.nyLokasjon,
                child: visKart
                    ? GoogleMap(
                        buildingsEnabled: true,
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: plasseringSenter,
                          zoom: _zoom,
                        ),
                        myLocationButtonEnabled: false,
                        myLocationEnabled: true,
                        onMapCreated: (controller) async {
                          String value = await DefaultAssetBundle.of(context)
                              .loadString('lib/config/theme/kart.json');
                          controller.setMapStyle(value);
                          _controller = controller;
                          final kartTilstand =
                              context.read(kartTilstandProvider);
                          if (kartTilstand.state == KartTilstand.NyLokasjon)
                            context.read(kartTilstandProvider).state =
                                KartTilstand.NyLokasjon;
                        },
                        polygons: {
                          Polygon(
                            fillColor: Colors.red.shade400.withOpacity(0.2),
                            strokeWidth: 4,
                            strokeColor: Colors.orange.shade700,
                            points: markering,
                            polygonId: PolygonId('Ravnkloa'),
                            consumeTapEvents: true,
                          ),
                        },
                      )
                    : LasterIndikator(beskrivelse: 'Laster kart')
                        .center()
                        .decorated(color: Colors.white),
              ),
            );
          },
        ),
        SColumn(
          separator: const SizedBox(height: 10),
          children: [
            Icon(
              Icons.my_location_outlined,
              // color: Theme.of(context).primaryColor,
              color: Colors.white,
            )
                .padding(all: 15)
                .ripple()
                .clipRRect(all: 10)
                .card(
                  color: Theme.of(context).primaryColor,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                )
                .gestures(
                  key: dinLokasjonRef,
                  onTap: () async {
                    final posisjon = await Geolocator.getCurrentPosition();
                    _controller?.animateCamera(
                      CameraUpdate.newLatLng(
                        LatLng(
                          posisjon.latitude,
                          posisjon.longitude,
                        ),
                      ),
                    );
                  },
                ),
            Icon(
              Icons.place_outlined,
              color: Colors.white,
            )
                .padding(all: 15)
                .ripple()
                .clipRRect(all: 10)
                .card(
                  color: Theme.of(context).accentColor,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                )
                .gestures(
                  key: nesteLokasjonRef,
                  onTap: () {
                    final markering =
                        context.read(valgtStedProvider).kartmarkering;
                    final LatLng plasseringSenter = polygonCenter(markering);
                    _controller?.animateCamera(CameraUpdate.newLatLng(
                      LatLng(plasseringSenter.latitude,
                          plasseringSenter.longitude),
                    ));
                  },
                ),
          ],
        ).positioned(
            bottom: 15 + MediaQuery.of(context).padding.bottom, right: 15),
        Row(
          children: [
            const SizedBox(width: 50),
            SColumn(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Du er på vei til', style: TextStyle(color: Colors.white)),
                Consumer(builder: (context, watch, _) {
                  return Text(
                    watch(valgtStedProvider).stedsnavn,
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Colors.white,
                          height: 1.2,
                        ),
                    textAlign: TextAlign.center,
                  );
                }),
                Consumer(builder: (context, watch, _) {
                  final tid = Duration(seconds: watch(timerProvider));
                  return Text(
                    'Total tid brukt: ${formaterTid(tid, format: TidFormat.Digital)}',
                    key: tidsbrukRef,
                    style: TextStyle(color: Colors.white),
                  );
                })
              ],
            ).expanded(),
            HjelpIkon(
              color: Colors.white,
            )
          ],
        )
            .padding(all: 15)
            .constrained(width: double.infinity)
            .decorated(
              color: Color(0xFF651015),
              borderRadius: BorderRadius.circular(20),
            )
            .padding(
                horizontal: 20, top: 20 + MediaQuery.of(context).padding.top)
            .alignment(Alignment.topCenter),
        if (kDebugMode)
          Icon(
            Icons.redo_outlined,
            color: Colors.white,
          )
              .padding(all: 15)
              .ripple()
              .clipRRect(all: 10)
              .card(
                color: Theme.of(context).errorColor,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              )
              .gestures(
            onTap: () {
              context.read(kartTilstandProvider).state = KartTilstand.Ankommet;
            },
          ).positioned(
                  left: 15, bottom: MediaQuery.of(context).padding.bottom + 15),
      ],
    );
  }
}
