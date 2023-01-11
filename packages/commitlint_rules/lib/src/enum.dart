
import 'package:commitlint_types/commitlint_types.dart';
import 'package:conventional_commit/conventional_commit.dart';

RuleOutcome typeEnum(ConventionalCommit commit, EnumRuleConfig config) {
  final result = config.allowed.contains(commit.type);
  final negated = config.condition == RuleConfigCondition.never;
  return RuleOutcome(
    valid: negated ? !result : result,
    message: [
      'type must',
      if (negated) 'not',
      'be ${config.allowed}'
    ].join(' '),
  );
}