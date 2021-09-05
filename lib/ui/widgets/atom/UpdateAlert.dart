import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class $UpdateAlert extends StatelessWidget {
  final bool showAlert;
  final Widget child;

  const $UpdateAlert({
    Key? key,
    required this.showAlert,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (showAlert)
          Stack(
            alignment: Alignment.center,
            children: [
              Styled.widget()
                  .decorated(color: Colors.white)
                  .constrained(width: 15, height: 15),
              IconBouncing(),
            ],
          ).positioned(right: -13, top: -13),
      ],
    );
  }
}

class IconBouncing extends StatefulWidget {
  const IconBouncing({Key? key}) : super(key: key);

  @override
  _IconBouncingState createState() => _IconBouncingState();
}

class _IconBouncingState extends State<IconBouncing>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final CurveTween curve = CurveTween(curve: Curves.easeInOut);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Icon(
          Icons.priority_high,
          color: Colors.white,
          size: 20,
        )
            .padding(all: 5)
            .decorated(
              shape: BoxShape.circle,
              color: Colors.yellow[600],
              border: Border.all(
                color: Colors.yellow.shade700,
                width: 2,
              ),
            )
            .scale(all: 1 + curve.animate(controller).value / 6);
      },
    );
  }
}
