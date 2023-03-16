import 'package:commitlint_cli/src/format.dart';
import 'package:commitlint_cli/src/types.dart';
import 'package:test/test.dart';

void main() {
  test('does nothing without report results', () {
    final actual = format(report: FormattableReport.empty());
    expect(actual.isEmpty, true);
  });
  test('returns a correct summary of empty errors and warnings', () {
    final fakeError = LintOutcome(
      input: '',
      valid: false,
      errors: [
        LintRuleOutcome(
          valid: false,
          level: RuleConfigSeverity.error,
          name: 'error-name',
          message: 'There was an error',
        ),
      ],
      warnings: [],
    );
    final actualError = format(report: FormattableReport.empty() + fakeError);
    final fakeWarning = LintOutcome(
      input: '',
      valid: false,
      errors: [],
      warnings: [
        LintRuleOutcome(
          valid: false,
          level: RuleConfigSeverity.warning,
          name: 'warning-name',
          message: 'There was a problem',
        ),
      ],
    );
    final actualWarning =
        format(report: FormattableReport.empty() + fakeWarning);
    expect(actualError, contains('There was an error'));
    expect(actualError, contains('1 error(s), 0 warning(s)'));
    expect(actualWarning, contains('There was a problem'));
    expect(actualWarning, contains('0 error(s), 1 warning(s)'));
  });
}
