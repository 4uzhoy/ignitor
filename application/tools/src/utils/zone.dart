import 'dart:async';

import 'package:l/l.dart';

import 'logger_util.dart';

/// Catch all application errors and logs.
void appZone(FutureOr<void> Function() fn) => l.capture<void>(
      () => runZonedGuarded<void>(fn, l.e),
      const LogOptions(
        handlePrint: false,
        messageFormatting: LoggerUtil.messageFormatting,
        outputInRelease: false,
        printColors: true,
      ),
    );
