import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:loypa/ui/widgets/molekyl/PositionedMultipageDialog.dart';

class Showcase extends StatefulWidget {
  const Showcase({
    Key? key,
    required this.steg,
    this.child,
    this.ferdig,
  }) : super(key: key);

  final List<PositionedDialogStegModel> steg;
  final Widget? child;
  final void Function()? ferdig;

  @override
  _ShowcaseState createState() => _ShowcaseState();
}

class _ShowcaseState extends State<Showcase> {
  bool visShowcase = false;
  int stegIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 500));

      setState(() {
        visShowcase = true;
      });

      await showAnimatedDialog(
        barrierDismissible: false,
        context: context,
        duration: Duration(milliseconds: 400),
        animationType: DialogTransitionType.scale,
        curve: Curves.easeOut,
        builder: (_) => PositionedMultipageDialog(
          dialog: widget.steg,
          onChange: (i) => setState(() => stegIndex = i),
        ),
        barrierColor: Color(0x01000000),
      );

      if (widget.ferdig != null) widget.ferdig!();

      setState(() {
        visShowcase = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return visShowcase
        ? CustomPaint(
            size: MediaQuery.of(context).size,
            foregroundPainter: HolePainter(
                widgetRef: widget.steg.elementAt(stegIndex).widgetRef),
            child: widget.child,
          )
        : widget.child ?? const SizedBox();
  }
}

class HolePainter extends CustomPainter {
  HolePainter({
    required this.widgetRef,
  }) : super();

  final GlobalKey? widgetRef;

  static const padding = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;

    if (widgetRef != null) {
      final storrelse = widgetRef?.currentContext?.size;
      final objekt = widgetRef?.currentContext?.findRenderObject() as RenderBox;
      final posisjon = objekt.localToGlobal(Offset.zero);

      canvas.drawPath(
          Path.combine(
            PathOperation.difference,
            Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
            Path()
              ..addRRect(
                RRect.fromRectAndRadius(
                    Rect.fromLTWH(
                        posisjon.dx - padding,
                        posisjon.dy - padding,
                        (storrelse?.width ?? 0) + 2 * padding,
                        (storrelse?.height ?? 0) + 2 * padding),
                    Radius.circular(10)),
              )
              ..close(),
          ),
          paint);
    } else {
      canvas.drawPath(
          Path()
            ..addRect(
              Rect.fromLTWH(0, 0, size.width, size.height),
            ),
          paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
