import 'package:commitlint_rules/src/case.dart';
import 'package:commitlint_rules/src/enum.dart';
import 'package:commitlint_types/commitlint_types.dart';

Map<String, Rule> get defaultsRules => {
  'type-case': typeCase,
  'type-enum': typeEnum,
  'scope-case': scopeCase,
  'body-case': bodyCase,
};
