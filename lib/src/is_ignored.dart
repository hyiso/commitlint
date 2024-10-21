bool isIgnored(String message,
    {bool? defaultIgnores, Iterable<String>? ignores}) {
  return [if (defaultIgnores != false) ..._wildcards, ...?ignores]
      .any((pattern) => RegExp(pattern).hasMatch(message));
}

final _wildcards = [
  r'((Merge pull request)|(Merge (.*?) into (.*?)|(Merge branch (.*?)))(?:\r?\n)*)',
  r'(Merge tag (.*?))(?:\r?\n)*$',
  r'(R|r)evert (.*)',
  r'(fixup|squash)!',
  r'(Merged (.*?)(in|into) (.*)|Merged PR (.*): (.*))',
  r'Merge remote-tracking branch(\s*)(.*)',
  r'Automatic merge(.*)',
  r'Auto-merged (.*?) into (.*)',
];
