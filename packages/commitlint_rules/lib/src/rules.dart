import 'package:commitlint_types/commitlint_types.dart';

import 'ensure.dart';

enum CommitComponent {
  type,
  scope,
  header,
  body,
  footer,
}

extension PartialCommit on Commit {
  T? componentRaw<T>(CommitComponent component) {
    switch (component) {
      case CommitComponent.type:
        return type as T?;
      case CommitComponent.scope:
        return scope as T?;
      case CommitComponent.header:
        return header as T?;
      case CommitComponent.body:
        return body as T?;
      case CommitComponent.footer:
        return footer as T?;
    }
  }
}

/// Build full stop rule for commit component.
Rule fullStopRule(CommitComponent component) {
  return (Commit commit, RuleConfig config) {
    if (config is! ValueRuleConfig) {
      throw Exception('$config is not ValueRuleConfig<String>');
    }
    final raw = commit.componentRaw(component);
    final result = raw != null && ensureFullStop(raw, config.value);
    final negated = config.condition == RuleConfigCondition.never;
    return RuleOutcome(
      valid: negated ? !result : result,
      message: [
        '${component.name} must',
        if (negated) 'not',
        'end with ${config.value}'
      ].join(' '),
    );
  };
}

/// Build leanding blank rule for commit component.
Rule leadingBlankRule(CommitComponent component) {
  return (Commit commit, RuleConfig config) {
    final raw = commit.componentRaw(component);
    final result = raw != null && ensureLeadingBlank(raw);
    final negated = config.condition == RuleConfigCondition.never;
    return RuleOutcome(
      valid: negated ? !result : result,
      message: [
        '${component.name} must',
        if (negated) 'not',
        'begin with blank line'
      ].join(' '),
    );
  };
}

/// Build leanding blank rule for commit component.
Rule emptyRule(CommitComponent component) {
  return (Commit commit, RuleConfig config) {
    final raw = commit.componentRaw(component);
    final result = ensureEmpty(raw);
    final negated = config.condition == RuleConfigCondition.never;
    return RuleOutcome(
      valid: negated ? !result : result,
      message:
          ['${component.name} must', if (negated) 'not', 'be empty'].join(' '),
    );
  };
}

/// Build case rule for commit component.
Rule caseRule(CommitComponent component) {
  return (Commit commit, RuleConfig config) {
    if (config is! CaseRuleConfig) {
      throw Exception('$config is not CaseRuleConfig');
    }
    final raw = commit.componentRaw(component);
    final result = raw != null && ensureCase(raw, config.type);
    final negated = config.condition == RuleConfigCondition.never;
    return RuleOutcome(
      valid: negated ? !result : result,
      message: [
        '${component.name} case must',
        if (negated) 'not',
        'be ${config.type.caseName}'
      ].join(' '),
    );
  };
}

/// Build max length rule for commit component.
Rule maxLengthRule(CommitComponent component) {
  return (Commit commit, RuleConfig config) {
    if (config is! LengthRuleConfig) {
      throw Exception('$config is not LengthRuleConfig');
    }
    final raw = commit.componentRaw(component);
    final result = raw != null && ensureMaxLength(raw, config.length);
    final negated = config.condition == RuleConfigCondition.never;
    return RuleOutcome(
      valid: negated ? !result : result,
      message: [
        '${component.name} must',
        if (negated) 'not',
        'have ${config.length} or less characters'
      ].join(' '),
    );
  };
}

/// Build max line length rule for commit component.
Rule maxLineLengthRule(CommitComponent component) {
  return (Commit commit, RuleConfig config) {
    if (config is! LengthRuleConfig) {
      throw Exception('$config is not LengthRuleConfig');
    }
    final raw = commit.componentRaw(component);
    final result = raw != null && ensureMaxLineLength(raw, config.length);
    final negated = config.condition == RuleConfigCondition.never;
    return RuleOutcome(
      valid: negated ? !result : result,
      message: [
        '${component.name} lines must',
        if (negated) 'not',
        'have ${config.length} or less characters'
      ].join(' '),
    );
  };
}

/// Build min length rule for commit component.
Rule minLengthRule(CommitComponent component) {
  return (Commit commit, RuleConfig config) {
    if (config is! LengthRuleConfig) {
      throw Exception('$config is not LengthRuleConfig');
    }
    final raw = commit.componentRaw(component);
    final result = raw != null && ensureMinLength(raw, config.length);
    final negated = config.condition == RuleConfigCondition.never;
    return RuleOutcome(
      valid: negated ? !result : result,
      message: [
        '${component.name} must',
        if (negated) 'not',
        'have ${config.length} or more characters'
      ].join(' '),
    );
  };
}

Rule enumRule(CommitComponent component) {
  return (Commit commit, RuleConfig config) {
    if (config is! EnumRuleConfig) {
      throw Exception('$config is not EnumRuleConfig');
    }
    final raw = commit.componentRaw(component);
    final result = ensureEnum(raw, config.allowed);
    final negated = config.condition == RuleConfigCondition.never;
    return RuleOutcome(
      valid: negated ? !result : result,
      message: [
        '${component.name} must',
        if (negated) 'not',
        'be one of ${config.allowed}'
      ].join(' '),
    );
  };
}
