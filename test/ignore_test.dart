import 'package:commitlint_cli/src/lint.dart';
import 'package:commitlint_cli/src/types/rule.dart';
import 'package:test/test.dart';

void main() {
  test('Should ignore configurated multi-line merge message', () async {
    final message = '''Merge branch 'develop' into feature/xyz

# Conflicts:
#	xyz.yaml
''';
    final result = await lint(
        message,
        {
          'type-empty': Rule(
            severity: RuleSeverity.error,
            condition: RuleCondition.never,
          ),
        },
        defaultIgnores: true);
    expect(result.valid, true);
    expect(result.input, equals(message));
  });
}
