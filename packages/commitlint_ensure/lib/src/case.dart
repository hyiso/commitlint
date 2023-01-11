import 'package:change_case/change_case.dart';
import 'package:commitlint_types/commitlint_types.dart';

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