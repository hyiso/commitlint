import 'rule.dart';

class CommitLint {
  CommitLint({this.rules = const {}, this.deafultIgnores, this.ignores});

  final Map<String, Rule> rules;

  final bool? deafultIgnores;

  final Iterable<String>? ignores;

  CommitLint inherit(CommitLint other) {
    return CommitLint(
      rules: {
        ...other.rules,
        ...rules,
      },
      deafultIgnores: other.deafultIgnores ?? deafultIgnores,
      ignores: [
        ...?other.ignores,
        ...?ignores,
      ],
    );
  }
}
