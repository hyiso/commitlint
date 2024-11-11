import 'package:yaml/yaml.dart';

const _kHeaderPattern =
    r'^(?<type>\w*)(?:\((?<scope>.*)\))?!?: (?<subject>.*)$';
const _kHeaderCorrespondence = ['type', 'scope', 'subject'];

const _kReferenceActions = [
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

const _kIssuePrefixes = ['#'];
const _kNoteKeywords = ['BREAKING CHANGE', 'BREAKING-CHANGE'];
const _kMergePattern = r'^(Merge|merge)\s(.*)$';
const _kRevertPattern =
    r'^(?:Revert|revert:)\s"?(?<header>[\s\S]+?)"?\s*This reverts commit (?<hash>\w*)\.';
const _kRevertCorrespondence = ['header', 'hash'];

const _kMentionsPattern = r'@([\w-]+)';

class ParserOptions {
  final List<String> issuePrefixes;
  final List<String> noteKeywords;
  final List<String> referenceActions;
  final String headerPattern;
  final List<String> headerCorrespondence;
  final String revertPattern;
  final List<String> revertCorrespondence;
  final String mergePattern;
  final String mentionsPattern;

  const ParserOptions({
    this.issuePrefixes = _kIssuePrefixes,
    this.noteKeywords = _kNoteKeywords,
    this.referenceActions = _kReferenceActions,
    this.headerPattern = _kHeaderPattern,
    this.headerCorrespondence = _kHeaderCorrespondence,
    this.revertPattern = _kRevertPattern,
    this.revertCorrespondence = _kRevertCorrespondence,
    this.mergePattern = _kMergePattern,
    this.mentionsPattern = _kMentionsPattern,
  });

  ParserOptions copyWith(ParserOptions? other) {
    return ParserOptions(
      issuePrefixes: other?.issuePrefixes ?? issuePrefixes,
      noteKeywords: other?.noteKeywords ?? noteKeywords,
      referenceActions: other?.referenceActions ?? referenceActions,
      headerPattern: other?.headerPattern ?? headerPattern,
      headerCorrespondence: other?.headerCorrespondence ?? headerCorrespondence,
      revertPattern: other?.revertPattern ?? revertPattern,
      revertCorrespondence: other?.revertCorrespondence ?? revertCorrespondence,
      mergePattern: other?.mergePattern ?? mergePattern,
      mentionsPattern: other?.mentionsPattern ?? mentionsPattern,
    );
  }

  static ParserOptions fromYaml(YamlMap yaml) {
    return ParserOptions(
      issuePrefixes:
          List<String>.from(yaml['issuePrefixes'] ?? _kIssuePrefixes),
      noteKeywords: List<String>.from(yaml['noteKeywords'] ?? _kNoteKeywords),
      referenceActions:
          List<String>.from(yaml['referenceActions'] ?? _kReferenceActions),
      headerPattern: yaml['headerPattern'] ?? _kHeaderPattern,
      headerCorrespondence: List<String>.from(
          yaml['headerCorrespondence'] ?? _kHeaderCorrespondence),
      revertPattern: yaml['revertPattern'] ?? _kRevertPattern,
      revertCorrespondence: List<String>.from(
          yaml['revertCorrespondence'] ?? _kRevertCorrespondence),
      mergePattern: yaml['mergePattern'] ?? _kMergePattern,
      mentionsPattern: yaml['mentionsPattern'] ?? _kMentionsPattern,
    );
  }
}
