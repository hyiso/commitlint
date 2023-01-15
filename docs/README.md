## commitlint

> Dart version commitlint - A tool to lint commit messages.

## Getting started

commitlint helps your team adhere to a commit convention. By supporting pub-installed configurations it makes sharing of commit conventions easy.

### Install

```bash
# Install and configure if needed
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
echo 'foo: bar' | commitlint --input
⧗   input: foo: bar
✖   type must be one of [build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test] [type-enum]

✖   found 1 problems, 0 warnings
ⓘ   Get help: http://hyiso.github.io/commitlint/#/concepts-convensional-commits
```

```bash
# Lint last commit from history
commitlint --from=HEAD~1
```

?> To get the most out of `commitlint` you'll want to automate it in your project lifecycle. See our [Setup guide](./guides-setup.md) for next steps.

## Documentation

- **Guides** - Common use cases explained in a step-by-step pace
- **Concepts** - Overarching topics important to understand the use of `commitlint`
- **Reference** - Mostly technical documentation
