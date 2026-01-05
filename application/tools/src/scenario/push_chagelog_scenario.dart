import 'dart:io';

import 'package:l/l.dart';
import 'package:tinygram/tinygram.dart';

import '../base/scenario.dart';
import '../base/script_stage.dart';
import '../common_stage.dart';
import '../utils/utils.dart';

final class PushChagelogScenario extends Scenario {
  PushChagelogScenario({required super.scenarioContext});

  @override
  String get name => 'Push Changelog to Telegram';

  @override
  List<ScriptStage> get stages => [
        ReadPubspecStage(scenarioContext: scenarioContext),
        ReadConfigStage(scenarioContext: scenarioContext),
        ReadChangelogStage(scenarioContext: scenarioContext),
        SendTelegramMessageStage(scenarioContext: scenarioContext),
        SendTelegramApkStage(scenarioContext: scenarioContext),
      ];
}

/// Отправка changelog в Telegram (только текст)
final class SendTelegramMessageStage extends ScriptStage$Base {
  SendTelegramMessageStage({required super.scenarioContext}) : super('Send to Telegram');

  // Telegram limit: 4096 символов на сообщение
  static const int _telegramMaxLength = 4096;

  @override
  Future<bool> run({bool dryRun = true}) async {
    final versionName = getOrFail<String>('versionName');
    final buildNumber = getOrFail<String>('buildNumber');
    final changelogString = getOrFail<String>('changelogString');

    // Читаем токен и chatId из config
    final config = scenarioContext['config'] as Map<String, dynamic>?;
    final token = config?['RELEASER_BOT_TOKEN'] as String? ?? '';
    final chatId = config?['RELEASER_CHAT_ID'] as String? ?? '';

    if (token.isEmpty || chatId.isEmpty) {
      l.w('⚠️ RELEASER_BOT_TOKEN или RELEASER_CHAT_ID не найдены в .config/development.json');
      return false;
    }

    final header =
        '🚀 FielMa $versionName ($buildNumber)\n🔗 [Ссылка на Google Play Internal Testing](https://play.google.com/apps/internaltest/4701366770659877207)\n\n';
    final footer = '';

    // Разбиваем changelog на части
    final messages = _splitMessage(changelogString, header, footer);

    if (dryRun) {
      l.v('Dry run: would send ${messages.length} message(s) to Telegram');
      for (var i = 0; i < messages.length; i++) {
        l.v('--- Message ${i + 1}/${messages.length} (${messages[i].length} chars) ---');
        l.v(messages[i]);
      }
      return true;
    }

    try {
      final tgBot = TinygramBotImpl(token: token, chat: TinygramChat(chatId));

      for (var i = 0; i < messages.length; i++) {
        await tgBot.sendMessage(messages[i], formatMarkdown: true);
        l.i('✅ Часть ${i + 1}/${messages.length} отправлена');

        // Небольшая задержка между сообщениями
        if (i < messages.length - 1) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      l.i('✅ Все части changelog отправлены в Telegram');
      return true;
    } catch (e, st) {
      l.e('❌ Ошибка: $e');
      l.e('$st');
      return false;
    }
  }

  /// Разбивает changelog на части по границам секций
  List<String> _splitMessage(String changelog, String header, String footer) {
    // Оставляем запас для header и footer
    final maxContentLength = _telegramMaxLength - header.length - footer.length - 100;

    // Если влезает целиком - отправляем одним сообщением
    if (changelog.length <= maxContentLength) {
      return ['$header$changelog$footer'];
    }

    final messages = <String>[];
    final lines = changelog.split('\n');
    var currentChunk = StringBuffer();
    var currentLength = 0;

    for (final line in lines) {
      final lineLength = line.length + 1; // +1 для \n

      // Если добавление этой строки превысит лимит
      if (currentLength + lineLength > maxContentLength) {
        // Сохраняем текущий chunk
        if (currentChunk.isNotEmpty) {
          final isFirstMessage = messages.isEmpty;
          final messageHeader = isFirstMessage ? header : '';
          final messagePart = currentChunk.toString();

          messages.add('$messageHeader$messagePart');
          currentChunk.clear();
          currentLength = 0;
        }
      }

      currentChunk.writeln(line);
      currentLength += lineLength;
    }

    // Добавляем последний chunk
    if (currentChunk.isNotEmpty) {
      final isFirstMessage = messages.isEmpty;
      final messageHeader = isFirstMessage ? header : '';

      messages.add('$messageHeader$currentChunk$footer');
    } else if (messages.isNotEmpty) {
      // Добавляем footer к последнему сообщению
      messages[messages.length - 1] = '${messages.last}$footer';
    }

    return messages;
  }
}

/// Переименование APK файлов
final class RenameApkStage extends ScriptStage$Base {
  RenameApkStage({required super.scenarioContext}) : super('Rename APK files');

