import 'dart:async';

import 'package:common/src/util/logger_util.dart';
import 'package:common/src/util/platform_util.dart';
import 'package:l/l.dart';

/// Catch all application errors and logs.
void appZone(FutureOr<void> Function() fn) => l.capture<void>(
  () => runZonedGuarded<void>(fn, l.e),
  LogOptions(
    handlePrint: false,
    messageFormatting: LoggerUtil.messageFormatting,
    outputInRelease: false,
    printColors:
        PlatformUtil.isAndroid || PlatformUtil.isWindows || PlatformUtil.isWeb,
  ),
);
