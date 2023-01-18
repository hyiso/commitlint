import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:commitlint_cli/src/version.g.dart';
import 'package:commitlint_format/commitlint_format.dart';
import 'package:commitlint_lint/commitlint_lint.dart';
import 'package:commitlint_load/commitlint_load.dart';
import 'package:commitlint_read/commitlint_read.dart';
import 'package:commitlint_types/commitlint_types.dart';

class CommitLintRunner extends CommandRunner {
  CommitLintRunner()
      : super('commitlint', 'commitlint - Lint commit messages') {
    argParser
      ..addOption('config',
          defaultsTo: 'commitlint.yaml', help: 'path to the config file')
      ..addOption('edit',
          help: 'read last commit message from the specified file.')
      ..addOption('from',
          help:
              'lower end of the commit range to lint. This is succeeded to --edit')
      ..addOption('to',
          help:
              'upper end of the commit range to lint. This is succeeded to --edit')
      ..addFlag('version',
          negatable: false, help: 'display version information');
  }

  @override
  String get invocation => '$executableName [arguments]\n\n'
      '[input] reads from stdin if --edit, --from and --to are omitted';

  @override
  Future<void> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults['version'] == true) {
      stderr.writeln('commitlint@$kCurrentVersion');
      return;
    }
    if (topLevelResults.arguments.contains('-h') ||
        topLevelResults.arguments.contains('--help')) {
      printUsage();
      return;
    }
    final from = topLevelResults['from'] as String?;
    final to = topLevelResults['to'] as String?;
    final edit = topLevelResults['edit'] as String?;
    bool fromStdin = from == null && to == null && edit == null;
    final messages =
        fromStdin ? await _stdin() : await read(from: from, to: to, edit: edit);
    final rules = await load(file: topLevelResults['config']);
    final results = (await Future.wait(
        messages.map((message) async => await lint(message, rules))));
    if (rules.isEmpty) {
      String input = '';
      if (results.isNotEmpty) {
        input = results.first.input;
      }
      results.replaceRange(0, results.length, [
        LintOutcome(
          input: input,
          valid: false,
          errors: [
            LintRuleOutcome(
              level: RuleConfigSeverity.error,
              valid: false,
              name: 'empty-rules',
              message: [
                'Please add rules to your \'commitlint.yaml\'',
                '   - Example config: https://github.com/hyiso/commitlint/blob/main/commitlint.yaml',
              ].join('\n'),
            )
          ],
          warnings: [],
        )
      ]);
    }
    final report = results.fold<FormattableReport>(
      FormattableReport.empty(),
      (info, result) => info + result,
    );
    final output = format(report: report);
    stderr.write(output);
    if (!report.valid) {
      exit(1);
    }
  }

  Future<Iterable<String>> _stdin() async {
    final input = stdin.readLineSync();
    if (input != null) {
      return [input];
    }
    return [];
  }
}
