/// Support for doing something awesome.
///
/// More dartdocs go here.
library commitlint_load;

import 'dart:io';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import 'src/config.dart';
import 'src/option.dart';
import 'src/rule.dart';
import 'src/seed.dart';

Future<Config> load({
  required Seed seed,
  LoadOptions? options,
}) async {
  if (options != null) {
    final path = join(options.cwd, options.file);
    final file = File(path);
    if (await file.exists()) {
      final yaml = loadYaml(await file.readAsString());
    }
  }
  final rules = <String, Rule>{};
  return Config(
    rules: rules,
    include:  seed.include ?? options?
  )
}
