import 'dart:io';

import 'package:client/client.dart';
import 'package:dio/dio.dart' as dio;

/// Checks the [dio.DioException] and tries to parse it.
Object? checkDioException(dio.DioException e) => switch (e) {
      final SocketException socketException => ConnectionException(
          message: socketException.message,
          cause: socketException,
        ),
      _ => null,
    };
