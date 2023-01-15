# Guide: Setup

Get high commit message quality and short feedback cycles by linting commit messages right when they are authored.

This guide demonstrates how to achieve this via git hooks.

## Install commitlint

Install `commitlint_cli` and a `commitlint_config` of your choice as dev dependency and
configure `commitlint` to use it.

```bash
# Install and configure if needed
dart pub add --dev commitlint_cli commitlint_config

# Configure commitlint to use conventional config
echo "include: package:commitlint_config/commitlint.yaml" > commitlint.yaml
```

## Install husky

Install [husky](https://pub.dev/packages/husky) as dev dependency, a handy git hook helper available on pub.

```sh
# Install Husky 
dart pub add --dev husky

# Activate hooks
dart run husky install
```

### Add hook

```
dart run husky add .husky/commit-msg  'dart run commitlint_cli --edit ${1}'
```

## Test

### Test simple usage

For a first simple usage test of commitlint you can do the following:

```bash
dart run commitlint_cli --from HEAD~1 --to HEAD
```

This will check your last commit and return an error if invalid or a positive output if valid.

### Test the hook

You can test the hook by simply committing. You should see something like this if everything works.

```bash
git commit -m "foo: this will fail"
No staged files match any of provided globs.
⧗   input: foo: this will fail
✖   type must be one of [build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test] [type-enum]

✖   found 1 problems, 0 warnings
ⓘ   Get help: http://hyiso.github.io/commitlint/#/concepts-convensional-commits

husky - commit-msg hook exited with code 1 (add --no-verify to bypass)
```

?> Local linting is fine for fast feedback but can easily be tinkered with. To ensure all commits are linted you'll want to check commits on an automated CI Server too. Learn how to in the [CI Setup guide](guides-ci-setup.md).