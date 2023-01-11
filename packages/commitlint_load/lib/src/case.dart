
/// 'lower-case'    // default
/// 'upper-case'    // UPPERCASE
/// 'camel-case'    // camelCase
/// 'kebab-case'    // kebab-case
/// 'pascal-case'   // PascalCase
/// 'sentence-case' // Sentence case
/// 'snake-case'    // snake_case
/// 'start-case'    // Start Case
class Case {
  final String value;

  Case._(this.value);

  static final Case lower = Case._('lower-case');

  static final Case upper = Case._('upper-case');

  static final Case camel = Case._('camel-case');

  static final Case kebab = Case._('kebab-case');

  static final Case pascal = Case._('pascal-case');

  static final Case sentence = Case._('sentence-case');

  static final Case snake = Case._('snake-case');

  static final Case start = Case._('start-case');
}