import 'package:flutter/foundation.dart';

abstract class PlatformUtil {
  const PlatformUtil._();

  static bool get isWeb => kIsWeb;

  static bool get isMobile => !isWeb && (isAndroid || isIOS);

  static bool get isDesktop => !isWeb && !isMobile;

  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  static bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;

  static bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;

  static bool get isLinux => defaultTargetPlatform == TargetPlatform.linux;
}
