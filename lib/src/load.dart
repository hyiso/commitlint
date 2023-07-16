import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import 'types/case.dart';
import 'types/commitlint.dart';
import 'types/rule.dart';

///
/// Load configured rules in given [path] from given [directory].
///
Future<CommitLint> load(
  String path, {
  Directory? directory,
}) async {
  File? file;
  if (!path.startsWith('package:')) {
    final uri = toUri(join(directory?.path ?? Directory.current.path, path));
    file = File.fromUri(uri);
  } else {
    final uri = await Isolate.resolvePackageUri(Uri.parse(path));
    if (uri != null) {
      file = File.fromUri(uri);
    }
  }
  if (file != null && file.existsSync()) {
    final yaml = loadYaml(await file.readAsString());
    final include = yaml?['include'] as String?;
    final rules = yaml?['rules'] as YamlMap?;
    final ignores = yaml?['ignores'] as YamlList?;
    final defaultIgnores = yaml?['defaultIgnores'] as bool?;
    final config = CommitLint(
        rules: rules?.map((key, value) => MapEntry(key, _extractRule(value))) ??
            {},
        ignores: ignores?.cast(),
        defaultIgnores: defaultIgnores);
    if (include != null) {
      final upstream = await load(include, directory: file.parent);
      return config.inherit(upstream);
    }
    return config;
  }
  return CommitLint();
}

Rule _extractRule(dynamic config) {
  if (config is! List) {
    throw Exception('rule config must be list, but get $config');
  }
  if (config.isEmpty || config.length < 2 || config.length > 3) {
    throw Exception(
        'rule config must contain at least two, at most three items.');
  }
  final severity = _extractRuleSeverity(config.first as int);
  final condition = _extractRuleCondition(config.elementAt(1) as String);
  dynamic value;
  if (config.length == 3) {
    value = config.last;
  }
  if (value == null) {
    return Rule(severity: severity, condition: condition);
  }
  if (value is num) {
    return LengthRule(
      severity: severity,
      condition: condition,
      length: value,
    );
  }
  if (value is String) {
    if (value.endsWith('-case')) {
      return CaseRule(
        severity: severity,
        condition: condition,
        type: _extractCase(value),
      );
    } else {
      return ValueRule(
        severity: severity,
        condition: condition,
        value: value,
      );
    }
  }
  if (value is List) {
    return EnumRule(
      severity: severity,
      condition: condition,
      allowed: value.cast(),
    );
  }
  return ValueRule(
    severity: severity,
    condition: condition,
    value: value,
  );
}

RuleSeverity _extractRuleSeverity(int severity) {
  if (severity < 0 || severity > RuleSeverity.values.length - 1) {
    throw Exception(
        'rule severity can only be 0..${RuleSeverity.values.length - 1}');
  }
  return RuleSeverity.values[severity];
}

RuleCondition _extractRuleCondition(String condition) {
  var allowed = RuleCondition.values.map((e) => e.name).toList();
  final index = allowed.indexOf(condition);
  if (index == -1) {
    throw Exception('rule condition can only one of $allowed');
  }
  return RuleCondition.values[index];
}

Case _extractCase(String name) {
  var allowed = Case.values.map((e) => e.caseName).toList();
  final index = allowed.indexOf(name);
  if (index == -1) {
    throw Exception('rule case can only one of $allowed');
  }
  return Case.values[index];
}
