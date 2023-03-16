import 'ensure.dart';
import 'types/case.dart';
import 'types/commit.dart';
import 'types/rule.dart';

Map<String, Rule> get supportedRules => {
      'type-case': caseRule(CommitComponent.type),
      'type-empty': emptyRule(CommitComponent.type),
      'type-enum': enumRule(CommitComponent.type),
      'type-max-length': maxLengthRule(CommitComponent.type),
      'type-min-length': minLengthRule(CommitComponent.type),
      'scope-case': caseRule(CommitComponent.scope),
      'scope-empty': emptyRule(CommitComponent.scope),
      'scope-enum': enumRule(CommitComponent.scope),
      'scope-max-length': maxLengthRule(CommitComponent.scope),
      'scope-min-length': minLengthRule(CommitComponent.scope),
      'subject-case': caseRule(CommitComponent.subject),
      'subject-empty': emptyRule(CommitComponent.subject),
      'subject-full-stop': fullStopRule(CommitComponent.subject),
      'subject-max-length': maxLengthRule(CommitComponent.subject),
      'subject-min-length': minLengthRule(CommitComponent.subject),
      'header-case': caseRule(CommitComponent.header),
      'header-full-stop': fullStopRule(CommitComponent.header),
      'header-max-length': maxLengthRule(CommitComponent.header),
      'header-min-length': minLengthRule(CommitComponent.header),
      'body-case': caseRule(CommitComponent.body),
      'body-empty': emptyRule(CommitComponent.body),
      'body-full-stop': fullStopRule(CommitComponent.body),
      'body-leading-blank': leadingBlankRule(CommitComponent.body),
      'body-max-length': maxLengthRule(CommitComponent.body),
      'body-max-line-length': maxLineLengthRule(CommitComponent.body),
      'body-min-length': minLengthRule(CommitComponent.body),
      'footer-case': caseRule(CommitComponent.footer),
      'footer-empty': emptyRule(CommitComponent.footer),
      'footer-leading-blank': leadingBlankRule(CommitComponent.footer),
      'footer-max-length': maxLengthRule(CommitComponent.footer),
      'footer-max-line-length': maxLineLengthRule(CommitComponent.footer),
      'footer-min-length': minLengthRule(CommitComponent.footer),
    };

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
