

import 'package:commitlint_cli/commitlint_cli.dart';

Future<void> main(List<String> args) async {
  await CommitLintRunner().run(args);
}