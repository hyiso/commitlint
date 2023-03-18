import 'package:commitlint_cli/commitlint.dart';

Future<void> main(List<String> args) async {
  await CommitLintRunner().run(args);
}
