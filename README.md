## commitlint

> Dart version commitlint - A tool to lint commit messages. (Inspired by JavaScript [commitlint](https://github.com/conventional-changelog/commitlint))

## Getting started

commitlint helps your team adhere to a commit convention. By supporting pub-installed configurations it makes sharing of commit conventions easy.

### Install

```bash
# Install commitlint cli and upstream configure if needed
dart pub add --dev commitlint_cli commitlint_config
```

### Configuration

```bash
# Configure commitlint to use conventional config
echo "include: package:commitlint_config/commitlint.yaml" > commitlint.yaml
```

### Test

```bash
# Lint from stdin
echo 'foo: bar' | dart run commitlint_cli
⧗  input: type: add docs
✖  type must be one of [build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test] type-enum

✖  found 1 errors, 0 warnings
```

```bash
# Lint last commit from history
commitlint --from=HEAD~1
```

?> To get the most out of `commitlint` you'll want to automate it in your project lifecycle. See our [Setup guide](https://hyiso.github.io/commitlint/#/guides-setup) for next steps.

## Packages

| Project               | Status                                                       | Description                                                       |
| --------------------- | ------------------------------------------------------------ | ----------------------------------------------------------------- |
| [commitlint_cli](./packages/commitlint_cli/)      | [![Pub Version](https://img.shields.io/pub/v/commitlint_cli?color=blue)](https://pub.dev/packages/commitlint_cli)                  | commitlint command-line tool entry |
| [commitlint_config](./packages/commitlint_config/)      | [![Pub Version](https://img.shields.io/pub/v/commitlint_config?color=blue)](https://pub.dev/packages/commitlint_config)                  | commitlint rules configuration, can be included. |
| [commitlint_format](./packages/commitlint_format/)      | [![Pub Version](https://img.shields.io/pub/v/commitlint_format?color=blue)](https://pub.dev/packages/commitlint_format)                  | commitlint output formatting package. |
| [commitlint_lint](./packages/commitlint_lint/)      | [![Pub Version](https://img.shields.io/pub/v/commitlint_lint?color=blue)](https://pub.dev/packages/commitlint_lint)                  | commitlint linting package |
| [commitlint_load](./packages/commitlint_parse/)      | [![Pub Version](https://img.shields.io/pub/v/commitlint_load?color=blue)](https://pub.dev/packages/commitlint_load)                  | load configured rules for commitlint |
| [commitlint_read](./packages/commitlint_read/)      | [![Pub Version](https://img.shields.io/pub/v/commitlint_read?color=blue)](https://pub.dev/packages/commitlint_read)                  | read commit message for commitlint. |
| [commitlint_rules](./packages/commitlint_rules/)      | [![Pub Version](https://img.shields.io/pub/v/commitlint_rules?color=blue)](https://pub.dev/packages/commitlint_rules)                  | rules set of commitlint. |
| [commitlint_types](./packages/commitlint_types/)      | [![Pub Version](https://img.shields.io/pub/v/commitlint_types?color=blue)](https://pub.dev/packages/commitlint_types)                  | types package for commitlint. |

## Documentation

See [documention](https://hyiso.github.io/commitlint)

- **Guides** - Common use cases explained in a step-by-step pace
- **Concepts** - Overarching topics important to understand the use of `commitlint`
- **Reference** - Mostly technical documentation
