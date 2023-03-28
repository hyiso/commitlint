// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'package:collection/collection.dart';
import 'package:commitlint_cli/src/parse.dart';
import 'package:commitlint_cli/src/types/commit.dart';
import 'package:test/test.dart';

void main() {
  group('parse', () {
    test('throws when called with empty message', () {
      expect(() => parse(''), throwsArgumentError);
      expect(() => parse('\n'), throwsArgumentError);
      expect(() => parse(' '), throwsArgumentError);
    });
    test('supports plain message', () {
      final message = 'message';
      final commit = parse(message);
      expect(commit.body, equals(null));
      expect(commit.footer, equals(null));
      expect(commit.header, equals('message'));
      expect(commit.mentions, equals([]));
      expect(commit.notes, equals([]));
      expect(commit.references, equals([]));
      expect(commit.type, equals(null));
      expect(commit.scope, equals(null));
      expect(commit.subject, equals(null));
    });
    test('supports `type(scope): subject`', () {
      final message = 'type(scope): subject';
      final commit = parse(message);
      expect(commit.body, equals(null));
      expect(commit.footer, equals(null));
      expect(commit.header, equals('type(scope): subject'));
      expect(commit.mentions, equals([]));
      expect(commit.notes, equals([]));
      expect(commit.references, equals([]));
      expect(commit.type, equals('type'));
      expect(commit.scope, equals('scope'));
      expect(commit.subject, equals('subject'));
    });
    test('supports `type!: subject`', () {
      final message = 'type!: subject';
      final commit = parse(message);
      expect(commit.body, equals(null));
      expect(commit.footer, equals(null));
      expect(commit.header, equals('type!: subject'));
      expect(commit.mentions, equals([]));
      expect(commit.notes, equals([]));
      expect(commit.references, equals([]));
      expect(commit.type, equals('type'));
      expect(commit.scope, equals(null));
      expect(commit.subject, equals('subject'));
    });
    test('supports `type(scope)!: subject`', () {
      final message = 'type(scope)!: subject';
      final commit = parse(message);
      expect(commit.body, equals(null));
      expect(commit.footer, equals(null));
      expect(commit.header, equals('type(scope)!: subject'));
      expect(commit.mentions, equals([]));
      expect(commit.notes, equals([]));
      expect(commit.references, equals([]));
      expect(commit.type, equals('type'));
      expect(commit.scope, equals('scope'));
      expect(commit.subject, equals('subject'));
    });
    test('supports scopes with /', () {
      const message = 'type(some/scope): subject';
      final commit = parse(message);
      expect(commit.scope, equals('some/scope'));
      expect(commit.subject, equals('subject'));
    });

    test('keep -side notes- in the body section', () {
      final header = "type(some/scope): subject";
      final body =
          "CI on master branch caught this:\n\n```\nUnhandled Exception:\nSystem.AggregateException: One or more errors occurred. (Some problem when connecting to 'api.mycryptoapi.com/eth')\n\n--- End of stack trace from previous location where exception was thrown ---\n\nat GWallet.Backend.FSharpUtil.ReRaise (System.Exception ex) [0x00000] in /Users/runner/work/geewallet/geewallet/src/GWallet.Backend/FSharpUtil.fs:206\n...\n```";
      final message = "$header\n\n$body";
      final commit = parse(message);
      expect(commit.body, equals(body));
    });
    test('parses references leading subject', () {
      const message = '#1 some subject';
      final commit = parse(message);
      expect(commit.references.first.issue, equals('1'));
    });
    test('works with chinese scope by default', () {
      const message = 'fix(面试评价): 测试';
      final commit = parse(message);
      expect(commit.subject, isNotNull);
      expect(commit.scope, isNotNull);
    });
    test('should trim extra newlines', () {
      final commit = parse(
          '\n\n\n\n\n\n\nfeat(scope): broadcast destroy event on scope destruction\n\n\n' +
              '\n\n\nperf testing shows that in chrome this change adds 5-15% overhead\n' +
              '\n\n\nwhen destroying 10k nested scopes where each scope has a destroy listener\n\n' +
              '\n\n\n\nBREAKING CHANGE: some breaking change\n' +
              '\n\n\n\nBREAKING CHANGE: An awesome breaking change\n\n\n```\ncode here\n```' +
              '\n\nfixes #1\n' +
              '\n\n\nfixed #25\n\n\n\n\n');
      expect(commit.merge, equals(null));
      expect(commit.revert, equals(null));
      expect(commit.header,
          equals('feat(scope): broadcast destroy event on scope destruction'));
      expect(commit.type, equals('feat'));
      expect(commit.scope, equals('scope'));
      expect(commit.subject,
          equals('broadcast destroy event on scope destruction'));
      expect(
          commit.body,
          equals(
              'perf testing shows that in chrome this change adds 5-15% overhead\n\n\n\nwhen destroying 10k nested scopes where each scope has a destroy listener'));
      expect(
          commit.footer,
          equals(
              'BREAKING CHANGE: some breaking change\n\n\n\n\nBREAKING CHANGE: An awesome breaking change\n\n\n```\ncode here\n```\n\nfixes #1\n\n\n\nfixed #25'));
      expect(commit.mentions, equals([]));

      expect(commit.notes.first.title, equals('BREAKING CHANGE'));
      expect(commit.notes.first.text, equals('some breaking change'));
      expect(commit.notes.last.title, equals('BREAKING CHANGE'));
      expect(commit.notes.last.text,
          equals('An awesome breaking change\n\n\n```\ncode here\n```'));
      expect(
          ListEquality().equals(commit.references, [
            CommitReference(
                raw: '#1',
                prefix: '#',
                action: 'fixes',
                owner: null,
                repository: null,
                issue: '1'),
            CommitReference(
                raw: '#25',
                prefix: '#',
                action: 'fixed',
                owner: null,
                repository: null,
                issue: '25'),
          ]),
          true);
    });

    test('should keep spaces', () {
      final commit = parse(' feat(scope): broadcast destroy event on scope destruction \n' +
          ' perf testing shows that in chrome this change adds 5-15% overhead \n\n' +
          ' when destroying 10k nested scopes where each scope has a destroy listener \n' +
          '         BREAKING CHANGE: some breaking change         \n\n' +
          '   BREAKING CHANGE: An awesome breaking change\n\n\n```\ncode here\n```' +
          '\n\n    fixes   #1\n');
      expect(commit.merge, equals(null));
      expect(commit.revert, equals(null));
      expect(
          commit.header,
          equals(
              ' feat(scope): broadcast destroy event on scope destruction '));
      expect(commit.type, equals(null));
      expect(commit.scope, equals(null));
      expect(commit.subject, equals(null));
      expect(
          commit.body,
          equals(
              ' perf testing shows that in chrome this change adds 5-15% overhead \n\n when destroying 10k nested scopes where each scope has a destroy listener '));
      expect(
          commit.footer,
          equals(
              '         BREAKING CHANGE: some breaking change         \n\n   BREAKING CHANGE: An awesome breaking change\n\n\n```\ncode here\n```\n\n    fixes   #1'));
      expect(commit.mentions, equals([]));
      expect(commit.notes.first.title, equals('BREAKING CHANGE'));
      expect(commit.notes.first.text, equals('some breaking change         '));
      expect(commit.notes.last.title, equals('BREAKING CHANGE'));
      expect(commit.notes.last.text,
          equals('An awesome breaking change\n\n\n```\ncode here\n```'));
      expect(
          ListEquality().equals(commit.references, [
            CommitReference(
              action: 'fixes',
              owner: null,
              repository: null,
              issue: '1',
              raw: '#1',
              prefix: '#',
            ),
          ]),
          true);
    });

    test('should ignore gpg signature lines', () {
      final commit = parse('gpg: Signature made Thu Oct 22 12:19:30 2020 EDT\n' +
          'gpg:                using RSA key ABCDEF1234567890\n' +
          'gpg: Good signature from "Author <author@example.com>" [ultimate]\n' +
          'feat(scope): broadcast destroy event on scope destruction\n' +
          'perf testing shows that in chrome this change adds 5-15% overhead\n' +
          'when destroying 10k nested scopes where each scope has a destroy listener\n' +
          'BREAKING CHANGE: some breaking change\n' +
          'fixes #1\n');
      expect(commit.merge, equals(null));
      expect(commit.revert, equals(null));
      expect(commit.header,
          equals('feat(scope): broadcast destroy event on scope destruction'));
      expect(commit.type, equals('feat'));
      expect(commit.scope, equals('scope'));
      expect(commit.subject,
          equals('broadcast destroy event on scope destruction'));
      expect(
          commit.body,
          equals(
              'perf testing shows that in chrome this change adds 5-15% overhead\nwhen destroying 10k nested scopes where each scope has a destroy listener'));
      expect(commit.footer,
          equals('BREAKING CHANGE: some breaking change\nfixes #1'));
      expect(commit.mentions, equals(['example']));
      expect(commit.notes.single.title, equals('BREAKING CHANGE'));
      expect(commit.notes.single.text, equals('some breaking change'));
      expect(
          ListEquality().equals(commit.references, [
            CommitReference(
              action: 'fixes',
              owner: null,
              repository: null,
              issue: '1',
              raw: '#1',
              prefix: '#',
            ),
          ]),
          true);
    });

    test('should truncate from scissors line', () {
      final commit = parse('this is some header before a scissors-line\n' +
          '# ------------------------ >8 ------------------------\n' +
          'this is a line that should be truncated\n');
      expect(commit.body, equals(null));
    });

    test('should keep header before scissor line', () {
      final commit = parse('this is some header before a scissors-line\n' +
          '# ------------------------ >8 ------------------------\n' +
          'this is a line that should be truncated\n');
      expect(
          commit.header, equals('this is some header before a scissors-line'));
    });

    test('should keep body before scissor line', () {
      final commit = parse('this is some header before a scissors-line\n' +
          'this is some body before a scissors-line\n' +
          '# ------------------------ >8 ------------------------\n' +
          'this is a line that should be truncated\n');
      expect(commit.body, equals('this is some body before a scissors-line'));
    });

    group('merge commits', () {
      final githubCommit = parse(
          'Merge pull request #1 from user/feature/feature-name\n' +
              '\n' +
              'feat(scope): broadcast destroy event on scope destruction\n' +
              '\n' +
              'perf testing shows that in chrome this change adds 5-15% overhead\n' +
              'when destroying 10k nested scopes where each scope has a destroy listener');

      test('should parse header in GitHub like pull request', () {
        expect(
            githubCommit.header,
            equals(
                'feat(scope): broadcast destroy event on scope destruction'));
      });

      test('should understand header parts in GitHub like pull request', () {
        expect(githubCommit.type, equals('feat'));
        expect(githubCommit.scope, equals('scope'));
        expect(githubCommit.subject,
            equals('broadcast destroy event on scope destruction'));
      });

      test('should understand merge parts in GitHub like pull request', () {
        expect(githubCommit.merge,
            equals('Merge pull request #1 from user/feature/feature-name'));
      });

      final gitlabCommit = parse(
          'Merge branch \'feature/feature-name\' into \'master\'\r\n' +
              '\r\n' +
              'feat(scope): broadcast destroy event on scope destruction\r\n' +
              '\r\n' +
              'perf testing shows that in chrome this change adds 5-15% overhead\r\n' +
              'when destroying 10k nested scopes where each scope has a destroy listener\r\n' +
              '\r\n' +
              'See merge request !1');
      test('should parse header in GitLab like merge request', () {
        expect(
            gitlabCommit.header,
            equals(
                'feat(scope): broadcast destroy event on scope destruction'));
      });

      test('should understand header parts in GitLab like merge request', () {
        expect(gitlabCommit.type, equals('feat'));
        expect(gitlabCommit.scope, equals('scope'));
        expect(gitlabCommit.subject,
            equals('broadcast destroy event on scope destruction'));
      });

      test('should understand merge parts in GitLab like merge request', () {
        expect(gitlabCommit.merge,
            equals('Merge branch \'feature/feature-name\' into \'master\''));
      });

      test('does not throw if merge commit has no header', () {
        parse('Merge branch \'feature\'');
      });
    });
  });
}
