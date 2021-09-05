import 'package:flutter/material.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:loypa/ui/widgets/molekyl/Ledertavle.dart';
import 'package:styled_widget/styled_widget.dart';

class LoypeLedertavle extends StatelessWidget {
  static const rute = 'løype ledertavle';
  const LoypeLedertavle({
    Key? key,
    required this.loypeId,
  }) : super(key: key);

  final String? loypeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SColumn(
          mainAxisSize: MainAxisSize.min,
          separator: const SizedBox(height: 10),
          children: [
            SubpageAppBar(
              title: 'Ledertavle',
              titleColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(),
            if (loypeId != null)
              Ledertavle(
                loypeId: loypeId!,
              ).padding(horizontal: 30, bottom: 30).expanded(flex: 2),
          ],
        ).center().padding(top: 40),
      ),
    );
  }
}
