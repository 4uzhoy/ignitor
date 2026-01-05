import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:l/l.dart';
import 'package:path/path.dart' as p;

export 'package:path/path.dart';

const projectName = 'application';
const toolsName = 'tools';

/// Получить директорию проекта
Directory getProjectDir({bool toolsWorkspace=false}) {
  final project = toolsWorkspace ? toolsName : projectName;
  final scriptDir = Directory.current;
  final r = p.split(scriptDir.path);
  if (!r.contains(project)) {
    throw ArgumentError(
      'The project name variable is incorrectly set '
      '"$project", missing in the path $scriptDir',
    );
  }
  final takeWhile = r.take(r.indexOf(project) + 1);
  final projectDirPath = p.joinAll(takeWhile);
  return Directory(projectDirPath);
}

FutureOr<ProcessResult>? cmd(String executable, List<String> arguments,
    {String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    Encoding? stdoutEncoding = systemEncoding,
    Encoding? stderrEncoding = systemEncoding,
    bool printOutput = true}) async {
  final workDir = workingDirectory ?? getProjectDir().path;
  l.i('[PROCESSING] $workDir>$executable ${arguments.join(' ')} ...');
  final result = await Process.run(
    executable,
    arguments,
    workingDirectory: workDir,
    runInShell: true,
    stdoutEncoding: stdoutEncoding,
    stderrEncoding: stderrEncoding,
    includeParentEnvironment: includeParentEnvironment,
    environment: environment,
  );
  if (result.exitCode != 0) {
    l.e('[ERROR] $executable ${arguments.join(' ')}');
    l.e(result.stderr.toString());
    exit(1);
  } else {
    if (printOutput) {
      l.i(result.stdout.toString());
      l.i('[COMPLETED] $executable ${arguments.join(' ')}');
    } else {
      return result;
    }
  }
  return result;
}

ProcessResult? cmdSync(String executable, List<String> arguments,
    {String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    Encoding? stdoutEncoding = systemEncoding,
    Encoding? stderrEncoding = systemEncoding,
    bool printOutput = true}) {
  final workDir = workingDirectory ?? getProjectDir().path;
  l.i('[PROCESSING] $executable ${arguments.join(' ')} ...');
  final result = Process.runSync(
    executable,
    arguments,
    workingDirectory: workDir,
    runInShell: true,
    stdoutEncoding: stdoutEncoding,
    stderrEncoding: stderrEncoding,
    includeParentEnvironment: includeParentEnvironment,
    environment: environment,
  );
  if (result.exitCode != 0) {
    l.e('[ERROR] $executable ${arguments.join(' ')}');
    exit(1);
  } else {
    if (printOutput) {
      l.i(result.stdout.toString());
      l.i('[COMPLETED] $executable ${arguments.join(' ')}');
    } else {
      return result;
    }
  }
  return null;
}

void executer(List<Function> functions) {
  for (var function in functions) {
    try {
      function();
    } catch (e) {
      l.e(e);
      exit(1);
    }
  }
}
