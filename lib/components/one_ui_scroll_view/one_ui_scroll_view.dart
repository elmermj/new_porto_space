import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/components/one_ui_scroll_view/one_ui_scroll_physics.dart';
import 'package:new_porto_space/components/one_ui_scroll_view/one_ui_scroll_view_controller.dart';

class OneUiScrollView extends GetView<OneUiScrollController> {
  OneUiScrollView({
    super.key,
    required this.expandedTitle,
    required this.collapsedTitle,
    required this.actions,
    this.children = const [],
    this.childrenPadding = EdgeInsets.zero,
    this.bottomDivider = kBottomDivider,
    required this.expandedHeight,
    this.toolbarHeight = kToolbarHeight,
    this.actionSpacing = 0,
    required this.backgroundColor,
    this.elevation = 12.0,
    this.globalKey,
  });

  final Widget expandedTitle;
  final Widget collapsedTitle;
  final List<Widget> actions;
  final List<Widget> children;
  final EdgeInsetsGeometry childrenPadding;
  final Divider bottomDivider;
  final double expandedHeight;
  final double toolbarHeight;
  final double actionSpacing;
  final Color backgroundColor;
  final double elevation;
  final GlobalKey<NestedScrollViewState>? globalKey;

  final OneUiScrollController scrollController = Get.put(OneUiScrollController());

  @override
  Widget build(BuildContext context) {
    final scrollController = Get.put(OneUiScrollController());

    return GetBuilder<OneUiScrollController>(
      builder: (_) => SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowIndicator();
            return true;
          },
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              final scrollViewState = globalKey!.currentState;
              final outerController = scrollViewState?.outerController;

              if (scrollViewState?.innerController.position.pixels == 0 &&
                  !outerController!.position.atEdge) {
                final range = scrollController.expandedHeight.value -
                    scrollController.toolbarHeight.value;
                final snapOffset =
                    (outerController.offset / range) > 0.5 ? range : 0.0;

                Future.microtask(
                    () => _snapAppBar(outerController, snapOffset));
              }
              return false;
            },
            child: NestedScrollView(
              key: globalKey,
              physics: OneUiScrollPhysics(
                scrollController.expandedHeight.value,
              ),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return _getAppBar(context, innerBoxIsScrolled, scrollController);
              },
              body: SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) => CustomScrollView(
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      ),
                      SliverPadding(
                        padding: childrenPadding,
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int i) => children[i],
                            childCount: children.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _snapAppBar(ScrollController controller, double snapOffset) async {
    await controller.animateTo(
      snapOffset,
      curve: Curves.ease,
      duration: const Duration(milliseconds: 150),
    );
  }

  List<Widget> _getAppBar(
    BuildContext context,
    bool innerBoxIsScrolled,
    OneUiScrollController scrollController,
  ) {
    return [
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
          backgroundColor: backgroundColor,
          pinned: true,
          // expandedHeight: expandedHeight ??
          //     (MediaQuery.of(context).size.height *
          //         kExpendedAppBarHeightRatio),
          toolbarHeight: scrollController.toolbarHeight.value,
          elevation: elevation,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              final expandRatio = (constraints.maxHeight -
                      scrollController.toolbarHeight.value) /
                  (scrollController.expandedHeight.value -
                      scrollController.toolbarHeight.value);

              if (expandRatio > 1.0) return const SizedBox.shrink();
              if (expandRatio < 0.0) return const SizedBox.shrink();

              final animation = AlwaysStoppedAnimation(expandRatio);

              return Stack(
                fit: StackFit.expand,
                children: [
                  _extendedTitle(animation),
                  _collapsedTitle(animation),
                  _actions(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: bottomDivider,
                  )
                ],
              );
            },
          ),
        ),
      ),
    ];
  }

  Widget _extendedTitle(Animation<double> animation) {
    return FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animation,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      )),
      child: Center(child: expandedTitle),
    );
  }

  Widget _collapsedTitle(Animation<double> animation) {
    return FadeTransition(
      opacity: Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      )),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: const EdgeInsets.only(left: 16),
          height: scrollController.toolbarHeight.value,
          child: Align(
            alignment: Alignment.centerLeft,
            child: collapsedTitle,
          ),
        ),
      ),
    );
  }

  Widget _actions() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.only(right: actionSpacing),
        height: scrollController.toolbarHeight.value,
        child: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions,
          ),
        ),
      ),
    );
  }
}
