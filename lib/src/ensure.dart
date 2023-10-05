import 'package:change_case/change_case.dart';

import 'types/case.dart';

bool ensureCase(dynamic raw, Case target) {
  if (raw is Iterable) {
    return raw.isEmpty || raw.every((element) => ensureCase(element, target));
  }
  if (raw is String) {
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
  return false;
}

bool ensureFullStop(String raw, String target) {
  return raw.endsWith(target);
}

bool ensureLeadingBlank(String raw) {
  return raw.startsWith('\n');
}

bool ensureMaxLength(dynamic raw, num maxLength) {
  if (raw is String) {
    return raw.length <= maxLength;
  }
  if (raw is Iterable) {
    return raw.isEmpty || raw.every((element) => element.length <= maxLength);
  }
  return false;
}

bool ensureMaxLineLength(String raw, num maxLineLength) {
  return raw
      .split(RegExp(r'(?:\r?\n)'))
      .every((line) => ensureMaxLength(line, maxLineLength));
}

bool ensureMinLength(dynamic raw, num minLength) {
  if (raw is String) {
    return raw.length >= minLength;
  }
  if (raw is Iterable) {
    return raw.isEmpty || raw.every((element) => element.length >= minLength);
  }
  return false;
}

bool ensureEmpty(dynamic raw) {
  if (raw is String) {
    return raw.isEmpty;
  }
  if (raw is Iterable) {
    return raw.isEmpty;
  }
  return false;
}

bool ensureEnum(dynamic raw, Iterable enums) {
  if (raw is String) {
    return raw.isEmpty || enums.contains(raw);
  }
  if (raw is Iterable) {
    return raw.isEmpty || raw.every((element) => enums.contains(element));
  }
  return false;
}
