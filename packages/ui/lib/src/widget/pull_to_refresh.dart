import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Универсальный pull‑to‑refresh.
/// Вариант A: оборачивает уже прокручиваемого потомка (ListView/CustomScrollView и т.п.)
/// Вариант B: делает не‑скроллящегося потомка скроллящимся (через SingleChildScrollView).
class PullToRefresh extends StatelessWidget {
  const PullToRefresh.child({
    required this.onRefresh,
    required this.child,
    super.key,
    this.edgeOffset = 12,
    this.displacement = 48,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 2.0,
    this.notificationPredicate = defaultScrollNotificationPredicate,
  });

  PullToRefresh.box({
    required this.onRefresh,
    required Widget child,
    super.key,
    this.edgeOffset = 12,
    this.displacement = 48,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 2.0,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    EdgeInsetsGeometry padding = const EdgeInsets.only(
      bottom: 1,
    ), // чтобы AlwaysScrollable работал
  }) : child = SingleChildScrollView(
         physics: const AlwaysScrollableScrollPhysics(
           parent: BouncingScrollPhysics(),
         ),
         padding: padding,
         child: child,
       );

  final Future<void> Function() onRefresh;
  final Widget child;

  /// Материальные настройки
  final double edgeOffset;
  final double displacement;
  final Color? color;
  final Color? backgroundColor;
  final double strokeWidth;
  final ScrollNotificationPredicate notificationPredicate;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    edgeOffset: edgeOffset,
    displacement: displacement,
    color: color,
    backgroundColor: backgroundColor,
    strokeWidth: strokeWidth,
    notificationPredicate: notificationPredicate,
    child: child,
  );
}

/// Купертиновый вариант для sliver‑экранов.
class CupertinoPullToRefreshSliver extends StatelessWidget {
  const CupertinoPullToRefreshSliver({required this.onRefresh, super.key});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) =>
      CupertinoSliverRefreshControl(onRefresh: onRefresh);
}
