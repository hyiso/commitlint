import 'lint.dart';

class FormattableReport {
  final bool valid;
  final int errorCount;
  final int warningCount;
  final List<LintOutcome> results;

  FormattableReport({
    required this.valid,
    required this.errorCount,
    required this.warningCount,
    required this.results,
  });

  factory FormattableReport.empty() => FormattableReport(
        valid: true,
        errorCount: 0,
        warningCount: 0,
        results: [],
      );

  operator +(LintOutcome result) {
    return FormattableReport(
        valid: result.valid && valid,
        errorCount: errorCount + result.errors.length,
        warningCount: warningCount + result.warnings.length,
        results: results..add(result));
  }
}
