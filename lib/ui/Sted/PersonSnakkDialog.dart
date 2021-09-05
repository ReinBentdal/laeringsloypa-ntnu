import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/provider/stedProvider.dart';
import 'package:loypa/ui/widgets/molekyl/MultipageDialog.dart';

// final _personSamtalesideProvider = StateProvider.autoDispose<int>((ref) => 0);

class $PersonSnakkDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final samtale = context.read(valgtPersonProvider).samtale;

    final samtaleReshape = samtale?.dialog.map((dialog) {
      return DialogStegModel(tittel: samtale.tittel, beskrivelse: dialog);
    }).toList();

    return MultipageDialog(
      dialog: samtaleReshape ?? [DialogStegModel(tittel: '', beskrivelse: '')],
    );
  }
}
