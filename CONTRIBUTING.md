# Contributing

Thank you for taking the time to contribute!

## Workflow

1. Install the latest versions of [Flutter](https://flutter.dev) and Dart.
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Format and lint the code:
   ```bash
   pre-commit run --all-files
   flutter analyze
   ```
4. Run the tests:
   ```bash
   dart test
   ```

The continuous integration workflow runs the same steps for every pull request.
