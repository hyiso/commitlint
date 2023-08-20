import 'package:ansi/ansi.dart';
import 'package:verbose/verbose.dart';
import 'types/format.dart';
import 'types/lint.dart';

const _kDefaultSigns = [' ', '⚠', '✖'];
final _defaultColors = [white, yellow, red];

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
  final decoration = gray(sign);
  final commitText =
      result.errors.isNotEmpty ? result.input : result.input.split('\n').first;
  final decoratedInput = bold(commitText);
  final hasProblem = result.errors.isNotEmpty || result.warnings.isNotEmpty;
  return hasProblem || Verbose.enabled
      ? ['$decoration  input: $decoratedInput']
      : [];
}

List<String> _formatResult(LintOutcome result) {
  final problems = [...result.errors, ...result.warnings].map((problem) {
    final sign = _kDefaultSigns[problem.level.index];
    final color = _defaultColors[problem.level.index];
    final decoration = color(sign);
    final name = gray(problem.name);
    return '$decoration  ${problem.message} $name';
  });

  final sign = _selectSign(result);
  final color = _selectColor(result);
  final decoration = color(sign);
  final summary = problems.isNotEmpty || Verbose.enabled
      ? '$decoration  found ${result.errors.length} error(s), ${result.warnings.length} warning(s)'
      : '';
  final fmtSummary = summary.isNotEmpty ? bold(summary) : summary;
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

String Function(String) _selectColor(LintOutcome result) {
  if (result.errors.isNotEmpty) {
    return red;
  }
  return result.warnings.isNotEmpty ? yellow : green;
}
