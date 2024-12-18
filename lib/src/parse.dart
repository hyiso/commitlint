import 'types/commit.dart';
import 'types/parser.dart';

///
/// Parse Commit Message String to Convensional Commit
///
Commit parse(
  String raw, {
  ParserOptions? options,
}) {
  options ??= const ParserOptions();
  if (raw.trim().isEmpty) {
    throw ArgumentError.value(raw, null, 'message raw must have content.');
  }
  String? body;
  String? footer;
  List<String> mentions = [];
  List<CommitNote> notes = [];
  List<CommitReference> references = [];
  Map<String, String?>? revert;
  String? merge;
  String? header;
  final rawLines = _trimOffNewlines(raw).split(RegExp(r'\r?\n'));
  final lines = _truncateToScissor(rawLines).where(_gpgFilter).toList();
  merge = lines.removeAt(0);
  final mergeMatch = RegExp(options.mergePattern).firstMatch(merge);
  if (mergeMatch != null) {
    merge = mergeMatch.group(0);
    if (lines.isNotEmpty) {
      header = lines.removeAt(0);
      while (header!.trim().isEmpty && lines.isNotEmpty) {
        header = lines.removeAt(0);
      }
    }
    header ??= '';
  } else {
    header = merge;
    merge = null;
  }
  final headerMatch = RegExp(options.headerPattern).firstMatch(header);
  final headerParts = <String, String?>{};
  if (headerMatch != null) {
    for (int i = 0; i < options.headerCorrespondence.length; i++) {
      final String key = options.headerCorrespondence[i];
      headerParts[key] = headerMatch.group(i + 1);
    }
    // for (var name in options.headerCorrespondence) {
    //   headerParts[name] = headerMatch.namedGroup(name);
    // }
  }
  final referencesPattern = _getReferenceRegex(options.referenceActions);
  final referencePartsPattern =
      _getReferencePartsRegex(options.issuePrefixes, false);
  references.addAll(_getReferences(header,
      referencesPattern: referencesPattern,
      referencePartsPattern: referencePartsPattern));

  bool continueNote = false;
  bool isBody = true;
  final notesPattern = _getNotesRegex(options.noteKeywords);

  /// body or footer
  for (var line in lines) {
    bool referenceMatched = false;
    final notesMatch = notesPattern.firstMatch(line);
    if (notesMatch != null) {
      continueNote = true;
      isBody = false;
      footer = _append(footer, line);
      notes.add(
          CommitNote(title: notesMatch.group(1)!, text: notesMatch.group(2)!));
      continue;
    }

    final lineReferences = _getReferences(
      line,
      referencesPattern: referencesPattern,
      referencePartsPattern: referencePartsPattern,
    );

    if (lineReferences.isNotEmpty) {
      isBody = false;
      referenceMatched = true;
      continueNote = false;
      references.addAll(lineReferences);
    }

    if (referenceMatched) {
      footer = _append(footer, line);
      continue;
    }

    if (continueNote) {
      notes.last.text = _append(notes.last.text, line);
      footer = _append(footer, line);
      continue;
    }
    if (isBody) {
      body = _append(body, line);
    } else {
      footer = _append(footer, line);
    }
  }

  final mentionsRegex = RegExp(options.mentionsPattern);
  Match? mentionsMatch = mentionsRegex.firstMatch(raw);
  while (mentionsMatch != null) {
    mentions.add(mentionsMatch.group(1)!);
    mentionsMatch = mentionsRegex.matchAsPrefix(raw, mentionsMatch.end);
  }

  // does this commit revert any other commit?
  final revertMatch = RegExp(options.revertPattern).firstMatch(raw);
  if (revertMatch != null) {
    revert = {};
    for (var i = 0; i < options.revertCorrespondence.length; i++) {
      revert[options.revertCorrespondence[i]] = revertMatch.group(i + 1);
    }
  }

  for (var note in notes) {
    note.text = _trimOffNewlines(note.text);
  }
  return Commit(
    revert: revert,
    merge: merge,
    header: header,
    type: headerParts['type'],
    scopes: headerParts['scope']?.split(RegExp(r'\/|\\|, ?')),
    subject: headerParts['subject'],
    body: body != null ? _trimOffNewlines(body) : null,
    footer: footer != null ? _trimOffNewlines(footer) : null,
    notes: notes,
    references: references,
    mentions: mentions,
  );
}

