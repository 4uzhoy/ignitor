import 'dart:async';
import 'dart:io';

import 'package:ignitor/src/common/util/logger_util.dart';
import 'package:l/l.dart';

/// Catch all application errors and logs.
void appZone(FutureOr<void> Function() fn) => l.capture<void>(
  () => runZonedGuarded<void>(fn, l.e),
  LogOptions(
    handlePrint: false,
    messageFormatting: LoggerUtil.messageFormatting,
    outputInRelease: false,
    printColors: Platform.isAndroid || Platform.isWindows,
  ),
);
