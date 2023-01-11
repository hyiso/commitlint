
import 'package:conventional_commit/conventional_commit.dart';
import 'case.dart';

enum RuleConfigSeverity {
  ignore,
  warning,
  error,
}

enum RuleConfigCondition {
  always,
  never,
}

abstract class RuleConfig {
  RuleConfigSeverity get severity;
  RuleConfigCondition get condition;
}

class RuleOutcome {
  final bool valid;
  final String message;

  RuleOutcome({required this.valid, required this.message});
}

typedef Rule = RuleOutcome Function(ConventionalCommit, RuleConfig config);

class EmptyRuleConfig extends RuleConfig {

  @override
  final RuleConfigSeverity severity;

  @override
  final RuleConfigCondition condition;

  EmptyRuleConfig({
    required this.severity,
    required this.condition,
  });
}

class ValueRuleConfig<T> extends RuleConfig {

  @override
  final RuleConfigSeverity severity;

  @override
  final RuleConfigCondition condition;

  final T value;

  ValueRuleConfig({
    required this.severity,
    required this.condition,
    required this.value,
  });
}

class LengthRuleConfig extends ValueRuleConfig<num> {
  LengthRuleConfig({
    required RuleConfigSeverity severity,
    required RuleConfigCondition condition,
    required num length,
  }) : super(
    severity: severity,
    condition: condition,
    value: length,
  );

}

class EnumRuleConfig extends RuleConfig {

  @override
  final RuleConfigSeverity severity;

  @override
  final RuleConfigCondition condition;

  final List<String> allowed;

  EnumRuleConfig({
    required this.severity,
    required this.condition,
    required this.allowed,
  });

}

class CaseRuleConfig extends RuleConfig {

  @override
  final RuleConfigSeverity severity;

  @override
  final RuleConfigCondition condition;

  final Case type;

  CaseRuleConfig({
    required this.severity,
    required this.condition,
    required this.type,
  });

}