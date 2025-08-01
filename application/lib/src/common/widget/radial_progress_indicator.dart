import 'dart:math' as math;

import 'package:flutter/material.dart';

/// {@template radial_progress_indicator}
/// RadialProgressIndicator widget
/// {@endtemplate}
class RadialProgressIndicator extends StatefulWidget {
  /// {@macro radial_progress_indicator}
  const RadialProgressIndicator({
    this.size = 64,
    this.child,
    this.isCompleted = false,
    super.key,
  });

  /// The size of the progress indicator
  final double size;
  final bool isCompleted;

  /// The child widget
  final Widget? child;

  @override
  State<RadialProgressIndicator> createState() => _RadialProgressIndicatorState();
}

class _RadialProgressIndicatorState extends State<RadialProgressIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _sweepController;
  late final Animation<double> _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _curvedAnimation = CurvedAnimation(
      parent: _sweepController,
      curve: Curves.ease,
    );

    if (!widget.isCompleted) {
      _sweepController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant RadialProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted) {
      _sweepController.stop();
    } else {
      _sweepController.repeat();
    }
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox.square(
          dimension: widget.size,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _RadialProgressIndicatorPainter(
                animation: _curvedAnimation,
                color: Theme.of(context).primaryColor,
                isCompleted: widget.isCompleted,
              ),
              child: Center(
                child: widget.child,
              ),
            ),
          ),
        ),
      );
}

class _RadialProgressIndicatorPainter extends CustomPainter {
  _RadialProgressIndicatorPainter({
    required Animation<double> animation,
    required bool isCompleted,
    Color color = Colors.red,
  })  : _isCompleted = isCompleted,
        _animation = animation,
        _arcPaint = Paint()
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..color = color,
        super(repaint: animation);

  final Animation<double> _animation;
  final Paint _arcPaint;
  final bool _isCompleted;
  @override
  void paint(Canvas canvas, Size size) {
    _arcPaint.strokeWidth = size.shortestSide / 32;

    if (_isCompleted) {
      canvas.drawCircle(
        size.center(Offset.zero),
        size.shortestSide / 2 - _arcPaint.strokeWidth / 2,
        _arcPaint,
      );
      return;
    } else {
      final progress = _animation.value;
      final rect = Rect.fromCircle(
        center: size.center(Offset.zero),
        radius: size.shortestSide / 2 - _arcPaint.strokeWidth / 2,
      );
      final rotate = math.pow(progress, 2) * math.pi * 2;
      final sweep = math.sin(progress * math.pi) * 3 + math.pi * .25;

      canvas.drawArc(rect, rotate, sweep, false, _arcPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadialProgressIndicatorPainter oldDelegate) =>
      _animation.value != oldDelegate._animation.value;

  @override
  bool shouldRebuildSemantics(covariant _RadialProgressIndicatorPainter oldDelegate) => false;
}
