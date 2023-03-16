import 'types/commit.dart';

///
/// Parse Commit Message String to Convensional Commit
///

const _kDefaultHeaderPattern = r'^(\w*)(?:\((.*)\))?: (.*)$';
const _kDefaultHeaderCorrespondence = ['type', 'scope', 'subject'];

const _kDefaultReferenceActions = [
  'close',
  'closes',
  'closed',
  'fix',
  'fixes',
  'fixed',
  'resolve',
  'resolves',
  'resolved'
];

const _kDefaultIssuePrefixes = ['#'];
const _kDefaultNoteKeywords = ['BREAKING CHANGE', 'BREAKING-CHANGE'];

const _kDefaultFieldPattern = r'^-(.*?)-$';

const _kDefaultRevertPattern =
    r'^(?:Revert|revert:)\s"?([\s\S]+?)"?\s*This reverts commit (\w*)\.';
const _kDefaultRevertCorrespondence = ['header', 'hash'];

Commit parse(String raw,
    {String headerPattern = _kDefaultHeaderPattern,
    List<String> headerCorrespondence = _kDefaultHeaderCorrespondence,
    List<String> referenceActions = _kDefaultReferenceActions,
    List<String> issuePrefixes = _kDefaultIssuePrefixes,
    List<String> noteKeywords = _kDefaultNoteKeywords,
    String fieldPattern = _kDefaultFieldPattern,
    String revertPattern = _kDefaultRevertPattern,
    List<String> revertCorrespondence = _kDefaultRevertCorrespondence,
    String? commentChar}) {
  final message = raw.trim();
  if (message.isEmpty) {
    throw ArgumentError.value(raw, 'raw message', 'must have content.');
  }
  String? body;
  String? footer;
  List<String> mentions = [];
  List<CommitNote> notes = [];
  List<CommitReference> references = [];
  Map<String, String?>? revert;
  final lines = truncateToScissor(message.split(RegExp(r'\r?\n')))
      .where(_gpgFilter)
      .toList();
  if (commentChar != null) {
    lines.removeWhere((line) => line.startsWith(commentChar));
  }
  final header = lines.removeAt(0);
  final headerMatch = RegExp(headerPattern).matchAsPrefix(header);
  final headerParts = <String, String?>{};
  if (headerMatch != null) {
    for (var i = 0; i < headerCorrespondence.length; i++) {
      headerParts[headerCorrespondence[i]] = headerMatch.group(i + 1);
    }
  }
  final referencesPattern = getReferenceRegex(referenceActions);
  final referencePartsPattern = getReferencePartsRegex(issuePrefixes, false);
  references.addAll(getReferences(header,
      referencesPattern: referencesPattern,
      referencePartsPattern: referencePartsPattern));

  bool continueNote = false;
  bool isBody = true;
  final notesPattern = getNotesRegex(noteKeywords);

  /// body or footer
  for (var line in lines) {
    bool referenceMatched = false;
    final notesMatch = notesPattern.matchAsPrefix(line);
    if (notesMatch != null) {
      continueNote = true;
      isBody = false;
      footer = append(footer, line);
      notes.add(CommitNote(
          title: notesMatch.group(1)!, text: notesMatch.group(2)!.trim()));
      break;
    }

    final lineReferences = getReferences(
      line,
      referencesPattern: referencesPattern,
      referencePartsPattern: referencePartsPattern,
    );

    if (lineReferences.isNotEmpty) {
      isBody = false;
      referenceMatched = true;
      continueNote = false;
    }

    references.addAll(lineReferences);

    if (referenceMatched) {
      footer = append(footer, line);
      break;
    }

    if (continueNote) {
      notes.last.text = append(notes.last.text, line).trim();
      footer = append(footer, line);
      break;
    }
    if (isBody) {
      body = append(body, line);
    } else {
      footer = append(footer, line);
    }
  }

  Match? mentionsMatch;
  final mentionsPattern = RegExp(r'@([\w-]+)');
  while ((mentionsMatch =
          mentionsPattern.matchAsPrefix(raw, mentionsMatch?.end ?? 0)) !=
      null) {
    mentions.add(mentionsMatch!.group(1)!);
  }

  // does this commit revert any other commit?
  final revertMatch = raw.matchAsPrefix(revertPattern);
  if (revertMatch != null) {
    revert = {};
    for (var i = 0; i < revertCorrespondence.length; i++) {
      revert[revertCorrespondence[i]] = revertMatch.group(i + 1);
    }
  }

  return Commit(
    header: header,
    type: headerParts['type'],
    scope: headerParts['scope'],
    subject: headerParts['subject'],
    body: body?.trim(),
    footer: footer?.trim(),
    notes: notes,
    references: references,
    mentions: mentions,
    revert: revert,
  );
}

