import 'package:flutter/material.dart';
import 'package:loypa/data/model/Ryggsekk.dart';
import 'package:loypa/ui/widgets/atom/BottomBorderButton.dart';
import 'package:loypa/ui/widgets/atom/Dialolg.dart';
import 'package:styled_widget/styled_widget.dart';

class OppgaveFullfortDialog extends StatelessWidget {
  final List<RyggsekkGjenstandModel> ryggsekkGjenstander;

  const OppgaveFullfortDialog(
    this.ryggsekkGjenstander, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: BottomBorderButton(
        buttonText: 'Lukk',
        callback: () => Navigator.pop(context),
        child: $Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gratulerer, du løste oppgaven!',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 5),
              ...ryggsekkGjenstander
                  .map(
                    (e) => Text(
                      'Du mottok 1x ${e.navn}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ).padding(bottom: 10),
                  )
                  .toList(),
              const SizedBox(height: 25),
            ],
          ).constrained(minWidth: 250),
        ),
      ),
    );
  }
}
