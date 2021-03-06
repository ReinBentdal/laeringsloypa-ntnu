import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loypa/control/loypeControl.dart';
import 'package:loypa/data/model/Gruppe.dart';
import 'package:loypa/control/provider/gruppeProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/ui/Dashbord/DashbordSide.dart';
import 'package:loypa/ui/OpprettSpill/GruppespillInfo.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/LasterIndikator.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:styled_widget/styled_widget.dart';

class Lobby extends StatelessWidget {
  static const String rute = 'Lobby';
  const Lobby({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final gruppeId = context.read(gruppeIdProvider).state;
        return await LoypeControl.forlat(context, gruppeId!);
      },
      child: ProviderListener(
        provider: gruppeStreamProvider,
        onChange: (context, AsyncValue<GruppeModel> data) {
          data.whenData((gruppe) {
            if (gruppe.status == GruppeStatus.Startet) {
              Navigator.popUntil(
                  context, ModalRoute.withName(DashbordSide.rute));
              Navigator.pushNamed(context, GruppespillInfo.rute);
            }
          });
        },
        child: Scaffold(
          body: SafeArea(
            child: SColumn(
              mainAxisSize: MainAxisSize.min,
              separator: const SizedBox(height: 20),
              children: [
                SubpageAppBar(
                  title: 'Gruppespill',
                  titleColor: Theme.of(context).primaryColor,
                ).padding(top: 40),
                const SizedBox(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer(builder: (context, watch, _) {
                      final gruppe = watch(gruppeStreamProvider);
                      final deltakere = watch(gruppeDeltakereProvider);
                      return gruppe.when(
                        data: (data) {
                          return Column(
                            children: [
                              Text(
                                data.gruppenavn,
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'PIN for ?? bli med',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                data.pin,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              const SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Deltakere',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  const SizedBox(height: 10),
                                  deltakere.when(
                                    data: (data) {
                                      return SColumn(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        separator:
                                            Row(children: [SizedBox(height: 1)])
                                                .decorated(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      width: 1,
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                  ),
                                                )
                                                .padding(vertical: 5),
                                        children: data.map(
                                          (deltaker) {
                                            final lokalBruker = deltaker.id ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid;
                                            return Text(deltaker.navn,
                                                style: TextStyle(
                                                  fontWeight: lokalBruker
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                ));
                                          },
                                        ).toList(),
                                      ).padding(horizontal: 5);
                                    },
                                    loading: () => LasterIndikator(
                                        beskrivelse: 'Laster deltakere'),
                                    error: (_, __) => Text(
                                        'Feilet med ?? laste inn deltakerene'),
                                  ),
                                ],
                              )
                                  .padding(all: 15)
                                  .width(1000)
                                  .decorated(
                                    border: Border.all(
                                      color: Theme.of(context).accentColor,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  )
                                  .padding(horizontal: 40),
                            ],
                          );
                        },
                        loading: () =>
                            LasterIndikator(beskrivelse: 'Laster gruppe'),
                        error: (_, __) {
                          Navigator.maybePop(context);
                          return Text('Feilet med ?? laste inn gruppe');
                        },
                      );
                    }),
                    const SizedBox(height: 20),
                    JumpingDotsProgressIndicator(
                      fontSize: 36,
                    ),
                    Text(
                      'Venter p?? at spillet starter..',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 40),
                    $Button(
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                      color: Theme.of(context).errorColor,
                      text: 'Forlat gruppe',
                    ),
                  ],
                )
              ],
            ),
          ).scrollable(),
        ),
      ),
    );
  }
}
