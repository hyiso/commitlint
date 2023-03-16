/// 'lower-case'    // default
/// 'upper-case'    // UPPERCASE
/// 'camel-case'    // camelCase
/// 'kebab-case'    // kebab-case
/// 'pascal-case'   // PascalCase
/// 'sentence-case' // Sentence case
/// 'snake-case'    // snake_case
/// 'capital-case'    // Start Case
enum Case {
  lower, // default
  upper, // UPPERCASE
  camel, // camelCase
  kebab, // kebab-case
  pascal, // PascalCase
  sentence, // Sentence case
  snake, // snake_case
  capital, // Capital Case
}

extension CaseName on Case {
  String get caseName => '$name-case';
}
