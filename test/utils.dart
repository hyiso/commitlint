import 'dart:io';
import 'package:path/path.dart';

String tmp() => join(Directory.systemTemp.path, 'tmp',
    'commitlint_test_${DateTime.now().millisecondsSinceEpoch}');

Future<String> bootstrap([String? fixture, String? directory]) async {
  final dir = tmp();
  await init(dir);
  await config(dir);
  return dir;
}

Future<void> init(String dir) async {
  await Process.run('git', ['init', dir]);
}

Future<void> config(String dir) async {
  await Process.run('git', ['config', 'user.name', 'ava'],
      workingDirectory: dir);
  await Process.run('git', ['config', 'user.email', 'test@example.com'],
      workingDirectory: dir);
  await Process.run('git', ['config', 'commit.gpgsign', 'false'],
      workingDirectory: dir);
}
