bool isIgnored(String message,
    {bool? defaultIgnores, Iterable<String>? ignores}) {
  final base = defaultIgnores == false ? [] : wildcards;
  return [...base, ...?ignores?.map(ignore)].any((mathcer) => mathcer(message));
}

final wildcards = [
  ignore(
      r'((Merge pull request)|(Merge (.*?) into (.*?)|(Merge branch (.*?)))(?:\r?\n)*$)'),
  ignore(r'(Merge tag (.*?))(?:\r?\n)*$'),
  ignore(r'(R|r)evert (.*)'),
  ignore(r'(fixup|squash)!'),
  ignore(r'(Merged (.*?)(in|into) (.*)|Merged PR (.*): (.*))'),
  ignore(r'Merge remote-tracking branch(\s*)(.*)'),
  ignore(r'Automatic merge(.*)'),
  ignore(r'Auto-merged (.*?) into (.*)'),
];

Matcher ignore(String pattern) =>
    (String message) => RegExp(pattern).hasMatch(message);

typedef Matcher = bool Function(String);
