import 'package:commitlint_cli/src/runner.dart';

Future<void> main(List<String> args) async {
  await CommitLintRunner().run(args);
}
