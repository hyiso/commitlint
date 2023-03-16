import 'package:commitlint_cli/src/parse.dart';
import 'package:test/test.dart';

void main() {
  test('throws when called with empty message', () {
    expect(() => parse(''), throwsArgumentError);
  });
  test('returns object with expected keys', () {
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
  test('uses default options', () {
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

  test('uses custom opts parser', () {
    final message = 'type(scope)-subject';
    final commit = parse(message, headerPattern: r'^(\w*)(?:\((.*)\))?-(.*)$');
    expect(commit.body, equals(null));
    expect(commit.footer, equals(null));
    expect(commit.header, equals('type(scope)-subject'));
    expect(commit.mentions, equals([]));
    expect(commit.notes, equals([]));
    expect(commit.references, equals([]));
    expect(commit.type, equals('type'));
    expect(commit.scope, equals('scope'));
    expect(commit.subject, equals('subject'));
  });

  test('does not merge array properties with custom opts', () {
    final message = 'type: subject';
    final commit = parse(message,
        headerPattern: r'^(.*):\s(.*)$',
        headerCorrespondence: ['type', 'subject']);
    expect(commit.body, equals(null));
    expect(commit.footer, equals(null));
    expect(commit.header, equals('type: subject'));
    expect(commit.mentions, equals([]));
    expect(commit.notes, equals([]));
    expect(commit.references, equals([]));
    expect(commit.type, equals('type'));
    expect(commit.scope, equals(null));
    expect(commit.subject, equals('subject'));
  });
  test('supports scopes with /', () {
    const message = 'type(some/scope): subject';
    final commit = parse(message);
    expect(commit.scope, equals('some/scope'));
    expect(commit.subject, equals('subject'));
  });
  test('registers inline #', () {
    const message =
        'type(some/scope): subject #reference\n# some comment\nthings #reference';
    final commit = parse(message, commentChar: '#');
    expect(commit.subject, equals('subject #reference'));
    expect(commit.body, equals('things #reference'));
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
  test('parses custom references', () {
    final message = '#1 some subject PREFIX-2';
    final commit = parse(message, issuePrefixes: ['PREFIX-']);
    expect(commit.references.any((ref) => ref.issue == '1'), false);
    final ref = commit.references.firstWhere((ref) => ref.issue == '2');
    expect(ref.prefix, equals('PREFIX-'));
    expect(ref.owner, equals(null));
    expect(ref.action, equals(''));
    expect(ref.repository, equals(null));
    expect(ref.raw, equals('#1 some subject PREFIX-2'));
  });
  test('works with chinese scope by default', () {
    const message = 'fix(面试评价): 测试';
    final commit = parse(message, commentChar: '#');
    expect(commit.subject, isNotNull);
    expect(commit.scope, isNotNull);
  });
  test('does not work with chinese scopes with incompatible pattern', () {
    const message = 'fix(面试评价): 测试';
    final commit =
        parse(message, headerPattern: r'^(\w*)(?:\(([a-z]*)\))?: (.*)$');
    expect(commit.subject, equals(null));
    expect(commit.scope, equals(null));
  });
}
