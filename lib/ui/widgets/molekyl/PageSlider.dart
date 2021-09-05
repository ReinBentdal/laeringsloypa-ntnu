import 'package:flutter/material.dart';

class PageSlider extends StatefulWidget {
  const PageSlider({
    Key? key,
    required this.children,
    required this.onPageChange,
    this.controller,
  }) : super(key: key);

  final List<Widget> children;
  final void Function(int) onPageChange;
  final PageController? controller;

  @override
  _PageSliderState createState() => _PageSliderState();
}

class _PageSliderState extends State<PageSlider> {
  late PageController _pageController;
  late bool _localController;
  bool firstBuild = true;

  @override
  void initState() {
    super.initState();
    final initialIndex = 1000 - (1000 % widget.children.length);
    _pageController =
        widget.controller ?? PageController(initialPage: initialIndex);
    _localController = widget.controller == null;
  }

  @override
  void dispose() {
    super.dispose();
    if (_localController) _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final childrenLength = widget.children.length;
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (absIndex) =>
          widget.onPageChange(absIndex % childrenLength),
      itemBuilder: (context, absIndex) {
        final relIndex = absIndex % childrenLength;
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            final offset = firstBuild
                ? 0.0
                : 0.8 * (absIndex - ((_pageController.page ?? 0))).abs();
            firstBuild = false;
            return Transform.scale(
              scale: Curves.easeOut.transform(1 - offset),
              child: child,
            );
          },
          child: widget.children.elementAt(relIndex),
        );
      },
    );
  }
}
