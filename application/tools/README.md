# 🛠️ FielMa Build Tools

Автоматизация сборки и релиза приложения FielMa.

## 🎯 Цель

**Одна команда = полный релиз**:
- ✅ Повышение build number (pubspec, iOS, Android)
- ✅ Кодогенерация (build_runner)
- ✅ Сборка AAB для Google Play
- ✅ Отправка changelog в Telegram
- 🔄 Загрузка в Google Play (когда будет готов)

## 🚀 Быстрый старт

### 1. Установка зависимостей

```bash
cd application/tools
dart pub get
```

### 2. Добавить flutter.versionCode в local.properties

```properties
# application/android/local.properties
flutter.versionCode=1
```

### 3. Запуск релиза

```bash
# Простой запуск:
dart run run/release.dart

# С Telegram уведомлениями:
dart run --define=TELEGRAM_BOT_TOKEN=your_token --define=TELEGRAM_CHAT_ID=your_chat_id run/release.dart
```

## 📁 Структура

```
tools/
├── run/
│   ├── release.dart           # ⭐ Главная точка входа
│   ├── git_history.dart
│   └── collect_strings.dart
│
├── src/
│   ├── base/
│   │   ├── scenario.dart      # Базовый сценарий
│   │   └── script_stage.dart  # Базовый этап
│   │
│   ├── scenario/              # Сценарии
│   │   ├── bump_build_number_scenario.dart  # Bump версии
│   │   ├── build_aab_scenario.dart          # Сборка AAB
│   │   ├── push_changelog_scenario.dart     # Telegram
│   │   └── upload_google_play_scenario.dart # Google Play
│   │
│   ├── utils/                 # Утилиты
│   │   ├── utils.dart         # cmd, getProjectDir
│   │   ├── git.dart           # Git операции
│   │   └── zone.dart          # Error handling
│   │
│   └── common_stage.dart      # Общие этапы
│
└── commands/                  # Bash скрипты
```

## 🎭 Как это работает

### release.dart - последовательный запуск сценариев

```dart
void main() => appZone(() async {
  final scenarioContext = <String, Object>{};
  
  // 1. Bump build number
  await BumpBuildNumberScenario(scenarioContext: scenarioContext).execute();
  
  // 2. Build AAB
  await BuildAabScenario(scenarioContext: scenarioContext).execute();
  
  // 3. Send to Telegram
  await PushChangelogScenario(scenarioContext: scenarioContext).execute();
});
```

**Почему так?** Context передается между сценариями. Каждый сценарий - это группа стейджей:

### BumpBuildNumberScenario
1. UpdatePubspecStage - обновляет pubspec.yaml
2. UpdateProjectPbxprojStage - обновляет iOS версию
3. UpdateLocalPropertiesStage - обновляет Android версию
4. CodgenStage - запускает build_runner

### BuildAabScenario
1. ReadPubspecStage - читает версию
2. BuildAabStage - собирает AAB

### PushChangelogScenario
1. ReadPubspecStage - читает версию
2. ReadChangelogStage - читает changelog для версии
3. SendTelegramMessageStage - отправляет в Telegram

## 📝 Формат CHANGELOG

```markdown
## 📅 FielMa [0.0.2] 11.12.2025
🔗 [Google Play Internal Testing](https://play.google.com/apps/internaltest/...)

#### 🧷 `Краткое описание`
Добавлена синхронизация

#### 🔄 `Обновления`
- Pull синхронизация для смен
- Push синхронизация с статусами

#### 🛠️ `Исправления`
- Исправлена обработка ошибок
---
```

**Важно**:
- Версия должна быть в формате `[major.minor.patch]`
- Завершать разделителем `---`
- Скрипт парсит содержимое между версией и `---`

## 🔧 Конфигурация

### Требуемые файлы

1. **config/development.json** - конфиг для Flutter build
2. **android/local.properties** - должен содержать:
   ```properties
   flutter.versionCode=1
   flutter.versionName=0.0.1
   ```

### Telegram (опционально)

```bash
# Передавать через --define при запуске:
dart run \
  --define=TELEGRAM_BOT_TOKEN=your_token \
  --define=TELEGRAM_CHAT_ID=your_chat_id \
  run/release.dart
```

## 🐛 Устранение проблем

### "Version not found in CHANGELOG"
Добавь версию в CHANGELOG.md:
```markdown
## 📅 FielMa [0.0.1]
#### 🧷 `Initial`
---
```

### "flutter.versionCode not found"
Добавь в `android/local.properties`:
```properties
flutter.versionCode=1
```

### "TELEGRAM_BOT_TOKEN not set"
Скрипт продолжит работу, просто пропустит отправку в Telegram.

## 🎓 Архитектура

### Scenario Pattern

```dart
abstract class Scenario {
  String get name;
  List<ScriptStage> get stages;
  Future<void> execute({bool dryRun});
}
```

### Stage Pattern

```dart
abstract class ScriptStage {
  final ScenarioContext scenarioContext;
  Future<bool> run({bool dryRun});
  void saveToContext(String key, Object value);
  T getOrFail<T>(String key);
}
```

### Context Flow

```
Stage 1 → context['versionName'] = '0.0.1'
Stage 2 → versionName = context['versionName'] ✓
Stage 3 → uses versionName
```

## ✨ Что дальше

- [ ] Git commit & push после bump
- [ ] Upload в Google Play (когда будет ключ)
- [ ] Обновление CHANGELOG со ссылкой на Google Play
- [ ] Upload в App Store (IPA)
