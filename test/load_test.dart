import 'package:commitlint_cli/src/load.dart';
import 'package:commitlint_cli/src/types/case.dart';
import 'package:commitlint_cli/src/types/rule.dart';
import 'package:test/test.dart';

void main() {
  test('empty should have no rules', () async {
    final rules = await load(file: 'test/__fixtures__/empty.yaml');
    expect(rules.isEmpty, true);
  });
  test('only `rules` should work', () async {
    final rules = await load(file: 'test/__fixtures__/only-rules.yaml');
    expect(rules.isEmpty, false);
    expect(rules.keys.length, equals(2));
    expect(rules['type-case'], isA<CaseRuleConfig>());
    expect(rules['type-enum'], isA<EnumRuleConfig>());
    expect((rules['type-case'] as CaseRuleConfig).type, Case.lower);
    expect((rules['type-enum'] as EnumRuleConfig).allowed,
        equals(['feat', 'fix', 'docs', 'chore']));
  });
  test('include relative path should work', () async {
    final rules = await load(file: 'test/__fixtures__/include-path.yaml');
    expect(rules.isEmpty, false);
    expect(rules.keys.length, greaterThan(1));
    expect(rules['type-case'], isA<CaseRuleConfig>());
    expect(rules['type-enum'], isA<EnumRuleConfig>());
    expect((rules['type-case'] as CaseRuleConfig).type, Case.upper);
  });
  test('include package path should work', () async {
    final rules = await load(file: 'test/__fixtures__/include-package.yaml');
    expect(rules.isEmpty, false);
    expect(rules.keys.length, greaterThan(1));
    expect(rules['type-case'], isA<CaseRuleConfig>());
    expect(rules['type-enum'], isA<EnumRuleConfig>());
    expect((rules['type-case'] as CaseRuleConfig).type, Case.upper);
  });
}
