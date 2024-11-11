import 'parser.dart';
import 'rule.dart';

class CommitLint {
  CommitLint({
    this.rules = const {},
    this.defaultIgnores,
    this.ignores,
    this.parser,
  });

  final Map<String, Rule> rules;

  final bool? defaultIgnores;

  final Iterable<String>? ignores;

  final ParserOptions? parser;

  CommitLint inherit(CommitLint other) {
    return CommitLint(
      rules: {
        ...other.rules,
        ...rules,
      },
      defaultIgnores: defaultIgnores ?? other.defaultIgnores,
      ignores: [
        ...?other.ignores,
        ...?ignores,
      ],
      parser: parser ?? other.parser,
    );
  }
}
