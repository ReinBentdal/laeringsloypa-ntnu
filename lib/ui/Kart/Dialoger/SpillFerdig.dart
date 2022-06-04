import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/control/provider/gruppeProvider.dart';
import 'package:loypa/control/provider/loypeStateProvider.dart';
import 'package:loypa/ui/Dashbord/AvsluttLoype.dart';
import 'package:loypa/ui/widgets/atom/BottomSheet.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';

class SpillFerdig extends StatelessWidget {
  const SpillFerdig({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return $BottomSheet(
      child: SColumn(
        mainAxisSize: MainAxisSize.min,
        separator: const SizedBox(height: 10),
        children: [
          Text(
            'Graatulerer!',
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
          Text('Du har nå fullført alle oppgavene i spillet!'),
          const SizedBox(height: 10),
          $Button(
            text: 'Vis resultatet',
            onPressed: () {
              final gruppeId = context.read(gruppeIdProvider).state;
              assert(gruppeId != null);
              // context.read(loypeStateProvider(gruppeId!).notifier).settStedFullfort(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, AvsluttLoype.rute, (route) => false);
            },
          )
        ],
      ),
    );
  }
}
