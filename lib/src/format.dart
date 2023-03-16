import 'dart:io';

import 'package:colorize/colorize.dart';
import 'types.dart';

const _kDefaultSigns = [' ', '⚠', '✖'];
final _defaultColors = [Styles.WHITE, Styles.YELLOW, Styles.RED];
final isDebug = Platform.environment['DEBUG'] == 'true';

///
/// Format commitlint [report] to formatted output message.
///
String format({
  required FormattableReport report,
}) {
  return report.results
      .map((result) => [..._formatInput(result), ..._formatResult(result)])
      .fold<Iterable<String>>(
          <String>[],
          (previousValue, element) =>
              [...previousValue, ...element]).join('\n');
}

List<String> _formatInput(LintOutcome result) {
  final sign = '⧗';
  final decoration = Colorize(sign).darkGray();
  final commitText =
      result.errors.isNotEmpty ? result.input : result.input.split('\n').first;
  final decoratedInput = Colorize(commitText).bold();
  final hasProblem = result.errors.isNotEmpty || result.warnings.isNotEmpty;
  return hasProblem || isDebug ? ['$decoration  input: $decoratedInput'] : [];
}

List<String> _formatResult(LintOutcome result) {
  final problems = [...result.errors, ...result.warnings].map((problem) {
    final sign = _kDefaultSigns[problem.level.index];
    final color = _defaultColors[problem.level.index];
    final decoration = Colorize().apply(color, sign);
    final name = Colorize(problem.name).darkGray();
    return '$decoration  ${problem.message} $name';
  });

  final sign = _selectSign(result);
  final color = _selectColor(result);
  final decoration = Colorize().apply(color, sign);
  final summary = problems.isNotEmpty || isDebug
      ? '$decoration  found ${result.errors.length} error(s), ${result.warnings.length} warning(s)'
      : '';
  final fmtSummary = summary.isNotEmpty ? Colorize(summary).bold() : summary;
  return [
    ...problems,
    if (problems.isNotEmpty) '',
    fmtSummary.toString(),
    if (problems.isNotEmpty) '',
  ];
}

String _selectSign(LintOutcome result) {
  if (result.errors.isNotEmpty) {
    return '✖';
  }
  return result.warnings.isNotEmpty ? '⚠' : '✔';
}

Styles _selectColor(LintOutcome result) {
  if (result.errors.isNotEmpty) {
    return Styles.RED;
  }
  return result.warnings.isNotEmpty ? Styles.YELLOW : Styles.GREEN;
}
