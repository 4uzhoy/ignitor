import 'dart:ui';
import 'package:flutter/material.dart';

/// A lightweight **loading overlay** with:
/// - click blocking via [AbsorbPointer] while loading,
/// - background blur via [BackdropFilter],
/// - smooth appear/disappear animation via [AnimatedSwitcher],
/// - optional dimmed barrier,
/// - pluggable indicator (defaults to `CircularProgressIndicator.adaptive()`).
///
/// Place it anywhere you need to cover existing UI during async work.
/// The overlay occupies the full size of its parent using a `Stack`.
///
/// ### Example
/// ```dart
/// LoadingOverlay(
///   inProgress: state is Loading,
///   barrierColor: Colors.black.withOpacity(.06),
///   child: YourPageBody(),
/// )
/// ```
///
/// ### Notes
/// - `absorb: true` blocks interactions while loading.
/// - `blurSigma` controls the strength of the Gaussian blur.
/// - Wraps the indicator in `RepaintBoundary` to minimize repaints.
final class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.child,
    required this.inProgress,
    this.indicator,
    this.duration = const Duration(milliseconds: 350),
    this.blurSigma = 4,
    this.absorb = true,
    this.barrierColor,
    this.alignment = Alignment.center,
    this.switchInCurve = Curves.easeOutCubic,
    this.switchOutCurve = Curves.easeInCubic,
    this.semanticLabel = 'Loading',
  });

  /// Content underneath the overlay.
  final Widget child;

  /// Whether the overlay is visible and interactions are blocked.
  final bool inProgress;

  /// Custom progress indicator. Defaults to `CircularProgressIndicator.adaptive()`.
  final Widget? indicator;

  /// Animation duration for showing/hiding the overlay.
  final Duration duration;

  /// Gaussian blur sigma for both X and Y axes.
  final double blurSigma;

  /// If `true`, taps/gestures are absorbed while loading.
  final bool absorb;

  /// Optional dimming color over the blurred content.
  final Color? barrierColor;

  /// Alignment for the indicator inside the overlay.
  final AlignmentGeometry alignment;

  /// Curves for switcher animation.
  final Curve switchInCurve;
  final Curve switchOutCurve;

  /// Accessibility label exposed while loading.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Main content
        Positioned.fill(child: child),

        // Loading overlay
        Positioned.fill(
          child: AbsorbPointer(
            absorbing: absorb && inProgress,
            child: AnimatedSwitcher(
              duration: duration,
              switchInCurve: switchInCurve,
              switchOutCurve: switchOutCurve,
              layoutBuilder:
                  (currentChild, previousChildren) => Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  ),
              child:
                  inProgress
                      ? ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: blurSigma,
                            sigmaY: blurSigma,
                          ),
                          child: ColoredBox(
                            color: barrierColor ?? Colors.transparent,
                            child: Align(
                              alignment: alignment,
                              child: Semantics(
                                label: semanticLabel,
                                liveRegion: true,
                                // Rebuild only the indicator while animating.
                                child: RepaintBoundary(
                                  child:
                                      indicator ??
                                      const SizedBox(
                                        height: 36,
                                        width: 36,
                                        child:
                                            CircularProgressIndicator.adaptive(
                                              strokeWidth: 3,
                                            ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}
