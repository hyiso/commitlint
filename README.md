# commitlint

[![Pub Version](https://img.shields.io/pub/v/commitlint_cli?color=blue)](https://pub.dev/packages/commitlint_cli)
[![popularity](https://img.shields.io/pub/popularity/commitlint_cli?logo=dart)](https://pub.dev/packages/commitlint_cli/score)
[![likes](https://img.shields.io/pub/likes/commitlint_cli?logo=dart)](https://pub.dev/packages/commitlint_cli/score)
[![CI](https://github.com/hyiso/commitlint/actions/workflows/ci.yml/badge.svg)](https://github.com/hyiso/commitlint/actions/workflows/ci.yml)

> Dart version commitlint - A tool to lint commit messages. (Inspired by JavaScript [commitlint](https://github.com/conventional-changelog/commitlint))

commitlint lint commit messages to satisfy [conventional commit format](https://www.conventionalcommits.org/)

commitlint helps your team adhere to a commit convention. By supporting pub-installed configurations it makes sharing of commit conventions easy.

## About Package Name

Because a package `commit_lint` already exists (not in active development), the name `commitlint` can't be used according to [Pub's naming policy](https://pub.dev/policy#naming-policy). So `commitlint_cli` is used currently.


## Getting started

### Install

Add `commitlint_cli` to your `dev_dependencies` in pubspec.yaml

```bash
# Install commitlint_cli
dart pub add --dev commitlint_cli
```

### Configuration

```bash
# Simply use configuration of a package
echo "include: package:commitlint_cli/commitlint.yaml" > commitlint.yaml
```
You can also customize your configuration in `commitlint.yaml`
```yaml
# Inherit configuration of a package
include: package:commitlint_cli/commitlint.yaml

# Custom rules
rules:
  type-case:
    - 2
    - always
    - 'upper-case'

# Whether commitlint uses the default ignore rules.
defaultIgnores: true
# Pattern that matches commit message if commitlint should ignore the given message.
ignores:
  - r'^fixup'
```


### Test

```bash
# Lint from stdin
echo 'foo: bar' | dart run commitlint_cli
⧗  input: type: add docs
✖  type must be one of [build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test] type-enum

✖  found 1 errors, 0 warnings
```

**Note: output on successful commit will be omitted, you can use the `VERBOSE=true` env to get positive output.** (Functionality of [verbose](https://pub.dev/packages/verbose))

```bash
# Output on successful commit will be omitted
echo 'feat: test message' | dart run commitlint_cli
# Verbse Output on successful commit
echo 'feat: test message' | VERBOSE=true dart run commitlint_cli
```
## Setup git hook

With [husky](https://pub.dev/packages/husky) (a tool for managing git hooks), commitlint cli can be used in `commmit-msg` git hook

### Set `commit-msg` hook:

```sh
dart pub add --dev husky
dart run husky install
dart run husky set .husky/commit-msg 'dart run commitlint_cli --edit "$1"'
```

### Make a commit:

```sh
git add .
git commit -m "Keep calm and commit"
# `dart run commitlint_cli --edit "$1"` will run
```

> To get the most out of `commitlint` you'll want to automate it in your project lifecycle. See our [Setup guide](https://hyiso.github.io/commitlint/#/guides-setup) for next steps.

## Documentation

See [documention](https://hyiso.github.io/commitlint)

- **Guides** - Common use cases explained in a step-by-step pace
- **Concepts** - Overarching topics important to understand the use of `commitlint`
- **Reference** - Mostly technical documentation
