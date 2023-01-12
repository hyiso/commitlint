import '../packages/commitlint_cli/bin/commitlint_cli.dart' as cli;

// A copy of packages/commitlint_cli/bin/cli.dart
// This allows us to use commitlint_cli on itself during development.
void main(List<String> arguments) async {
  if (arguments.contains('--help') || arguments.contains('-h')) {
    // ignore_for_file: avoid_print
    print('---------------------------------------------------------');
    print('| You are running a local development version of commitlint_cli. |');
    print('---------------------------------------------------------');
    print('');
  }
  cli.main(arguments);
}
