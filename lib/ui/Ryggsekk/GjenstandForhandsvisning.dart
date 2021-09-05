import 'package:flutter/material.dart';
import 'package:loypa/ui/Ryggsekk/RyggsekkGjenstand.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/molekyl/BildePinch.dart';
import 'package:loypa/ui/widgets/molekyl/FirebaseImage.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:loypa/data/model/Ryggsekk.dart';
import 'package:loypa/ui/widgets/atom/Dialolg.dart';

class GjenstandForhandsvisning extends StatelessWidget {
  final RyggsekkGjenstandModel ryggsekkGjenstand;

  const GjenstandForhandsvisning({
    Key? key,
    required this.ryggsekkGjenstand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ekstraRessurs = ryggsekkGjenstand.ekstraRessurs != null;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: $Dialog(
        borderColor: ekstraRessurs ? Theme.of(context).accentColor : null,
        bottomBorder: [
          $Button(
            onPressed: () => Navigator.pop(context),
            text: 'Lukk',
          ).expanded(flex: ekstraRessurs ? 1 : 0),
          if (ekstraRessurs)
            $Button(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RyggsekkGjenstand(ryggsekkGjenstand),
                  ),
                );
              },
              text: ryggsekkGjenstand.tilpassetKnapptekst ?? 'Åpne',
              color: Theme.of(context).primaryColor,
            ).expanded(),
        ],
        child: Column(
          verticalDirection: VerticalDirection.up,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 20),
            Text(
              ryggsekkGjenstand.beskrivelse,
              // textAlign: TextAlign.center,
            ).alignment(Alignment.centerLeft),
            const SizedBox(height: 5),
            Text(
              ryggsekkGjenstand.navn,
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 10),
            BildePinch(
              child: FirebaseImage(
                prefix: 'gjenstander/',
                path: ryggsekkGjenstand.ikon,
                semanticsLabel:
                    'Bilde av ${ryggsekkGjenstand.navn} med beskrivelse ${ryggsekkGjenstand.beskrivelse}',
              ).constrained(width: 300, height: 250),
            ),
          ],
        ).constrained(minWidth: 250, minHeight: 350),
      ),
      //  BottomBorderButton(
      //   child: $Dialog(
      //     borderColor: ekstraRessurs ? Theme.of(context).accentColor : null,
      //     child: Column(
      //       verticalDirection: VerticalDirection.up,
      //       mainAxisSize: MainAxisSize.min,
      //       mainAxisAlignment: MainAxisAlignment.end,
      //       children: [
      //         const SizedBox(height: 20),
      //         Text(
      //           ryggsekkGjenstand.beskrivelse,
      //           // textAlign: TextAlign.center,
      //         ).alignment(Alignment.centerLeft),
      //         const SizedBox(height: 5),
      //         Text(
      //           ryggsekkGjenstand.navn,
      //           style: Theme.of(context).textTheme.headline3,
      //         ),
      //         const SizedBox(height: 10),
      //         BildePinch(
      //           child: FirebaseImage(
      //             prefix: 'gjenstander/',
      //             path: ryggsekkGjenstand.ikon,
      //             semanticsLabel:
      //                 'Bilde av ${ryggsekkGjenstand.navn} med beskrivelse ${ryggsekkGjenstand.beskrivelse}',
      //           ).constrained(width: 300, height: 250),
      //         ),
      //       ],
      //     ).constrained(minWidth: 250, minHeight: 350),
      //   ),
      //   buttonColor: ekstraRessurs ? Theme.of(context).primaryColor : null,
      //   buttonText: ryggsekkGjenstand.tilpassetKnapptekst ?? 'Lukk',
      //   callback: () {
      //     Navigator.pop(context);

      //     if (ekstraRessurs)
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => RyggsekkGjenstand(ryggsekkGjenstand),
      //         ),
      //       );
      //   },
      // ),
    );
  }
}
