import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:commitlint_cli/src/commands/lint.dart';

class CommitLintRunner extends CommandRunner {
  CommitLintRunner() : super('commitlint', 'Lint you commit messages') {
    argParser
    ..addFlag('color',
        abbr: 'c',
        defaultsTo: true,
        help: 'toggle colored output',
        negatable: true)
    ..addOption('config',
        abbr: 'g',
        help: 'path to the config file')
    ..addFlag('print-config',
        defaultsTo: false,
        help: 'print resolved config')
    ..addOption('cwd',
        abbr: 'd',
        defaultsTo: Directory.current.path,
        help: 'directory to execute in')
    ..addOption('edit',
        abbr: 'e',
        help: 'read last commit message from the specified file or fallbacks to ./.git/COMMIT_EDITMSG')
    ..addOption('env',
        abbr: 'E',
        help: 'check message in the file at path given by environment variable value')
    ..addMultiOption('extends',
        abbr: 'x',
        help: 'array of shareable configurations to extend')
    ..addOption('help-url',
        abbr: 'H',
        help: 'help url in error message')
    ..addOption('from',
        abbr: 'f',
        defaultsTo: null,
        help: 'lower end of the commit range to lint; applies if edit=false')
    ..addOption('to',
        abbr: 't',
        defaultsTo: null,
        help: 'upper end of the commit range to lint; applies if edit=false')
    ..addOption('git-log-args',
        help: "addditional git log arguments as space separated string, example '--first-parent --cherry-pick'")
    ..addOption('format',
        abbr: 'o',
        help: 'output format of the results')
    ..addFlag('quiet',
        abbr: 'q',
        help: 'toggle console output')
    ..addFlag('verbose',
        abbr: 'V',
        help: 'enable verbose output for reports without problems')
    ..addFlag('strict',
        abbr: 's',
        help: 'enable strict mode; result code 2 for warnings, 3 for errors');
    addCommand(LintCommand());
  }

  @override
  Future run(Iterable<String> args) {
    return super.run(args.isEmpty
      ? args
      : !commands.keys.contains(args.first)
          ? ['lint', ...args]
          : args);
  }

}