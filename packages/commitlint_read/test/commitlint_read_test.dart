import 'dart:io';

import 'package:commitlint_read/commitlint_read.dart';
import 'package:path/path.dart' show join;
import 'package:test/test.dart';
import 'git.dart' as git;

void main() {
  test('get edit commit message specified by the `edit` option', () async {
    final dir = await git.bootstrap();
    await File(join(dir, 'commit-msg-file')).writeAsString('foo');
    final commits = await read(edit: 'commit-msg-file', workingDirectory: dir);
    expect(commits, equals(['foo']));
  });

  test('get edit commit message from git root', () async {
    final dir = await git.bootstrap();
    await File(join(dir, 'alpha.txt')).writeAsString('alpha');
    await Process.run('git', ['add', '.'], workingDirectory: dir);
    await Process.run('git', ['commit', '-m', 'alpha'], workingDirectory: dir);
    final commits = await read(workingDirectory: dir);
    expect(commits, equals(['alpha']));
  });

  test('get history commit messages', () async {
    final dir = await git.bootstrap();
    await File(join(dir, 'alpha.txt')).writeAsString('alpha');
    await Process.run('git', ['add', 'alpha.txt'], workingDirectory: dir);
    await Process.run('git', ['commit', '-m', 'alpha'], workingDirectory: dir);
    await Process.run('git', ['rm', 'alpha.txt'], workingDirectory: dir);
    await Process.run('git', ['commit', '-m', 'remove alpha'],
        workingDirectory: dir);
    final commits = await read(workingDirectory: dir);
    expect(commits, equals(['remove alpha', 'alpha']));
  });

  test('get edit commit message from git subdirectory', () async {
    final dir = await git.bootstrap();
    await Directory(join(dir, 'beta')).create(recursive: true);
    await File(join(dir, 'beta/beta.txt')).writeAsString('beta');

    await Process.run('git', ['add', '.'], workingDirectory: dir);
    await Process.run('git', ['commit', '-m', 'beta'], workingDirectory: dir);

    final commits = await read(workingDirectory: dir);
    expect(commits, equals(['beta']));
  });

  test('get edit commit message while skipping first commit', () async {
    final dir = await git.bootstrap();
    await Directory(join(dir, 'beta')).create(recursive: true);
    await File(join(dir, 'beta/beta.txt')).writeAsString('beta');

    await File(join(dir, 'alpha.txt')).writeAsString('alpha');
    await Process.run('git', ['add', 'alpha.txt'], workingDirectory: dir);
    await Process.run('git', ['commit', '-m', 'alpha'], workingDirectory: dir);
    await File(join(dir, 'beta.txt')).writeAsString('beta');
    await Process.run('git', ['add', 'beta.txt'], workingDirectory: dir);
    await Process.run('git', ['commit', '-m', 'beta'], workingDirectory: dir);
    await File(join(dir, 'gamma.txt')).writeAsString('gamma');
    await Process.run('git', ['add', 'gamma.txt'], workingDirectory: dir);
    await Process.run('git', ['commit', '-m', 'gamma'], workingDirectory: dir);

    final commits = await read(
        from: 'HEAD~2',
        workingDirectory: dir,
        gitLogArgs: '--skip 1'.split(' '));
    expect(commits, equals(['beta']));
  });
}
