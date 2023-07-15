import 'case.dart';
import 'commit.dart';

/// 0 disables the rule. For 1 it will be considered a warning for 2 an error
enum RuleSeverity {
  ignore,
  warning,
  error,
}

enum RuleCondition {
  always,
  never,
}

class Rule {
  final RuleSeverity severity;
  final RuleCondition condition;

  Rule({
    required this.severity,
    required this.condition,
  });
}

class RuleOutcome {
  final bool valid;
  final String message;

  RuleOutcome({required this.valid, required this.message});
}

typedef RuleFunction = RuleOutcome Function(Commit, Rule config);

class ValueRule extends Rule {
  final String value;

  ValueRule({
    required RuleSeverity severity,
    required RuleCondition condition,
    required this.value,
  }) : super(severity: severity, condition: condition);
}

class LengthRule extends Rule {
  final num length;

  LengthRule({
    required RuleSeverity severity,
    required RuleCondition condition,
    required this.length,
  }) : super(
          severity: severity,
          condition: condition,
        );
}

class EnumRule extends Rule {
  final List<String> allowed;

  EnumRule({
    required RuleSeverity severity,
    required RuleCondition condition,
    required this.allowed,
  }) : super(severity: severity, condition: condition);
}

class CaseRule extends Rule {
  final Case type;

  CaseRule({
    required RuleSeverity severity,
    required RuleCondition condition,
    required this.type,
  }) : super(severity: severity, condition: condition);
}
