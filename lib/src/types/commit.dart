/// The Commit Class
class Commit {
  final String header;
  final String? type;
  final String? scope;
  final String? subject;
  final String? body;
  final String? footer;
  final List<String> mentions;
  final List<CommitNote> notes;
  final List<CommitReference> references;
  final dynamic revert;
  final dynamic merge;

  Commit({
    required this.header,
    this.type,
    this.scope,
    this.subject,
    this.body,
    this.footer,
    this.mentions = const [],
    this.notes = const [],
    this.references = const [],
    this.revert,
    this.merge,
  });

  Commit.empty()
      : header = '',
        type = null,
        scope = null,
        subject = null,
        body = null,
        footer = null,
        mentions = [],
        notes = [],
        references = [],
        revert = null,
        merge = null;

  T? componentRaw<T>(CommitComponent component) {
    switch (component) {
      case CommitComponent.type:
        return type as T?;
      case CommitComponent.scope:
        return scope as T?;
      case CommitComponent.subject:
        return subject as T?;
      case CommitComponent.header:
        return header as T?;
      case CommitComponent.body:
        return body as T?;
      case CommitComponent.footer:
        return footer as T?;
    }
  }
}

enum CommitComponent {
  type,
  scope,
  subject,
  header,
  body,
  footer,
}

/// Commit Note
class CommitNote {
  final String title;
  String text;
  CommitNote({required this.title, required this.text});
}

/// Commit Reference
class CommitReference {
  final String raw;
  final String prefix;
  final String? action;
  final String? owner;
  final String? repository;
  final String? issue;
  CommitReference({
    required this.raw,
    required this.prefix,
    this.action,
    this.owner,
    this.repository,
    this.issue,
  });

  @override
  operator ==(other) {
    return other is CommitReference &&
        raw == other.raw &&
        prefix == other.prefix &&
        action == other.action &&
        owner == other.owner &&
        repository == other.repository &&
        issue == other.issue;
  }

  @override
  int get hashCode => raw.hashCode;
}
