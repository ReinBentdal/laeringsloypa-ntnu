import 'package:flutter/material.dart';
import 'package:loypa/data/provider/stedProvider.dart';
import 'package:loypa/data/provider/kartProvider.dart';
import 'package:loypa/ui/widgets/atom/BottomSheet.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NyLokasjon extends StatelessWidget {
  const NyLokasjon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return $BottomSheet(
      child: SColumn(
        mainAxisSize: MainAxisSize.min,
        separator: const SizedBox(height: 10),
        children: [
          Text(
            'Du skal nå gå til',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ).textColor(Colors.black),
          Text(
            context.read(valgtStedProvider).stedsnavn,
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
          Text(
            'Gå til området vist på kartet for å begynne på oppgavene ved denne lokasjonen.',
            style: TextStyle(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          $Button(
            text: 'Lukk',
            onPressed: () {
              Navigator.pop(context);
              context.read(kartTilstandProvider).state = KartTilstand.PaVei;
            },
          )
        ],
      ),
    );
  }
}
