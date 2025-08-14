import 'dart:async';

import 'package:ignitor/src/common/util/logger_util.dart';
import 'package:ignitor/src/common/util/platform_util.dart';
import 'package:l/l.dart';

/// Catch all application errors and logs.
void appZone(FutureOr<void> Function() fn) => l.capture<void>(
  () => runZonedGuarded<void>(fn, l.e),
  LogOptions(
    handlePrint: false,
    messageFormatting: LoggerUtil.messageFormatting,
    outputInRelease: false,
    printColors: PlatformUtil.isAndroid || PlatformUtil.isWindows || PlatformUtil.isWeb,
  ),
);
