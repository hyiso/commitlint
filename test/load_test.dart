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
    expect(config.defaultIgnores, equals(null));
    expect(config.ignores, equals(null));
  });
  test('include relative path should work', () async {
    final config = await load('test/__fixtures__/include-path.yaml');
    expect(config.rules.isEmpty, false);
    expect(config.rules.keys.length, greaterThan(1));
    expect(config.rules['type-case'], isA<CaseRule>());
    expect(config.rules['type-enum'], isA<EnumRule>());
    expect((config.rules['type-case'] as CaseRule).type, Case.upper);
    expect(config.defaultIgnores, equals(false));
    expect(config.ignores, equals(["r'^fixup'"]));
  });
  test('include package path should work', () async {
    final config = await load('test/__fixtures__/include-package.yaml');
    expect(config.rules.isEmpty, false);
    expect(config.rules.keys.length, greaterThan(1));
    expect(config.rules['type-case'], isA<CaseRule>());
    expect(config.rules['type-enum'], isA<EnumRule>());
    expect((config.rules['type-case'] as CaseRule).type, Case.upper);
    expect(config.defaultIgnores, equals(null));
    expect(config.ignores, equals(["r'^fixup'"]));
  });
  test('custom parser options should work', () async {
    final config = await load('test/__fixtures__/parser-options.yaml');
    expect(config.parser, isNotNull);
    expect(config.parser!.issuePrefixes, equals(['sv-']));
  });
}
