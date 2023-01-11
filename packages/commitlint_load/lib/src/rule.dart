enum RuleLevel {
  ignore,
  warning,
  error,
}

enum RuleCondition {
  alaways,
  never,
}

class Rule<T> {
  final RuleLevel level;
  final RuleCondition condition;
  final T? value;

  Rule({
    required this.level,
    required this.condition,
    this.value
  });
}