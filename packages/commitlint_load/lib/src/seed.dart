import 'rule.dart';

class Seed {
  /// configuration to include.
  final String? include;

  /// Merged map of rules to check against.
  final Map<String, Rule> rules;

  Seed({required this.rules, this.include});
}