import 'dart:io';

import 'utils.dart';

void gitPorcelain() {
  final result = cmdSync('git', ['status', '--porcelain']);
  if (result?.stdout.toString().isNotEmpty ?? false) {
    print('Git repository is dirty. Please commit or stash your changes.');
    exit(1);
  }
}

void gitCommit(String message) {
  cmdSync('git', ['add', '.']);
  cmdSync('git', ['commit', '-m', message]);
}

void gitPull() => cmdSync('git', ['pull']);

void gitPush() => cmdSync('git', ['push']);
