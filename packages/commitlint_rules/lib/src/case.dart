import 'package:commitlint_ensure/commitlint_ensure.dart';
import 'package:commitlint_types/commitlint_types.dart';
import 'package:conventional_commit/conventional_commit.dart';

RuleOutcome typeCase(ConventionalCommit commit, RuleConfig config) {
  if (config is! CaseRuleConfig) {
    throw Exception('$config is not CaseRuleConfig');
  }
  final result = commit.type != null && ensureCase(commit.type!, config.type);
  final negated = config.condition == RuleConfigCondition.never;
  return RuleOutcome(
    valid: negated ? !result : result,
    message: [
      'type must',
      if (negated) 'not',
      'be ${config.type.caseName}'
    ].join(' '),
  );
}

RuleOutcome scopeCase(ConventionalCommit commit, RuleConfig config) {
  if (config is! CaseRuleConfig) {
    throw Exception('$config is not CaseRuleConfig');
  }
  final result = commit.type != null && ensureCase(commit.type!, config.type);
  final negated = config.condition == RuleConfigCondition.never;
  return RuleOutcome(
    valid: negated ? !result : result,
    message: [
      'scope must',
      if (negated) 'not',
      'be ${config.type.caseName}'
    ].join(' '),
  );
}

RuleOutcome bodyCase(ConventionalCommit commit, RuleConfig config) {
  if (config is! CaseRuleConfig) {
    throw Exception('$config is not CaseRuleConfig');
  }
  final result = commit.type != null && ensureCase(commit.type!, config.type);
  final negated = config.condition == RuleConfigCondition.never;
  return RuleOutcome(
    valid: negated ? !result : result,
    message: [
      'body must',
      if (negated) 'not',
      'be ${config.type.caseName}'
    ].join(' '),
  );
}