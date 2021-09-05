import 'package:flutter/material.dart';
import 'package:loypa/data/provider/stedProvider.dart';
import 'package:loypa/ui/widgets/atom/BottomSheet.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FerdigMedLokasjon extends StatelessWidget {
  const FerdigMedLokasjon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return $BottomSheet(
      child: SColumn(
        mainAxisSize: MainAxisSize.min,
        separator: const SizedBox(height: 20),
        children: [
          Text(
            'Gratulerer!',
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
          Text(
            'Du har nå fullført alle oppgavene ved ${context.read(valgtStedProvider).stedsnavn}.',
          ),
          $Button(
            text: 'Til neste lokasjon',
            onPressed: () {
              Navigator.pop(context);

              context.read(stedIndexProvider).state++;
            },
          )
        ],
      ),
    );
  }
}
