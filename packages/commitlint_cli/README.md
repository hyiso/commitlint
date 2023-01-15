# commitlint_cli

> Dart version commitlint cli (known in JavaScript comunity)

commitlint cli lint commit messages to satisfy [conventional commit format](https://www.conventionalcommits.org/)

With [husky](https://pub.dev/packages/husky) (a tool for managing git hooks), commitlint cli can be used as commmit-msg git hook

# Install

Add `commitlint_cli` and [husky](https://pub.dev/packages/husky) to your `dev_dependencies` in pubspec.yaml

```yaml
dev_dependencies:
  commitlint_cli: latest
  husky: latest
```

# Usage

```sh
dart pub get
dart run husky install
```

Set the commit-msg hook:

```sh
dart run husky set .husky/commit-msg 'dart run commitlint_cli --edit "$1"'
```

Make a commit:

```sh
git add .
git commit -m "Keep calm and commit"
# `ddart run commitlint_cli --edit "$1"` will run
```

# Documentation

See [documention](https://hyiso.github.io/commitlint)