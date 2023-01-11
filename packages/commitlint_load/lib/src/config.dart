import 'rule.dart';

class Config {
  /// configuration to include.
  final String? include;

  /// Merged map of rules to check against.
  final Map<String, Rule> rules;

  Config({required this.rules, this.include});
}