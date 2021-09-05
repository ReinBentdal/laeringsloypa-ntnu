import 'package:flutter/material.dart';
import 'package:loypa/ui/Dashbord/LoypeLaster.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:styled_widget/styled_widget.dart';

class GruppespillInfo extends StatelessWidget {
  static const rute = 'gruppespill info';
  const GruppespillInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SColumn(
        separator: const SizedBox(height: 10),
        children: [
          Icon(
            Icons.groups,
            size: 200,
            color: Theme.of(context).accentColor,
          ),
          Text(
            'Gruppespill info',
            style: Theme.of(context)
                .textTheme
                .headline2
                ?.copyWith(color: Theme.of(context).primaryColor),
          ),
          Text(
            'Når man spiller sammen i en gruppe, må man selv løse oppgavene på sin telefon. Men man kan sammarbeide for å finne svarene og dele det riktige svaret.\n\nGrupperesultatet publiseres når den første i gruppen fullfører løypen.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          SizedBox().expanded(),
          $Button(
            onPressed: () {
              Navigator.pushNamed(context, LoypeLaster.rute);
            },
            text: 'Start',
          ),
        ],
      ).padding(vertical: 40, horizontal: 30),
    );
  }
}
