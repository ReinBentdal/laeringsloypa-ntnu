import 'package:flutter/material.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/Dialolg.dart';
import 'package:loypa/ui/widgets/atom/SColumn.dart';
import 'package:loypa/ui/widgets/atom/ShowAnimatedDialog.dart';

final varslingBase = (
  BuildContext context, {
  required String tittel,
  required String beskrivelse,
  String? knapptekst,
  void Function()? onClick,
  required Color knappfarge,
  required Color rammefarge,
}) =>
    $showAnimatedDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: $Dialog(
          borderColor: rammefarge,
          bottomBorder: [
            $Button(
              onPressed: onClick ?? () => Navigator.pop(context),
              text: knapptekst ?? 'Lukk',
              color: knappfarge,
            ),
          ],
          child: SColumn(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            separator: const SizedBox(height: 5),
            children: [
              Text(
                tittel,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(beskrivelse),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );

final varslingFeilmelding = (
  BuildContext context, {
  required String tittel,
  required String beskrivelse,
  String? knapptekst,
  void Function()? onClick,
}) =>
    varslingBase(
      context,
      tittel: tittel,
      beskrivelse: beskrivelse,
      knapptekst: knapptekst,
      onClick: onClick,
      knappfarge: Theme.of(context).errorColor,
      rammefarge: Theme.of(context).accentColor,
    );

final varslingAdvarsel = (
  BuildContext context, {
  required String tittel,
  required String beskrivelse,
  String? knapptekst,
  void Function()? onClick,
}) =>
    varslingBase(
      context,
      tittel: tittel,
      beskrivelse: beskrivelse,
      knapptekst: knapptekst,
      onClick: onClick,
      knappfarge: Theme.of(context).errorColor,
      rammefarge: Theme.of(context).accentColor,
    );

final varsling = (
  BuildContext context, {
  required String tittel,
  required String beskrivelse,
  String? knapptekst,
  void Function()? onClick,
}) =>
    varslingBase(
      context,
      tittel: tittel,
      beskrivelse: beskrivelse,
      knapptekst: knapptekst,
      onClick: onClick,
      knappfarge: Theme.of(context).accentColor,
      rammefarge: Theme.of(context).primaryColor,
    );
