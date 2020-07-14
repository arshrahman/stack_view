import 'package:flutter/gestures.dart';
import 'package:stack_view/src/translucent_hit_stack.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

class StackView extends StatefulWidget {
  /// Controls whether the widget's pages will respond to
  /// [RenderObject.showOnScreen], which will allow for implicit accessibility
  /// scrolling.
  ///
  /// With this flag set to false, when accessibility focus reaches the end of
  /// the current page and the user attempts to move it to the next element, the
  /// focus will traverse to the next widget outside of the page view.
  ///
  /// With this flag set to true, when accessibility focus reaches the end of
  /// the current page and user attempts to move it to the next element, focus
  /// will traverse to the next page in the page view.
  final bool allowImplicitScrolling;

  /// The axis along which the page view scrolls.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Whether the page view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the page view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the page view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// An object that can be used to control the position to which this page
  /// view is scrolled.
  final PageController controller;

  /// How the page view should respond to user input.
  ///
  /// For example, determines how the page view continues to animate after the
  /// user stops dragging the page view.
  ///
  /// The physics are modified to snap to page boundaries using
  /// [PageScrollPhysics] prior to being used.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics physics;

  /// Set to false to disable page snapping, useful for custom scroll behavior.
  final bool pageSnapping;

  /// Called whenever the page in the center of the viewport changes.
  final ValueChanged<int> onPageChanged;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// Number of visible stackView items to build.
  /// The actual stackView items built is two + stackCount,
  /// accounting one for previously swiped item and
  /// one additional item after the last visible item in stack for smooth transition.
  /// default is 0.
  final int stackCount;

  ///Defines the offset value of each item behind the current displayed item in StackView.
  ///Example: Top only by offset of 10: Offset(0, -10).
  ///Similary for bottom is Offset(0, 10),
  ///left is Offset(-10, 0),
  ///right is Offset(10, 0).
  ///Default is Offset(0, 0).
  ///For best results, set the margin of the widget accordingly.
  final Offset offset;

  ///Starting from the current displayed item in StackView to stackCount, each item will have its scale value diminished by scaleFactor.
  ///Example: scaleFactor of 0.05 -> 1.0, 0.95, 0.9 etc. Default is 0.0
  final double scaleFactor;

  ///Starting from the first item behind the current displayed item in StackView to stackCount, each item will have its opacity value diminished by opacityFactor.
  ///Example: opacityFactor of 0.2 -> 1.0, 0.8, 0.6 etc. Default is 0.0
  final double opacityFactor;

  ///Defines the value to shift the widget in response to swipe motion.
  ///The direction to shift is based on PageView scrollDirection and offset values.
  ///Example, for horizontal swipe direction, Offset(0, -10) and a translateFactor of 10,
  ///the top position of the stack item would go from 0 to 100 as the item being swiped.
  ///Default is 0.0
  final double translateFactor;

  StackView({
    Key key,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    @required this.itemCount,
    @required this.itemBuilder,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.stackCount = 0,
    this.offset = const Offset(0, 0),
    this.scaleFactor = 0.0,
    this.opacityFactor = 0.0,
    this.translateFactor = 0.0,
  })  : assert(allowImplicitScrolling != null),
        super(key: key);

  @override
  _StackViewState createState() => _StackViewState();
}

class _StackViewState extends State<StackView> {
  PageController pageController;
  double currentPage = 0.0;
  int previousPage = 0;
  double height;
  double width;
  double offsetX;
  double offsetY;
  // double scaleFactor = 0.05;
  // double opacityFactor = 0.30;
  // int stackCount = 3;

  @override
  void initState() {
    super.initState();
    offsetX = widget.offset.dx;
    offsetY = widget.offset.dy;
    pageController = widget.controller ?? PageController(viewportFraction: 2);
    pageController.addListener(() => setState(() {
          currentPage = pageController.page;
          // currentPage = pageController.page.clamp(previousPage - 1.0, previousPage + 1.0);
          // print('pageController.page ${pageController.page} currentPage $currentPage previousPage $previousPage');
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
      // width: 200,
      child: TranslucenHitStack(
        children: <Widget>[
          buildCardStack(),
          GestureDetector(
            // onHorizontalDragStart: (details) => previousPage = currentPage.round(),
            child: PageView.builder(
              scrollDirection: widget.scrollDirection,
              itemCount: widget.itemCount,
              itemBuilder: (context, index) => Container(
                  // color: Colors.red.withOpacity(0.2),
                  ),
              controller: pageController,
              onPageChanged: (int) {},
            ),
          )
        ],
      ),
    );
  }

  Widget buildCardStack() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final List<Widget> cards = [];
    final int currentPageIndex = currentPage.toInt();
    final int startPage = Math.max(currentPageIndex - 1, 0);
    final int endPage = Math.min(currentPageIndex + widget.stackCount, widget.itemCount - 1);

    for (int page = startPage; page <= endPage; page++) {
      final double pageOffset = page - currentPage;
      double topOffset = 0.0;
      double leftOffset = 0.0;
      double bottomOffset = 0.0;
      double scale = 1.0;
      double opacity = 1.0;

      // double topOffset = currentPage > page ? 0.0 : (pageOffset * offsetY).clamp(2 * offsetY, 0.0);
      // double leftOffset = currentPage > page ? pageOffset * width * 2 : 0.0;
      // double scale = currentPage > page ? 1.0 : (1.0 - (pageOffset * scaleFactor)).clamp(1.0 - 2 * scaleFactor, 1.0);
      // double opacity = currentPage > page ? 1.0 : (1.0 - ((pageOffset - 1) * opacityFactor)).clamp(0.0, 1.0);

      if (currentPage > page) {
        if (widget.scrollDirection == Axis.horizontal) {
          leftOffset = pageOffset * width * 1;
        } else {
          topOffset = pageOffset * height * 1;
        }
      } else {
        topOffset = (pageOffset * offsetY).clamp(2 * offsetY, 0.0);
        scale = (1.0 - (pageOffset * widget.scaleFactor)).clamp(1.0 - 2 * widget.scaleFactor, 1.0);
        opacity = (1.0 - ((pageOffset - 1) * widget.opacityFactor)).clamp(0.0, 1.0);
      }

      print(
          'page $page pageOffset $pageOffset topOffset $topOffset leftOffset $leftOffset bottomOffset $bottomOffset scale $scale opacity $opacity');

      cards.add(
        Positioned.fill(
          top: (pageOffset > -1.0 && pageOffset < 0.0) ? (pageOffset * offsetY * widget.translateFactor) : topOffset,
          // top: topOffset,
          left: leftOffset,
          right: -leftOffset,
          bottom: (pageOffset > -1.0 && pageOffset < 0.0) ? -(pageOffset * offsetY * widget.translateFactor) : -topOffset,
          child: buildCard(page, opacity, Offset(offsetX, topOffset), scale),
        ),
      );
    }
    return Stack(children: cards.reversed.toList());
  }

  Widget buildCard(int index, double opacity, Offset offset, double scale) {
    return Align(
      alignment: Alignment.center,
      child: Opacity(
        opacity: opacity,
        child: Transform.translate(
          key: ValueKey<int>(index),
          offset: offset,
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topCenter,
            child: Container(
              child: widget.itemBuilder(context, index),
            ),
          ),
        ),
      ),
    );
  }
}
