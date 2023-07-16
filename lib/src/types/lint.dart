import 'rule.dart';

class LintOutcome {
  /// The linted commit, as string
  final String input;

  /// If the linted commit is considered valid
  final bool valid;

  /// All errors, per rule, for the commit
  final Iterable<LintRuleOutcome> errors;

  /// All warnings, per rule, for the commit
  final Iterable<LintRuleOutcome> warnings;

  LintOutcome({
    required this.input,
    required this.valid,
    required this.errors,
    required this.warnings,
  });
}

class LintRuleOutcome {
  /// If the commit is considered valid for the rule
  final bool valid;

  /// The "severity" of the rule (0 = ignore, 1 = warning, 2 = error)
  final RuleSeverity level;

  /// The name of the rule
  final String name;

  /// The message returned from the rule, if invalid
  final String message;

  LintRuleOutcome({
    required this.valid,
    required this.level,
    required this.name,
    required this.message,
  });
}
