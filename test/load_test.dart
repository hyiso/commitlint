import 'package:commitlint_cli/src/load.dart';
import 'package:commitlint_cli/src/types/case.dart';
import 'package:commitlint_cli/src/types/rule.dart';
import 'package:test/test.dart';

void main() {
  test('empty should have no rules', () async {
    final config = await load('test/__fixtures__/empty.yaml');
    expect(config.rules.isEmpty, true);
  });
  test('only `rules` should work', () async {
    final config = await load('test/__fixtures__/only-rules.yaml');
    expect(config.rules.isEmpty, false);
    expect(config.rules.keys.length, equals(2));
    expect(config.rules['type-case'], isA<CaseRule>());
    expect(config.rules['type-enum'], isA<EnumRule>());
    expect((config.rules['type-case'] as CaseRule).type, Case.lower);
    expect((config.rules['type-enum'] as EnumRule).allowed,
        equals(['feat', 'fix', 'docs', 'chore']));
  });
  test('include relative path should work', () async {
    final config = await load('test/__fixtures__/include-path.yaml');
    expect(config.rules.isEmpty, false);
    expect(config.rules.keys.length, greaterThan(1));
    expect(config.rules['type-case'], isA<CaseRule>());
    expect(config.rules['type-enum'], isA<EnumRule>());
    expect((config.rules['type-case'] as CaseRule).type, Case.upper);
  });
  test('include package path should work', () async {
    final config = await load('test/__fixtures__/include-package.yaml');
    expect(config.rules.isEmpty, false);
    expect(config.rules.keys.length, greaterThan(1));
    expect(config.rules['type-case'], isA<CaseRule>());
    expect(config.rules['type-enum'], isA<EnumRule>());
    expect((config.rules['type-case'] as CaseRule).type, Case.upper);
  });
}
