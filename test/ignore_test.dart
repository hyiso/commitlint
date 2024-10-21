import 'package:commitlint_cli/src/is_ignored.dart';
import 'package:test/test.dart';

void main() {
  test('Should ignore configurated multi-line merge message', () async {
    final message = '''Merge branch 'develop' into feature/xyz

# Conflicts:
#	xyz.yaml
''';
    final result = isIgnored(message, defaultIgnores: true);
    expect(result, true);
  });
}
