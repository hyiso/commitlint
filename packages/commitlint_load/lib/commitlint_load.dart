import 'dart:io';
import 'dart:isolate';

import 'package:commitlint_load/src/utils.dart';
import 'package:commitlint_types/commitlint_types.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

Future<Map<String, RuleConfig>?> load({
  LoadOptions? options,
}) async {
  if (options != null) {
    return await _parse(options);
  }
  return null;
}

Future<Map<String, RuleConfig>?> _parse(LoadOptions options) async {
  Map<String, RuleConfig>? rules;
  if (options.file != null) {
    String path = options.file!;
    Uri? uri;
    if (!options.file!.startsWith('package:')) {
      path = join(options.cwd, options.file);
      uri = toUri(path);
    } else {
      final packageUri = Uri.parse(path);
      uri = await Isolate.resolvePackageUri(packageUri);
    }
    if (uri != null) {
      final file = File.fromUri(uri);
      if (await file.exists()) {
        final yaml = loadYaml(await file.readAsString());
        String? include;
        if (yaml['include'] is String) {
          include = yaml['include'];
        }
        final rules = <String, RuleConfig>{};
        if (yaml['rules'] is Map) {
          final rulesMap = (yaml['rules'] as Map).cast<String, dynamic>();
          for (var entry in rulesMap.entries) {
            rules[entry.key] = extractRuleConfig(entry.value);
          }
        }

        while (include != null) {
          final upstream = await _parse(LoadOptions(cwd: dirname(include), file: include));
          if (upstream != null) {
            return {
              ...upstream,
              ...rules,
            };
          } else {
            return rules;
          }
        }
        ;
      }
    }
  }
  return rules;
}

class LoadOptions {
  /// Path to the config file to load.
  final String? file;

  /// The cwd to use when loading config from file parameter.
  final String cwd;

  LoadOptions({
    required this.cwd,
    this.file,
  });
}