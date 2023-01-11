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