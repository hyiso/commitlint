## 0.8.0

 - Support parser options in `commitlint.yaml` under section `parser`

## 0.7.2

 - ignoring mulitline merge commit message (fix #20)

## 0.7.1

 - rule should pass if commit component raw is null (fix #18)

## 0.7.0

 - Support `references-empty` rule.

## 0.6.3

 - Bump `ansi` version `0.4.0`

## 0.6.2

 - Bump `ansi` version to `0.3.0`, `change_case` to `1.1.0`

## 0.6.1

 - Fix bug in reading history commits when body contains multi lines

## 0.6.0

> Note: This release has breaking changes.

- **BREAKING** **FEAT**: Support ignores commit messages. Default ignores patterns are:
  - `r'((Merge pull request)|(Merge (.*?) into (.*?)|(Merge branch (.*?)))(?:\r?\n)*$)'`
  - `r'(Merge tag (.*?))(?:\r?\n)*$'`
  - `r'(R|r)evert (.*)'`
  - `r'(fixup|squash)!'`
  - `r'(Merged (.*?)(in|into) (.*)|Merged PR (.*): (.*))'`
  - `r'Merge remote-tracking branch(\s*)(.*)'`
  - `r'Automatic merge(.*)'`
  - `r'Auto-merged (.*?) into (.*)'`

## 0.5.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: throw exception if read commit message failed
 - **FEAT**: support multi scopes
 - **FIX**: print empty when output is empty (fix #9)

## 0.4.2

 - Set dart sdk minVersion to 2.15.0
## 0.4.1

 - Add exmaple README.md

## 0.4.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**:  remove `--version`
 - **BREAKING** **FEAT**: Replace support of `DEBUG=true` env to `VERBOSE=true` by using package [`verbose`](https://pub.dev/packages/verbose).
 - Fix parse `!` like `feat!:subject`.
 - Fix parse Merge commit.

## 0.3.0

> Note: This release has breaking changes.

 - **BREAKING** **REFACTOR**: Make all `commitlint_*` packages into one `commitlint_cli` package.
 - Move `package:commitlint_config/commitlint.yaml` to `package:commitlint_cli/commitlint.yaml`.
 - Support `DEBUG=true` env to print verbose message.
## 0.2.1+1

 - Update a dependency to the latest release.

## 0.2.1

 - **FEAT**: add documentation link. ([305bb990](https://github.com/hyiso/commitlint/commit/305bb990f0e1f70e6f0ca7266231603a28c84820))

## 0.2.0

> Note: This release has breaking changes.

 - **FEAT**: change cli to CommandRunner. ([f8b640ab](https://github.com/hyiso/commitlint/commit/f8b640ab1b337ed27ae4b37808d4fea74869c709))
 - **BREAKING** **FEAT**: change --edit preceded to --from and --to. ([fb9a6a8d](https://github.com/hyiso/commitlint/commit/fb9a6a8d33b87d8ee3784642e284a68b6cc90dea))

## 0.1.0+1

 - **DOCS**: add usage documentation. ([23f70976](https://github.com/hyiso/commitlint/commit/23f70976f2bb87776a0951f6fb7ccb067f743c52))

## 0.1.0

- Initial version.
