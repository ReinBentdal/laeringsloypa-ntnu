import 'package:flutter/material.dart';
import 'package:loypa/control/provider/stedProvider.dart';
import 'package:loypa/ui/Sted/StedSide.dart';
import 'package:loypa/ui/widgets/atom/BottomSheet.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FremmeVedLokasjon extends StatelessWidget {
  const FremmeVedLokasjon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sted = context.read(valgtStedProvider);
    return $BottomSheet(
      child: SColumn(
        mainAxisSize: MainAxisSize.min,
        separator: const SizedBox(height: 10),
        children: [
          Text(
            'Velkommen til',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ).textColor(Colors.black),
          Text(
            sted.stedsnavn,
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
          Text(
            sted.stedsbeskrivelse,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          $Button(
            text: 'Løs oppgaver',
            onPressed: () async {
              Navigator.pushNamed(context, Sted.rute);
              // showModalBottomSheet(
              //   context: context,
              //   isScrollControlled: true,
              //   isDismissible: false,
              //   enableDrag: false,
              //   builder: (context) {
              //     return Sted();
              //   },
              // );
            },
          )
        ],
      ),
    );
  }
}
