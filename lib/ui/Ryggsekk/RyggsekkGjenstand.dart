import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loypa/config/markdown/markdown_builders.dart';
import 'package:loypa/config/markdown/markdown_stylesheet.dart';
import 'package:loypa/data/model/Ryggsekk.dart';
import 'package:loypa/ui/widgets/atom/SubpageAppbar.dart';
import 'package:styled_widget/styled_widget.dart';

class RyggsekkGjenstand extends StatelessWidget {
  static const String rute = 'Ryggsekk Gjenstand';

  final RyggsekkGjenstandModel ryggsekkGjenstand;

  const RyggsekkGjenstand(
    this.ryggsekkGjenstand, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SubpageAppBar(title: 'Gjenstand').padding(horizontal: 30),
            Markdown(
              data: ryggsekkGjenstand.ekstraRessurs ?? '',
              imageBuilder: imageBuilder,
              styleSheet: markdownStylesheet(context),
            ).expanded(),
          ],
        ).padding(top: 20),
      ),
    );
  }
}
