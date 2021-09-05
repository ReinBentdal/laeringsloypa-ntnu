import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:loypa/ui/widgets/atom/Button.dart';
import 'package:loypa/ui/widgets/atom/Dialolg.dart';
import 'package:styled_widget/styled_widget.dart';

class DialogStegModel {
  final String tittel;
  final String beskrivelse;

  DialogStegModel({
    required this.tittel,
    required this.beskrivelse,
  });
}

class MultipageDialog extends StatefulWidget {
  const MultipageDialog({
    Key? key,
    required this.dialog,
    this.onChange,
  }) : super(key: key);

  final List<DialogStegModel> dialog;
  final void Function(int)? onChange;

  @override
  _MultipageDialogState createState() => _MultipageDialogState();
}

class _MultipageDialogState extends State<MultipageDialog> {
  int sideIndex = 0;
  final _pageController = PageController();

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

  @override
  Widget build(BuildContext context) {
    final endeligSide = sideIndex + 1 == widget.dialog.length;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: $Dialog(
        bottomBorder: [
          $Button(
            onPressed: () => endeligSide
                ? Navigator.pop(context)
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
      ),
    );
  }
}
