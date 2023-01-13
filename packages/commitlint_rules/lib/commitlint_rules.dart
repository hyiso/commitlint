import 'package:commitlint_types/commitlint_types.dart';

import 'src/rules.dart';

Map<String, Rule> get supportedRules => {
  'type-case': caseRule(CommitComponent.type),
  'type-empty': emptyRule(CommitComponent.type),
  'type-enum': enumRule(CommitComponent.type),
  'type-max-length': maxLengthRule(CommitComponent.type),
  'type-min-length': minLengthRule(CommitComponent.type),

  'scope-case': caseRule(CommitComponent.scope),
  'scope-empty': emptyRule(CommitComponent.scope),
  'scope-enum': enumRule(CommitComponent.scope),
  'scope-max-length': maxLengthRule(CommitComponent.scope),
  'scope-min-length': minLengthRule(CommitComponent.scope),

  'header-case': caseRule(CommitComponent.header),
  'header-full-stop': fullStopRule(CommitComponent.header),
  'header-max-length': maxLengthRule(CommitComponent.header),
  'header-min-length': minLengthRule(CommitComponent.header),

  'body-case': caseRule(CommitComponent.body),
  'body-empty': emptyRule(CommitComponent.body),
  'body-full-stop': fullStopRule(CommitComponent.body),
  'body-leading-blank': leadingBlankRule(CommitComponent.body),
  'body-max-length': maxLengthRule(CommitComponent.body),
  'body-max-line-length': maxLineLengthRule(CommitComponent.body),
  'body-min-length': minLengthRule(CommitComponent.body),

  'footer-case': caseRule(CommitComponent.footer),
  'footer-empty': emptyRule(CommitComponent.footer),
  'footer-leading-blank': leadingBlankRule(CommitComponent.footer),
  'footer-max-length': maxLengthRule(CommitComponent.footer),
  'footer-max-line-length': maxLineLengthRule(CommitComponent.footer),
  'footer-min-length': minLengthRule(CommitComponent.footer),
};