bool _gpgFilter(String line) {
  return !RegExp(r'^\s*gpg:').hasMatch(line);
}

final _kMatchAll = RegExp(r'()(.+)', caseSensitive: false);

const _kScissor = '# ------------------------ >8 ------------------------';

List<String> truncateToScissor(List<String> lines) {
  final scissorIndex = lines.indexOf(_kScissor);

  if (scissorIndex == -1) {
    return lines;
  }

  return lines.sublist(0, scissorIndex);
}

List<CommitReference> getReferences(
  String input, {
  required Pattern referencesPattern,
  required Pattern referencePartsPattern,
}) {
  final references = <CommitReference>[];
  Match? referenceSentences;
  Match? referenceMatch;

  final reApplicable = referencesPattern.allMatches(input).isNotEmpty
      ? referencesPattern
      : _kMatchAll;
  while ((referenceSentences =
          reApplicable.matchAsPrefix(input, referenceSentences?.end ?? 0)) !=
      null) {
    final action = referenceSentences!.group(1)!;
    final sentence = referenceSentences.group(2)!;
    while ((referenceMatch = referencePartsPattern.matchAsPrefix(
            sentence, referenceMatch?.end ?? 0)) !=
        null) {
      String? owner;
      String? repository = referenceMatch!.group(1);
      final ownerRepo = repository?.split('/') ?? [];

      if (ownerRepo.length > 1) {
        owner = ownerRepo.removeAt(0);
        repository = ownerRepo.join('/');
      }
      references.add(CommitReference(
        raw: referenceMatch.group(0)!,
        action: action,
        owner: owner,
        repository: repository,
        issue: referenceMatch.group(3),
        prefix: referenceMatch.group(2)!,
      ));
    }
  }
  return references;
}

Pattern getReferenceRegex(Iterable<String> referenceActions) {
  if (referenceActions.isEmpty) {
    // matches everything
    return RegExp(r'()(.+)', caseSensitive: false); //gi
  }

  final joinedKeywords = referenceActions.join('|');
  return RegExp('($joinedKeywords)(?:\\s+(.*?))(?=(?:$joinedKeywords)|\$)',
      caseSensitive: false);
}

Pattern getReferencePartsRegex(
    List<String> issuePrefixes, bool issuePrefixesCaseSensitive) {
  if (issuePrefixes.isEmpty) {
    return RegExp(r'(?!.*)');
  }
  return RegExp(
      '(?:.*?)??\\s*([\\w-\\.\\/]*?)??(${issuePrefixes.join('|')})([\\w-]*\\d+)',
      caseSensitive: issuePrefixesCaseSensitive);
}

Pattern getNotesRegex(List<String> noteKeywords) {
  if (noteKeywords.isEmpty) {
    return RegExp(r'(?!.*)');
  }
  final noteKeywordsSelection = noteKeywords.join('|');
  return RegExp('^[\\s|*]*($noteKeywordsSelection)[:\\s]+(.*)',
      caseSensitive: false);
}

String append(String? src, String line) {
  if (src != null) {
    return '$src\n$line';
  } else {
    return line;
  }
}
