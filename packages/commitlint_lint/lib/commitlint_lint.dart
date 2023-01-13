/// Support for doing something awesome.
///
/// More dartdocs go here.
library commitlint_lint;

import 'package:commitlint_rules/commitlint_rules.dart';
import 'package:commitlint_types/commitlint_types.dart';
import 'package:conventional_commit/conventional_commit.dart';

Future<LintOutcome> lint(String message, Map<String, RuleConfig> rulesConfig) async {
  final commit = ConventionalCommit.tryParse(message);
  if (commit == null) {
    return LintOutcome(input: message, valid: false, errors: [
      LintRuleOutcome(
        level: RuleConfigSeverity.error,
        valid: false,
        name: 'message-format',
        message: [
            'Commit message does not meet the conventional commit format.',
            '   - See format guide: https://www.conventionalcommits.org',
          ].join('\n'),
      ),
    ], warnings: []);
  }
  if (commit.isMergeCommit) {
    return LintOutcome(input: message, valid: true, errors: [], warnings: []);
  }
  final allRules = Map.of(supportedRules);
  /// Find invalid rules configs
	final missing = rulesConfig.keys.where(
		(key) => !allRules.containsKey(key)
	);
  if (missing.isNotEmpty) {
		final names = [...allRules.keys];
		throw RangeError(
			'Found invalid rule names: ${missing.join(', ')}. Supported rule names are: ${names.join(', ')}'
		);
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
  final errors = results.where((element) => element.level == RuleConfigSeverity.error);
  final warnings = results.where((element) => element.level == RuleConfigSeverity.warning);
  return LintOutcome(
    input: message,
    valid: errors.isEmpty,
    errors: errors,
    warnings: warnings,
  );
}