import 'package:l/l.dart';

import '../base/scenario.dart';
import '../base/script_stage.dart';

final class UploadGooglePlayScenario extends Scenario {
  UploadGooglePlayScenario({required super.scenarioContext});

  @override
  String get name => 'Upload Google Play';

  @override
  List<ScriptStage> get stages => [
        UploadGooglePlayStage(scenarioContext: scenarioContext),
        UpdateChangelogWithLinkStage(scenarioContext: scenarioContext),
      ];
}

final class UploadGooglePlayStage extends ScriptStage$Base {
  UploadGooglePlayStage({required super.scenarioContext}) : super('Upload Google Play');

  @override
  Future<bool> run({bool dryRun = true}) async {
    l.i('Upload AAB to Google Play Internal Testing');
    l.w('⚠️ TODO: Реализовать загрузку через Google Play API');
    l.w('Необходимо:');
    l.w('1. Создать Service Account в Google Cloud Console');
    l.w('2. Получить JSON ключ и сохранить в .key/google-play-api.json');
    l.w('3. Настроить Gradle Play Publisher или Fastlane');
    l.w('4. Uncomment код ниже');

    if (dryRun) {
      l.v('Dry run: would upload to Google Play');
      return true;
    }


    // final aabPath = '${getProjectDir(toolsWorkspace: false).path}/build/app/outputs/bundle/release/app-release.aab';
    // await cmd(
    //   './gradlew',
    //   ['publishReleaseBundle', '--track=internal'],
    //   workingDirectory: '${getProjectDir(toolsWorkspace: false).path}/android',
    // );

    // Mock: сохраняем фейковую ссылку для тестирования
    final mockUrl = 'https://play.google.com/apps/internaltest/xxxxxxx';
    saveToContext('googlePlayUrl', mockUrl);
    l.i('Google Play URL (mock): $mockUrl');

    return true;
  }
}

final class UpdateChangelogWithLinkStage extends ScriptStage$Base {
  UpdateChangelogWithLinkStage({required super.scenarioContext}) : super('Update CHANGELOG with Google Play link');

  @override
  Future<bool> run({bool dryRun = true}) async {
    final googlePlayUrl = scenarioContext['googlePlayUrl'] as String?;

    if (googlePlayUrl == null || googlePlayUrl.isEmpty) {
      l.w('Google Play URL not found in context');
      return false;
    }

    l.i('Adding Google Play link to CHANGELOG.md');

    if (dryRun) {
      l.v('Dry run: would add link $googlePlayUrl to CHANGELOG');
      return true;
    }


    // final changelog = File('${getProjectDir().path}/CHANGELOG.md');
    // final lines = changelog.readAsLinesSync();
    // final versionIndex = lines.indexWhere((l) => l.contains('[$versionName]'));
    // ... вставить строку с ссылкой перед ---

    return true;
  }
}
