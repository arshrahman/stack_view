import 'package:flutter/material.dart';
import 'dart:math' as Math;

import 'custom_scroll_physics.dart';

class CardStack extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Function(int) onPageChanged;
  final PageController pageController;

  CardStack({@required this.itemCount, @required this.itemBuilder, this.onPageChanged, this.pageController});

  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  // PageController pageController;
  double currentPage = 0.0;
  double offsetX = 0.0;
  double offsetY = -5.0;
  double scaleFactor = 0.05;
  double opacityFactor = 0.30;
  int stackCount = 3;
  double margin = 0.0;

  @override
  void initState() {
    super.initState();
    // widget.pageController = PageController(viewportFraction: 2.0, initialPage: widget.pageController.initialPage, keepPage: widget.pageController.keepPage);
    widget.pageController.addListener(() => setState(() => currentPage = widget.pageController.page));
    margin = offsetY.abs() * (stackCount + 2);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        buildCardStack(),
        PageView.builder(
          itemCount: widget.itemCount,
          itemBuilder: (context, index) => Container(),
          controller: widget.pageController,
          onPageChanged: (int) => widget.onPageChanged(int),
          physics: CustomPageScrollPhysics(),
        )
      ],
    );
  }

  Widget buildCardStack() {
    final width = MediaQuery.of(context).size.width;
    final List<Widget> cards = [];
    final int currentPageIndex = currentPage.toInt();

    for (int page = Math.max(currentPageIndex - 1, 0); page <= Math.min(currentPageIndex + stackCount, widget.itemCount - 1); page++) {
      final pageOffset = page - currentPage;
      final topOffset = currentPage > page ? 0.0 : (pageOffset * offsetY).clamp(2 * offsetY, 0.0);
      final leftOffset = currentPage > page ? pageOffset * width * 2 : 0.0;
      final scale = currentPage > page ? 1.0 : (1.0 - (pageOffset * scaleFactor)).clamp(0.0, 1.0);
      final opacity = currentPage > page ? 1.0 : (1.0 - ((pageOffset - 1) * opacityFactor)).clamp(0.0, 1.0);
      cards.add(
        Positioned.fill(
          top: (pageOffset > -1.0 && pageOffset < 0.0) ? (pageOffset * offsetY * 10) : topOffset,
          left: leftOffset,
          child: buildCard(page, opacity, Offset(offsetX, topOffset), scale),
        ),
      );
    }
    return Stack(children: cards.reversed.toList());
  }

  Widget buildCard(int index, double opacity, Offset offset, double scale) {
    return Align(
      alignment: Alignment.topCenter,
      child: Opacity(
        opacity: opacity,
        child: Transform.translate(
          key: ValueKey<int>(index),
          offset: offset,
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: widget.itemBuilder(context, index),
            ),
          ),
        ),
      ),
    );
  }
}
