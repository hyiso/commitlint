/// Read commit messages
/// This is used by commitlint_cli
library commitlint_read;

import 'dart:io';

import 'package:path/path.dart';

/// Read commit messages in given range([from], [to]),
///  or in [edit] file.
/// Return commit messages list.
Future<Iterable<String>> read({
  String? from,
  String? to,
  String? edit,
  String? workingDirectory,
  Iterable<String>? gitLogArgs,
}) async {
  if (edit != null) {
    return await _getEditingCommit(
        edit: edit, workingDirectory: workingDirectory);
  }
  final range = [if (from != null) from, to ?? 'HEAD'].join('..');
  return _getRangeCommits(
    gitLogArgs: ['--format=%B', range, ...?gitLogArgs],
    workingDirectory: workingDirectory,
  );
}

Future<Iterable<String>> _getRangeCommits({
  required Iterable<String> gitLogArgs,
  String? workingDirectory,
}) async {
  final result = await Process.run(
    'git',
    ['log', ...gitLogArgs],
    workingDirectory: workingDirectory,
  );
  return ((result.stdout as String).trim().split('\n'))
      .where((message) => message.trim().isNotEmpty)
      .toList();
}

Future<Iterable<String>> _getEditingCommit({
  required String edit,
  String? workingDirectory,
}) async {
  final result = await Process.run(
    'git',
    ['rev-parse', '--show-toplevel'],
    workingDirectory: workingDirectory,
  );
  final root = result.stdout.toString().trim();
  final file = File(join(root, edit));
  if (await file.exists()) {
    return [await file.readAsString()];
  }
  return [];
}
