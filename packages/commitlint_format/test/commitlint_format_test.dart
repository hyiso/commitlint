import 'package:commitlint_format/commitlint_format.dart';
import 'package:commitlint_types/commitlint_types.dart';
import 'package:test/test.dart';

void main() {
  test('does nothing without report results', () {
    final actual = format(report: FormattableReport.empty());
    expect(actual.isEmpty, true);
  });
  test('does nothing without errors and warnings', () {
    final fake = LintOutcome(input: '', valid: true, errors: [], warnings: []);
    final actual = format(report: FormattableReport.empty() + fake);
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
    expect(actualError.contains('There was an error'), true);
    expect(actualError.contains('1 errors, 0 warnings'), true);
    expect(actualWarning.contains('There was a problem'), true);
    expect(actualWarning.contains('0 errors, 1 warnings'), true);
  });
}
