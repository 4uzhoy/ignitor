/// Config for app.
library;
// ignore_for_file: doc_directive_unknown

abstract final class Config {
  Config._();


  static final EnvironmentFlavor environment = EnvironmentFlavor.from(
    const String.fromEnvironment('ENVIRONMENT', defaultValue: 'development'),
  );

  // ===== API =====
  static const bool apiLogRequestHeader = bool.fromEnvironment('API_LOG_HEADER', defaultValue: false);
  static const bool apiLogResponseHeader = bool.fromEnvironment('API_LOG_RESPONSE_HEADER', defaultValue: false);
  static const bool apiLogError = bool.fromEnvironment('API_LOG_ERROR', defaultValue: true);
  static const bool apiLogRequestBody = bool.fromEnvironment('API_LOG_REQUEST_BODY', defaultValue: false);
  static const bool apiLogResponseBody = bool.fromEnvironment('API_LOG_RESPONSE_BODY', defaultValue: false);


  // ===== Database =====

  static const bool dropDatabase = bool.fromEnvironment('DROP_DATABASE', defaultValue: false);

  static const bool enableDbLog = bool.fromEnvironment('DB_LOG', defaultValue: true);

 // ===== Telegram ===== 
 
 /// @{template telegram_config}
 /// 
 /// * Section for Telegram bot configuration
 /// 
 /// * [TelegramBot] - Telegram bot configuration
 /// * [TelegramChat] - Telegram chat configuration
 /// 
 /// @{endtemplate}
  static const String telegramBotToken = String.fromEnvironment('TELEGRAM_BOT_TOKEN', defaultValue: 'none-provided');
  /// @{macro telegram_config}
  static const String telegramChatId = String.fromEnvironment('TELEGRAM_CHAT_ID', defaultValue: 'none-provided');

  // ==== AI =====
  static const String openAIApiKey = String.fromEnvironment('OPENAI_API_KEY', defaultValue: 'none-provided');


 // ===== Developer ===== 
    static  bool developerMode = const bool.fromEnvironment('DEVELOPER_MODE', defaultValue: false);
}



/// Environment flavor.
/// e.g. development, staging, production
enum EnvironmentFlavor {
  /// Development
  development('development'),

  /// Staging
  staging('staging'),

  /// Production
  production('production');


  /// {@nodoc}
  const EnvironmentFlavor(this.value);

  /// {@nodoc}
  factory EnvironmentFlavor.from(String? value) => switch (value?.trim().toLowerCase()) {
        'development' || 'debug' || 'develop' || 'dev' => development,
        'staging' || 'profile' || 'stage' || 'stg' => staging,
        'production' || 'release' || 'prod' || 'prd' => production,
        _ => const bool.fromEnvironment('dart.vm.product') ? production : development,
      };
      
   String get shortName => switch (this) {
    EnvironmentFlavor.development => 'dev',
    EnvironmentFlavor.staging => 'stg',
    EnvironmentFlavor.production => 'prod',
  };

  /// development, staging, production
  final String value;

  /// Whether the environment is development.
  bool get isDevelopment => this == development;

  /// Whether the environment is staging.
  bool get isStaging => this == staging;

  /// Whether the environment is production.
  bool get isProduction => this == production;

}
