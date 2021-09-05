import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class $BottomSheet extends StatelessWidget {
  const $BottomSheet({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: child
          .padding(all: 40)
          .safeArea(
            top: false,
          )
          .decorated(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
    );
  }
}
