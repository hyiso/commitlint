import 'dart:io' show File;
import 'package:path/path.dart' show join;
import 'package:yaml/yaml.dart' show YamlMap, loadYaml;

Future<void> main() async {
  final outputPath =
      join('packages', 'commitlint_cli', 'lib', 'src', 'version.g.dart');
  final outputFile = File(outputPath);
  if (!outputFile.existsSync()) {
    outputFile.createSync(recursive: true);
  }
  // ignore: avoid_print
  print('Updating generated file $outputPath');
  final pubspec = File(join('packages', 'commitlint_cli', 'pubspec.yaml'));
  final yamlMap = loadYaml(pubspec.readAsStringSync()) as YamlMap;
  final currentVersion = yamlMap['version'] as String;
  final fileContents = '''
/// This file is generated. Do not manually edit.
const kCurrentVersion = '$currentVersion';
''';
  outputFile.writeAsStringSync(fileContents);
  // ignore: avoid_print
  print('Updated version to $currentVersion in generated file $outputPath');
}
