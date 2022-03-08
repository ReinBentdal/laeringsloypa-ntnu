import 'package:flutter/material.dart';
import 'package:loypa/data/model/Loype.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/SRow.dart';
import 'package:loypa/utils/tid_formattering.dart';
import 'package:styled_widget/styled_widget.dart';

import 'LoypeLedertavle.dart';

class LoypeCard extends StatelessWidget {
  const LoypeCard(
    this.loype, {
    Key? key,
    required this.onVelg,
    this.visLedertavleKnapp = true,
  }) : super(key: key);

  final LoypeInfoModel loype;
  final bool visLedertavleKnapp;
  final void Function() onVelg;

  void visLedertavle(BuildContext context) {
    Navigator.pushNamed(
      context,
      LoypeLedertavle.rute,
      arguments: loype.id,
    );
  }

  Widget ledertavleButton(BuildContext context) {
    return Icon(Icons.leaderboard_outlined, color: Colors.white)
        .padding(vertical: 10, horizontal: 15)
        .ripple()
        .decorated(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10),
        )
        .gestures(onTap: () => visLedertavle(context))
        .constrained(height: 50);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          separator: const SizedBox(height: 5),
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Text(
                  loype.navn,
                  style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.w500),
                ).padding(right: 20),
                Text(
                  'ca. ' + formaterTid(loype.estimertTid),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ).padding(bottom: 3),
              ],
            ),
            Text(
              'Løypen starter ved ${loype.startlokasjon}.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ).alignment(Alignment.topLeft).padding(top: 15, horizontal: 20, bottom: 40).ripple().decorated(
              border: Border.all(
                width: 3,
                color: Theme.of(context).errorColor,
              ),
              borderRadius: BorderRadius.circular(20),
              color: loype.public ? Theme.of(context).backgroundColor : Color(0xffDCCC7C),
            ),
        SRow(
          mainAxisAlignment: MainAxisAlignment.center,
          separator: const SizedBox(width: 5),
          children: [
            $Button(
              onPressed: () => onVelg(),
              text: 'Velg',
            ).constrained(width: 150),
            if (visLedertavleKnapp) ledertavleButton(context),
          ],
        ).translate(offset: Offset(0, -27.5)),
      ],
    );
  }
}
