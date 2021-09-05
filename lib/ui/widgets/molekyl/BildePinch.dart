import 'package:flutter/material.dart';

class BildePinch extends StatefulWidget {
  const BildePinch({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _BildePinchState createState() => _BildePinchState();
}

class _BildePinchState extends State<BildePinch> {
  final transformationController = TransformationController();
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      clipBehavior: Clip.none,
      child: widget.child,
      transformationController: transformationController,
      onInteractionEnd: (_) =>
          transformationController.value = Matrix4.identity(),
    );
  }
}
