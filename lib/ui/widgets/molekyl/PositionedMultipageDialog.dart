import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/Dialolg.dart';
import 'package:styled_widget/styled_widget.dart';

import 'MultipageDialog.dart';

class PositionedDialogStegModel extends DialogStegModel {
  final GlobalKey? widgetRef;

  PositionedDialogStegModel({
    this.widgetRef,
    required String tittel,
    required String beskrivelse,
  }) : super(
          tittel: tittel,
          beskrivelse: beskrivelse,
        );
}

class PositionedMultipageDialog extends StatefulWidget {
  const PositionedMultipageDialog({
    Key? key,
    required this.dialog,
    this.onChange,
  }) : super(key: key);

  final List<PositionedDialogStegModel> dialog;
  final void Function(int)? onChange;

  @override
  _PositionedMultipageDialogState createState() =>
      _PositionedMultipageDialogState();
}

class _PositionedMultipageDialogState extends State<PositionedMultipageDialog> {
  int sideIndex = 0;
  final _pageController = PageController();
  final dialogRef = GlobalKey();
  bool kalkulerPosisjon = true;

  Offset dialogOffset = Offset.zero;
  AlignmentGeometry dialogAlignment = Alignment.center;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void animerTilSide(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 400),
      curve: Curves.linearToEaseOut,
    );
  }

  static const dialogPadding = 20;
  static const highlightPadding = 10;

  @override
  Widget build(BuildContext context) {
    final endeligSide = sideIndex + 1 == widget.dialog.length;

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (kalkulerPosisjon == false) {
        return;
      }

      // vente til dialogen har animert til endelig størrelse
      await Future.delayed(Duration(milliseconds: 300));

      kalkulerPosisjon = false;

      final defaultOffset = MediaQuery.of(context).padding.top;
      final highlightPosisjon = (widget.dialog
              .elementAt(sideIndex)
              .widgetRef
              ?.currentContext
              ?.findRenderObject() as RenderBox?)
          ?.localToGlobal(Offset.zero);
      final highlightSize =
          widget.dialog.elementAt(sideIndex).widgetRef?.currentContext?.size;
      final dialogSize = dialogRef.currentContext?.size;
      final screenHeight = MediaQuery.of(context).size.height;
      final screenHeight2 = screenHeight / 2;

      final highlightDy = highlightPosisjon?.dy ?? 0;
      final highlightHeight = highlightSize?.height ?? 0;
      final dialogHeight = dialogSize?.height ?? 0;

      final dialogTop = screenHeight2 - (dialogHeight / 2);
      final dialogBottom = screenHeight2 + (dialogHeight / 2);

      final oversideUnder =
          highlightDy + dialogPadding > dialogTop + defaultOffset &&
              highlightDy - dialogPadding < dialogBottom + defaultOffset;
      final undersideUnder = highlightDy + highlightHeight + dialogPadding >
              dialogTop + defaultOffset &&
          highlightDy + highlightHeight - dialogPadding <
              dialogBottom + defaultOffset;

      // highlight under dialog
      if (widget.dialog.elementAt(sideIndex).widgetRef == null ||
          !oversideUnder ||
          !undersideUnder) {
        setState(() {
          dialogOffset = Offset.zero;
          dialogAlignment = Alignment.center;
        });
      }

      // ikke plass til dialog over highlight
      else if (highlightDy - 2 * dialogPadding - dialogHeight < 0) {
        setState(() {
          dialogOffset = Offset(
            0,
            highlightDy +
                highlightHeight +
                (2 * highlightPadding) +
                dialogPadding -
                defaultOffset,
          );
          dialogAlignment = Alignment.topCenter;
        });

        // ikke plass til dialog under highlight
      } else if (highlightDy +
              highlightHeight +
              2 * dialogPadding +
              dialogHeight >
          screenHeight) {
        setState(() {
          dialogOffset = Offset(
            0,
            highlightDy -
                highlightPadding -
                dialogPadding -
                dialogHeight -
                defaultOffset,
          );
          dialogAlignment = Alignment.topCenter;
        });
      } else {
        setState(() {
          dialogOffset = Offset.zero;
          dialogAlignment = Alignment.center;
        });
      }
    });

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: $Dialog(
        key: dialogRef,
        bottomBorder: [
          $Button(
            onPressed: () => endeligSide
                ? Navigator.maybePop(context)
                : animerTilSide(sideIndex + 1),
            text: endeligSide ? 'Lukk' : 'Neste',
          ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.dialog.elementAt(sideIndex).tittel,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 10),
            ExpandablePageView(
              controller: _pageController,
              animationDuration: Duration(milliseconds: 300),
              onPageChanged: (i) {
                if (widget.onChange != null) widget.onChange!(i);
                kalkulerPosisjon = true;
                setState(() => sideIndex = i);
              },
              children: widget.dialog.map(
                (dialog) {
                  return Text(dialog.beskrivelse);
                },
              ).toList(),
            ),
            SizedBox(height: 20),
            if (widget.dialog.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < widget.dialog.length; i++)
                    Styled.widget()
                        .constrained(width: 10, height: 10)
                        .ripple()
                        .decorated(
                          color: i == sideIndex
                              ? Theme.of(context).accentColor
                              : Colors.grey[200],
                          shape: BoxShape.circle,
                        )
                        .padding(all: 5)
                        .gestures(onTap: () => animerTilSide(i))
                ],
              ),
            SizedBox(height: 20),
          ],
        ),
      )
          // .decorated(position: DecorationPosition.foreground, color: Colors.black)
          .alignment(dialogAlignment, animate: true)
          .translate(offset: dialogOffset, animate: true)
          .animate(Duration(milliseconds: 500), Curves.easeOut),
    );
  }
}
