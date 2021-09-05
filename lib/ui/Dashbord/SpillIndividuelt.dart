import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Loype.dart';
import 'package:loypa/data/provider/loypeProvider.dart';
import 'package:loypa/data/provider/loyperProvider.dart';
import 'package:loypa/ui/Dashbord/LoypeLedertavle.dart';
import 'package:loypa/ui/OpprettSpill/VelgBrukernavnSingle.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/LasterIndikator.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/utils/tid_formattering.dart';
import 'package:styled_widget/styled_widget.dart';

class Loyper extends StatelessWidget {
  const Loyper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Løyper',
            style: Theme.of(context)
                .textTheme
                .headline1
                ?.copyWith(color: Theme.of(context).errorColor),
          ).padding(top: 20, horizontal: 20),
          const SizedBox(height: 20),
          Consumer(
            builder: (context, watch, _) {
              final loyper = watch(loyperStreamProvider);
              return loyper.when(
                data: (data) => Column(
                  children: data.map((e) => LoypeCard(e)).toList(),
                ),
                loading: () {
                  return LasterIndikator(beskrivelse: 'Laster løyper').center();
                },
                error: (_, __) {
                  return Text(
                    'Feilet med å laste inn løyper',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  );
                },
              );
            },
          ).padding(horizontal: 20),
        ],
      ).scrollable(),
    );
  }
}

class LoypeCard extends StatelessWidget {
  const LoypeCard(
    this.loype, {
    Key? key,
  }) : super(key: key);

  final LoypeInfoModel loype;

  Future<void> startSpill(BuildContext context) async {
    context.read(loypeIdProvider).state = loype.id;
    Navigator.pushNamed(context, VelgBrukernavnSingle.rute);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Styled.builder(
          builder: (context, child) {
            return child.ripple().decorated(
                  border: Border.all(
                    width: 3,
                    color: Theme.of(context).errorColor,
                  ),
                  borderRadius: BorderRadius.circular(20),
                );
          },
          child: SColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            separator: const SizedBox(height: 5),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loype.navn,
                    // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'ca. ' + formaterTid(loype.estimertTid),
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              Text(
                'Løypen starter ved ${loype.startlokasjon}.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ).padding(top: 15, horizontal: 20, bottom: 40),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            $Button(
              onPressed: () => startSpill(context),
              text: 'Start',
            ).constrained(width: 150),
            const SizedBox(width: 5),
            Icon(Icons.leaderboard_outlined, color: Colors.white)
                .padding(vertical: 10, horizontal: 15)
                .ripple()
                .decorated(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(10),
                )
                .gestures(onTap: () {
              Navigator.pushNamed(
                context,
                LoypeLedertavle.rute,
                arguments: loype.id,
              );
            }).constrained(height: 50),
          ],
        ).translate(offset: Offset(0, -27.5)),
      ],
    );
  }
}
