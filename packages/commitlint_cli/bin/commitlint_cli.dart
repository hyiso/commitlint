import 'dart:io';

import 'package:args/args.dart';
import 'package:commitlint_format/commitlint_format.dart';
import 'package:commitlint_lint/commitlint_lint.dart';
import 'package:commitlint_load/commitlint_load.dart';
import 'package:commitlint_read/commitlint_read.dart';
import 'package:commitlint_types/commitlint_types.dart';

Future<void> main(List<String> args) async {
  final argParser = ArgParser()
    ..addOption('config',
        help: 'path to the config file')
    ..addOption('edit',
        help: 'read last commit message from the specified file (default to .git/COMMIT_EDITMSG)')
    ..addFlag('input',
        help: 'read commit message from input')
    ..addOption('from',
        help: 'lower end of the commit range to lint; applies if edit=false')
    ..addOption('to',
        help: 'upper end of the commit range to lint; applies if edit=false');
  final argResults = argParser.parse(args);

  final from = argResults['from'] as String?;
  final to = argResults['to'] as String?;
  final edit = argResults['edit'] as String?;
  final input  = argResults['input'] as bool?;
  bool fromStdin = from == null && to == null && edit == null && input == true;
  final messages = fromStdin
      ? await _stdin()
      : await read(from: from, to: to, edit: edit ?? '.git/COMMIT_EDITMSG');
  final rules = await load(LoadOptions(cwd: Directory.current.path, file: 'commitlint.yaml'));
  final results = (await Future.wait(
    messages.map((message) async => await lint(message, rules))
  ));
  if (rules.isEmpty) {
		var input = '';

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
    (info, result) {
      return info + result;
    }
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