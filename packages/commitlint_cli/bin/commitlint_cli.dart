import 'dart:io';

import 'package:args/args.dart';
import 'package:collection/collection.dart';
import 'package:commitlint_format/commitlint_format.dart';
import 'package:commitlint_lint/commitlint_lint.dart';
import 'package:commitlint_load/commitlint_load.dart';
import 'package:commitlint_read/commitlint_read.dart';
import 'package:commitlint_types/commitlint_types.dart';

void main(List<String> args) async {
  final argParser = ArgParser()
    ..addOption('config',
        abbr: 'g',
        help: 'path to the config file')
    ..addOption('cwd',
        abbr: 'd',
        defaultsTo: Directory.current.path,
        help: 'directory to execute in')
    ..addOption('edit',
        abbr: 'e',
        help: 'read last commit message from the specified file or fallbacks to ./.git/COMMIT_EDITMSG')
    ..addOption('from',
        abbr: 'f',
        defaultsTo: null,
        help: 'lower end of the commit range to lint; applies if edit=false')
    ..addOption('to',
        abbr: 't',
        defaultsTo: null,
        help: 'upper end of the commit range to lint; applies if edit=false');
  final argResults = argParser.parse(args);

  final from = argResults['from'] as String?;
  final to = argResults['to'] as String?;

  final messages = await read(from: from, to: to);
  final rules = await load(LoadOptions(cwd: Directory.current.path, file: 'commitlint.yaml'));
  final results = (await Future.wait(
    messages.map((message) => lint(message, rules))
  )).whereNotNull().toList();
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
                '  - Getting started guide: ',
                '  - Example config: ',
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
}
