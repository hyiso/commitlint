/// Support for doing something awesome.
///
/// More dartdocs go here.
library commitlint_lint;

import 'package:commitlint_parse/commitlint_parse.dart';
import 'package:commitlint_rules/commitlint_rules.dart';
import 'package:commitlint_types/commitlint_types.dart';

Future<LintOutcome> lint(
    String message, Map<String, RuleConfig> rulesConfig) async {
  // Parse the commit message
  final commit = message.isEmpty ? Commit.empty() : parse(message);

  if (commit.header.isEmpty && commit.body == null && commit.footer == null) {
    // Commit is empty, skip
    return LintOutcome(input: message, valid: true, errors: [], warnings: []);
  }
  final allRules = Map.of(supportedRules);

  /// Find invalid rules configs
  final missing = rulesConfig.keys.where((key) => !allRules.containsKey(key));
  if (missing.isNotEmpty) {
    final names = [...allRules.keys];
    throw RangeError(
        'Found invalid rule names: ${missing.join(', ')}. Supported rule names are: ${names.join(', ')}');
  }

  /// Validate against all rules
  final results = rulesConfig.entries
      // Level 0 rules are ignored
      .where((entry) => entry.value.severity != RuleConfigSeverity.ignore)
      .map((entry) {
        final name = entry.key;
        final config = entry.value;
        final rule = allRules[name];

        if (rule == null) {
          throw Exception('Could not find rule implementation for $name');
        }
        final ruleOutcome = rule.call(commit, config);

        return LintRuleOutcome(
          valid: ruleOutcome.valid,
          level: config.severity,
          name: name,
          message: ruleOutcome.message,
        );
      })
      .where((outcome) => !outcome.valid)
      .toList();
  final errors =
      results.where((element) => element.level == RuleConfigSeverity.error);
  final warnings =
      results.where((element) => element.level == RuleConfigSeverity.warning);
  return LintOutcome(
    input: message,
    valid: errors.isEmpty,
    errors: errors,
    warnings: warnings,
  );
}
