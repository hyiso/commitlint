import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';
import 'package:commitlint_read/commitlint_read.dart';
import 'package:conventional_commit/conventional_commit.dart';

class LintCommand extends Command {
  @override
  String get description => 'Lint commit messages.';

  @override
  String get name => 'lint';

  @override
  Future<void> run() async {
    final from = globalResults!['from'] as String?;
    final to = globalResults!['to'] as String?;

    final commitMessages = await read(from: from, to: to);

    final commits = commitMessages
        .map((commitMessage) {
          return  ConventionalCommit.tryParse(commitMessage);

        })
        .whereNotNull()
        .toList();
  }

}