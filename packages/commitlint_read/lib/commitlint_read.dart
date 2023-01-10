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
  String edit = './.git/COMMIT_EDITMSG'
}) async {
  if (from == null && to == null) {
    return await _getEditingCommit();
  }
  return _getRangeCommits(from, to);

}

Future<Iterable<String>> _getRangeCommits(String? from, String? to) async {
  final range = [
    if (from != null) from,
    to ?? 'HEAD'
  ].join('..');
  final result = await Process.run(
    'git',
    ['log', '--format=%B', range],
  );
  return ((result.stdout as String).trim().split('\n'))
      .where((message) => message.trim().isNotEmpty)
      .toList();
}

Future<Iterable<String>> _getEditingCommit() async {
  final result = await Process.run(
    'git',
    ['rev-parse', '--show-toplevel'],
  );
  final root = result.stdout.toString().trim();
  final msgFile = File(join(root, '.git', 'COMMIT_EDITMSG'));

  if (await msgFile.exists()) {
    return await msgFile.readAsLines();
  }
  return [];
}