  @override
  Future<bool> run({bool dryRun = true}) async {
    final versionName = getOrFail<String>('versionName');
    final buildNumber = getOrFail<String>('buildNumber');
    final environment = 'development';

    final dir = getProjectDir(toolsWorkspace: false);
    final buildDir = '${dir.path}/build/app/outputs/apk/release';

    final arm64OriginalPath = '$buildDir/app-arm64-v8a-release.apk';
    final armeabiOriginalPath = '$buildDir/app-armeabi-v7a-release.apk';

    final arm64NewName = 'FielMa-$environment-$versionName+$buildNumber-arm64-v8a.apk';
    final armeabiNewName = 'FielMa-$environment-$versionName+$buildNumber-armeabi-v7a.apk';

    final arm64NewPath = '$buildDir/$arm64NewName';
    final armeabiNewPath = '$buildDir/$armeabiNewName';

    if (dryRun) {
      l.v('Dry run: would rename APK files');
      l.v('  $arm64OriginalPath -> $arm64NewName');
      l.v('  $armeabiOriginalPath -> $armeabiNewName');
      return true;
    }

    try {
      final arm64File = File(arm64OriginalPath);
      final armeabiFile = File(armeabiOriginalPath);

      if (!arm64File.existsSync() || !armeabiFile.existsSync()) {
        l.e('❌ APK файлы не найдены');
        return false;
      }

      await arm64File.rename(arm64NewPath);
      await armeabiFile.rename(armeabiNewPath);

      // Сохраняем пути в контекст для следующих стейджей
      scenarioContext['apkArm64Path'] = arm64NewPath;
      scenarioContext['apkArmeabiPath'] = armeabiNewPath;

      l.i('✅ APK файлы переименованы');
      l.i('  arm64: $arm64NewName');
      l.i('  armeabi: $armeabiNewName');

      return true;
    } catch (e, st) {
      l.e('❌ Ошибка переименования: $e');
      l.e('$st');
      return false;
    }
  }
}

/// Отправка APK в Telegram
final class SendTelegramApkStage extends ScriptStage$Base {
  SendTelegramApkStage({required super.scenarioContext}) : super('Send apk to Telegram');

  @override
  Future<bool> run({bool dryRun = true}) async {
    // Читаем токен и chatId из config
    final config = scenarioContext['config'] as Map<String, dynamic>?;
    final token = config?['RELEASER_BOT_TOKEN'] as String? ?? '';
    final chatId = config?['RELEASER_CHAT_ID'] as String? ?? '';

    if (token.isEmpty || chatId.isEmpty) {
      l.w('⚠️ RELEASER_BOT_TOKEN или RELEASER_CHAT_ID не найдены в .config/development.json');
      return false;
    }

    final apkArm64Path = getOrFail<String>('apkArm64Path');
    final apkArmeabiPath = getOrFail<String>('apkArmeabiPath');

    if (dryRun) {
      l.v('Dry run: would send APK files to Telegram');
      l.v('  $apkArm64Path');
      l.v('  $apkArmeabiPath');
      return true;
    }

    try {
      final tgBot = TinygramBotImpl(token: token, chat: TinygramChat(chatId));

      l.i('Отправка arm64 APK...');
      await tgBot.sendFile(File(apkArm64Path));
      l.i('✅ arm64 APK отправлен');

      await Future.delayed(const Duration(seconds: 1));

      l.i('Отправка armeabi APK...');
      await tgBot.sendFile(File(apkArmeabiPath));
      l.i('✅ armeabi APK отправлен');

      return true;
    } catch (e, st) {
      l.e('❌ Ошибка отправки APK: $e');
      l.e('$st');
      return false;
    }
  }
}
