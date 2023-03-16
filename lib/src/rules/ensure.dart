part of '../rules.dart';

bool ensureCase(String raw, Case target) {
  switch (target) {
    case Case.lower:
      return raw.toLowerCase() == raw;
    case Case.upper:
      return raw.toUpperCase() == raw;
    case Case.camel:
      return raw.toCamelCase() == raw;
    case Case.kebab:
      return raw.toKebabCase() == raw;
    case Case.pascal:
      return raw.toPascalCase() == raw;
    case Case.sentence:
      return raw.toSentenceCase() == raw;
    case Case.snake:
      return raw.toSnakeCase() == raw;
    case Case.capital:
      return raw.toCapitalCase() == raw;
  }
}

bool ensureFullStop(String raw, String target) {
  return raw.endsWith(target);
}

bool ensureLeadingBlank(String raw) {
  return raw.startsWith('\n');
}

bool ensureMaxLength(String raw, num maxLength) {
  return raw.length <= maxLength;
}

bool ensureMaxLineLength(String raw, num maxLineLength) {
  return raw.split('\n').every((line) => ensureMaxLength(line, maxLineLength));
}

bool ensureMinLength(String raw, num minLength) {
  return raw.length >= minLength;
}

bool ensureEmpty(dynamic raw) {
  if (raw == null) {
    return true;
  }
  if (raw is String) {
    return raw.isEmpty;
  }
  if (raw is Iterable<String>) {
    return raw.isEmpty;
  }
  return false;
}

bool ensureEnum(dynamic raw, Iterable enums) {
  if (raw == null) {
    return true;
  }
  if (raw is String) {
    return raw.isEmpty || enums.contains(raw);
  }
  if (raw is Iterable) {
    return raw.isEmpty || raw.every((element) => enums.contains(element));
  }
  return false;
}
