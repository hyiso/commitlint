/// Support for doing something awesome.
///
/// More dartdocs go here.
library commitlint_lint;

import 'package:conventional_commit/conventional_commit.dart';

class Problem {
  final int level;
  final bool valid;
  final String name;
  final String message;

  Problem({
    required this.level,
    required this.valid,
    required this.name,
    required this.message,
  });
}

class Report {
  final bool valid;
  final List<Problem> errors;
  final List<Problem> warnings;

  Report({
    required this.valid,
    required this.errors,
    required this.warnings,
  });
}

Future<Report> lint(String message, Map<String, dynamic> rules) async {
  final commit = ConventionalCommit.tryParse(message);
  if (commit == null) {
    return Report(valid: false, errors: [], warnings: []);
  }
}