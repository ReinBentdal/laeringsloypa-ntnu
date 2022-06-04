import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loypa/control/provider/loypeProvider.dart';
import 'package:loypa/main.dart';
import 'package:loypa/ui/Dashbord/DashbordSide.dart';
import 'package:loypa/ui/Kart/KartSide.dart';
import 'package:loypa/ui/widgets/atom/varslinger.dart';
import 'package:loypa/ui/widgets/atom/LasterIndikator.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:path/path.dart' as p;

enum Lasterstatus { Data, Innhold, Feilmelding }

class LoypeLaster extends StatefulWidget {
  static const rute = 'velkommen';
  const LoypeLaster({Key? key}) : super(key: key);

  @override
  _LoypeLasterState createState() => _LoypeLasterState();
}

class _LoypeLasterState extends State<LoypeLaster> {
  Lasterstatus lasterstatus = Lasterstatus.Data;
  int startetNedlastninger = 0;
  int avsluttetNedlastninger = 0;
  final lasterReferanse = GlobalKey();
  double? lasterBredde;

  Future<void> visFeilmelding(BuildContext context) {
    return varslingFeilmelding(
      context,
      tittel: 'Feil under lasting',
      beskrivelse: 'Feilet med å laste inn løypen.',
    );
  }

  Future<void> precache(String url) async {
    final storage = await FirebaseStorage.instance.ref(url).listAll();

    // laste inn bilder i mappen
    await Future.wait(
      storage.items.map(
        (e) async {
          setState(() {
            this.startetNedlastninger++;
          });
          final path = await e.getDownloadURL();
          final filtype = p.extension(path);
          if (filtype.substring(0, 4) == '.svg') {
            await precachePicture(
                NetworkPicture(SvgPicture.svgByteDecoder, path), context);
          } else {
            await precacheImage(NetworkImage(path), context);
          }
          setState(() {
            this.avsluttetNedlastninger++;
          });
        },
      ),
    );

    // laste inn filer i undermapper
    await Future.wait(
      storage.prefixes.map(
        (e) async {
          await this.precache(url + e.name + '/');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    () async {
      try {
        final loypeId = context.read(loypeIdProvider).state;
        await context.read(valgtLoypeProvider.future);
        setState(() {
          lasterstatus = Lasterstatus.Innhold;
        });
        try {
          await this.precache(loypeId.toString() + '/');
        } catch (error) {
          // ikke en nødvendighet å cache all grafikk, fortsette som vanlig
          print('FEILET MED Å LASTE INN ALL GRAFIKK');
        }
        Navigator.popAndPushNamed(navigatorKey.currentContext ?? context, KartSide.rute);
      } catch (error, stack) {
        // feilet med å laste inn løype
        print("feilet med å laste inn løypen");
        print(error);
        print(stack);
        Navigator.popUntil(context, ModalRoute.withName(DashbordSide.rute));
        visFeilmelding(context);
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    if (lasterBredde == null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        setState(() {
          this.lasterBredde = lasterReferanse.currentContext?.size?.width;
        });
      });
    }

    if (this.lasterstatus == Lasterstatus.Feilmelding) {
      return Text('Feilmelding');
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: lasterstatus == Lasterstatus.Data
          ? LasterIndikator(beskrivelse: 'Laster inn løype').center()
          : SColumn(
              separator: const SizedBox(height: 20),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LasterIndikator(
                  beskrivelse: 'Laster inn grafikk',
                ).center(),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    SizedBox()
                        .decorated(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        )
                        .constrained(
                          height: 30,
                          width: double.infinity,
                          key: lasterReferanse,
                        ),
                    SizedBox()
                        .decorated(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        )
                        .constrained(
                          height: 30,
                          width: startetNedlastninger < 5
                              ? 0
                              : (avsluttetNedlastninger /
                                      startetNedlastninger) *
                                  (lasterBredde ?? 0),
                          animate: true,
                        )
                        .animate(Duration(milliseconds: 300), Curves.easeOut),
                  ],
                ).padding(horizontal: 30)
              ],
            ),
    );
  }
}
