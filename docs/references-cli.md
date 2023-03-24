# CLI

```bash
$ dart run commitlint_cli --help

commitlint - Lint commit messages

Usage: commitlint [arguments]

[input] reads from stdin if --edit, --from and --to are omitted

Global options:
-h, --help       Print this usage information.
    --config     path to the config file
                 (defaults to "commitlint.yaml")
    --edit       read last commit message from the specified file.
    --from       lower end of the commit range to lint. This is succeeded to --edit
    --to         upper end of the commit range to lint. This is succeeded to --edit
```