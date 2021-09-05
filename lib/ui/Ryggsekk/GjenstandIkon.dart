import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/provider/RyggsekkProvider.dart';
import 'package:loypa/ui/Ryggsekk/GjenstandForhandsvisning.dart';
import 'package:loypa/ui/widgets/atom/ShowAnimatedDialog.dart';
import 'package:loypa/ui/widgets/atom/UpdateAlert.dart';
import 'package:loypa/ui/widgets/molekyl/FirebaseImage.dart';
import 'package:styled_widget/styled_widget.dart';

class GjenstandIkon extends ConsumerWidget {
  final int gjenstandIndex;
  const GjenstandIkon(
    this.gjenstandIndex, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ryggsekkGjenstand =
        watch(ryggsekkGjenstandProvider(gjenstandIndex)).state;
    return $UpdateAlert(
      showAlert: !ryggsekkGjenstand.sett,
      child: FirebaseImage(
        prefix: 'gjenstander/',
        path: ryggsekkGjenstand.ikon,
        semanticsLabel: 'Bilde av ${ryggsekkGjenstand.navn}',
      )
          .padding(all: 15)
          .ripple()
          .constrained(minWidth: 30, minHeight: 30)
          .decorated(color: Colors.grey[200])
          .clipRRect(all: 15)
          .gestures(
        onTap: () {
          context
              .read(ryggsekkInnholdProvider.notifier)
              .gjenstandSett(gjenstandIndex);
          $showAnimatedDialog(
            context: context,
            builder: (context) {
              return GjenstandForhandsvisning(
                ryggsekkGjenstand: ryggsekkGjenstand,
              );
            },
          );
        },
      ),
    );
  }
}