String _trimOffNewlines(String input) {
  final result = RegExp(r'[^\r\n]').firstMatch(input);
  if (result == null) {
    return '';
  }
  final firstIndex = result.start;
  var lastIndex = input.length - 1;
  while (input[lastIndex] == '\r' || input[lastIndex] == '\n') {
    lastIndex--;
  }
  return input.substring(firstIndex, lastIndex + 1);
}

bool _gpgFilter(String line) {
  return !RegExp(r'^\s*gpg:').hasMatch(line);
}

final _kMatchAll = RegExp(r'()(.+)', caseSensitive: false);

const _kScissor = '# ------------------------ >8 ------------------------';

List<String> _truncateToScissor(List<String> lines) {
  final scissorIndex = lines.indexOf(_kScissor);

  if (scissorIndex == -1) {
    return lines;
  }

  return lines.sublist(0, scissorIndex);
}

List<CommitReference> _getReferences(
  String input, {
  required RegExp referencesPattern,
  required RegExp referencePartsPattern,
}) {
  final references = <CommitReference>[];
  final reApplicable =
      referencesPattern.hasMatch(input) ? referencesPattern : _kMatchAll;
  Match? referenceSentences = reApplicable.firstMatch(input);
  while (referenceSentences != null) {
    final action = referenceSentences.group(1);
    final sentence = referenceSentences.group(2);
    Match? referenceMatch = referencePartsPattern.firstMatch(sentence!);
    while (referenceMatch != null) {
      String? owner;
      String? repository = referenceMatch.group(1);
      final ownerRepo = repository?.split('/') ?? [];

      if (ownerRepo.length > 1) {
        owner = ownerRepo.removeAt(0);
        repository = ownerRepo.join('/');
      }
      references.add(CommitReference(
        action: action,
        owner: owner,
        repository: repository,
        issue: referenceMatch.group(3),
        raw: referenceMatch.group(0)!,
        prefix: referenceMatch.group(2)!,
      ));
      referenceMatch =
          referencePartsPattern.matchAsPrefix(sentence, referenceMatch.end);
    }
    referenceSentences =
        reApplicable.matchAsPrefix(input, referenceSentences.end);
  }
  return references;
}

RegExp _getReferenceRegex(Iterable<String> referenceActions) {
  if (referenceActions.isEmpty) {
    // matches everything
    return RegExp(r'()(.+)', caseSensitive: false); //gi
  }

  final joinedKeywords = referenceActions.join('|');
  return RegExp('($joinedKeywords)(?:\\s+(.*?))(?=(?:$joinedKeywords)|\$)',
      caseSensitive: false);
}

RegExp _getReferencePartsRegex(
    List<String> issuePrefixes, bool issuePrefixesCaseSensitive) {
  if (issuePrefixes.isEmpty) {
    return RegExp(r'(?!.*)');
  }
  return RegExp(
      '(?:.*?)??\\s*([\\w-\\.\\/]*?)??(${issuePrefixes.join('|')})([\\w-]*\\d+)',
      caseSensitive: issuePrefixesCaseSensitive);
}

RegExp _getNotesRegex(List<String> noteKeywords) {
  if (noteKeywords.isEmpty) {
    return RegExp(r'(?!.*)');
  }
  final noteKeywordsSelection = noteKeywords.join('|');
  return RegExp(
    '^[\\s|*]*($noteKeywordsSelection)[:\\s]+(.*)',
    caseSensitive: false,
  );
}

String _append(String? src, String line) {
  if (src != null && src.isNotEmpty) {
    return '$src\n$line';
  } else {
    return line;
  }
}
