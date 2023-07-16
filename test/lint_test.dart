import 'package:commitlint_cli/src/lint.dart';
import 'package:commitlint_cli/src/types/rule.dart';
import 'package:test/test.dart';

void main() {
  test('positive on empty message', () async {
    final result = await lint('', {});
    expect(result.valid, true);
    expect(result.input, equals(''));
    expect(result.errors.isEmpty, true);
    expect(result.warnings.isEmpty, true);
  });

  test('positive on stub message and no rule', () async {
    final result = await lint('foo: bar', {});
    expect(result.valid, true);
  });

  test('positive on stub message and adhered rule', () async {
    final result = await lint('foo: bar', {
      'type-enum': EnumRule(
        severity: RuleSeverity.error,
        condition: RuleCondition.always,
        allowed: ['foo'],
      ),
    });
    expect(result.valid, true);
  });

  test('negative on stub message and broken rule', () async {
    final result = await lint('foo: bar', {
      'type-enum': EnumRule(
        severity: RuleSeverity.error,
        condition: RuleCondition.never,
        allowed: ['foo'],
      ),
    });
    expect(result.valid, false);
  });

  test('positive on ignored message and broken rule', () async {
    final result = await lint('Revert "some bogus commit"', {
      'type-empty': Rule(
        severity: RuleSeverity.error,
        condition: RuleCondition.never,
      ),
    });
    expect(result.valid, true);
    expect(result.input, equals('Revert "some bogus commit"'));
  });

  test('negative on ignored message, disabled ignored messages and broken rule',
      () async {
    final result = await lint(
        'Revert "some bogus commit"',
        {
          'type-empty': Rule(
            severity: RuleSeverity.error,
            condition: RuleCondition.never,
          ),
        },
        defaultIgnores: false);
    expect(result.valid, false);
  });

  test('positive on custom ignored message and broken rule', () async {
    final ignoredMessage = 'some ignored custom message';
    final result = await lint(ignoredMessage, {
      'type-empty': Rule(
        severity: RuleSeverity.error,
        condition: RuleCondition.never,
      ),
    }, ignores: [
      ignoredMessage
    ]);
    expect(result.valid, true);
    expect(result.input, equals(ignoredMessage));
  });

  test('throws for invalid rule names', () async {
    await expectLater(
        lint('foo', {
          'foo': Rule(
            severity: RuleSeverity.error,
            condition: RuleCondition.always,
          ),
          'bar': Rule(
            severity: RuleSeverity.warning,
            condition: RuleCondition.never,
          ),
        }),
        throwsRangeError);
  });
}
