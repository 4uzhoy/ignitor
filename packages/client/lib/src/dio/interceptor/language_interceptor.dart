import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

/// {@category locale}
/// {@template language_interceptor}
/// Abstraction for obtaining the locale information.
///
/// This should be implemented in the application to allow the client to access the current locale.
///
/// From [Locale] returned by `getLocale`, the `languageCode` will be extracted.
///
/// From [Locale] returned by `getRegion`, the `countryCode` will be extracted.
///
/// These are separated into two methods to allow use of just the `languageCode` if needed.
///
/// `languageCode`:
/// * Represents the language, e.g., `ru`, `en`, `fr`, etc.
/// * Determines the **language** in which content is displayed.
/// * See: [ISO 639 language codes](https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes)
///
/// `countryCode`:
/// * Represents the region/country, e.g., `RU`, `US`, `FR`, etc.
/// * Determines the **format** of content (e.g., date, currency, etc.).
/// * May also affect **content availability** (e.g., products, services).
/// * `countryCode` may be `null` if the locale doesn't specify a region.
///   If `null`, an empty string will be sent in the request header.
/// * See: [ISO 3166-1 alpha-2 country codes](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
///
/// Examples:
///
///   For Kazakhstan, if Russian localization is selected,
///   `languageCode` will be `ru` and `countryCode` will be `KZ`.
///
///   If Kazakh localization is selected,
///   `languageCode` will be `kk` and `countryCode` will be `KZ`.
/// {@endtemplate}
abstract interface class LocaleStore {
  /// Returns the current language locale.
  /// Example: Locale('kk')
  Locale? getLocale();

  /// Returns the full locale with region.
  /// Example: Locale('kk', 'KZ')
  Locale? getRegion();

  /// Optional helper: determine if user is in a delivery region.
  /// bool get isInDeliveryRegion => getLocale().countryCode == 'KZ';
}

/// {@macro language_interceptor}
class LanguageInterceptor extends InterceptorsWrapper {
  /// {@macro language_interceptor}
  LanguageInterceptor({required this.localeStore});

  final LocaleStore localeStore;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final locale = localeStore.getLocale();
    final region = localeStore.getRegion();
    options.headers['Accept-Language'] = locale?.languageCode;
    options.headers['X-App-Language-Code'] = locale?.languageCode;
    options.headers['X-App-Country-Code'] = region?.countryCode ?? '';
    handler.next(options);
  }
}
