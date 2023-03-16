import 'package:commitlint_cli/src/lint.dart';
import 'package:commitlint_cli/src/types.dart';
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
      'type-enum': EnumRuleConfig(
        severity: RuleConfigSeverity.error,
        condition: RuleConfigCondition.always,
        allowed: ['foo'],
      ),
    });
    expect(result.valid, true);
  });

  test('negative on stub message and broken rule', () async {
    final result = await lint('foo: bar', {
      'type-enum': EnumRuleConfig(
        severity: RuleConfigSeverity.error,
        condition: RuleConfigCondition.never,
        allowed: ['foo'],
      ),
    });
    expect(result.valid, false);
  });

  test('positive on ignored message and broken rule', () async {
    final result = await lint('Revert "some bogus commit"', {
      'type-empty': RuleConfig(
        severity: RuleConfigSeverity.error,
        condition: RuleConfigCondition.never,
      ),
    });
    expect(result.valid, false);
    expect(result.input, equals('Revert "some bogus commit"'));
  });

  test('negative on ignored message, disabled ignored messages and broken rule',
      () async {
    final result = await lint('Revert "some bogus commit"', {
      'type-empty': RuleConfig(
        severity: RuleConfigSeverity.error,
        condition: RuleConfigCondition.never,
      ),
    });
    expect(result.valid, false);
  });
}
