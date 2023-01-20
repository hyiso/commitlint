import 'case.dart';
import 'parse.dart';

/// 0 disables the rule. For 1 it will be considered a warning for 2 an error
enum RuleConfigSeverity {
  ignore,
  warning,
  error,
}

enum RuleConfigCondition {
  always,
  never,
}

class RuleConfig {
  final RuleConfigSeverity severity;
  final RuleConfigCondition condition;

  RuleConfig({
    required this.severity,
    required this.condition,
  });
}

class RuleOutcome {
  final bool valid;
  final String message;

  RuleOutcome({required this.valid, required this.message});
}

typedef Rule = RuleOutcome Function(Commit, RuleConfig config);

class ValueRuleConfig extends RuleConfig {
  final String value;

  ValueRuleConfig({
    required RuleConfigSeverity severity,
    required RuleConfigCondition condition,
    required this.value,
  }) : super(severity: severity, condition: condition);
}

class LengthRuleConfig extends RuleConfig {
  final num length;

  LengthRuleConfig({
    required RuleConfigSeverity severity,
    required RuleConfigCondition condition,
    required this.length,
  }) : super(
          severity: severity,
          condition: condition,
        );
}

class EnumRuleConfig extends RuleConfig {
  final List<String> allowed;

  EnumRuleConfig({
    required RuleConfigSeverity severity,
    required RuleConfigCondition condition,
    required this.allowed,
  }) : super(severity: severity, condition: condition);
}

class CaseRuleConfig extends RuleConfig {
  final Case type;

  CaseRuleConfig({
    required RuleConfigSeverity severity,
    required RuleConfigCondition condition,
    required this.type,
  }) : super(severity: severity, condition: condition);
}
