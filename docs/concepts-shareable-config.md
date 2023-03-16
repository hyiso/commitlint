# Concept: Shareable configuration

Most commonly shareable configuration is delivered as pub package exporting one or multi
`.yaml` file(s) containing `rules` section. To use shared configuration you specify it as value for key `include`

```yaml
# commitlint.yaml
include: package:commitlint_cli/commitlint.yaml
```

This causes `commitlint` to pick up `commitlint_cli/commitlint.yaml`.

The rules found in `commitlint_cli/commitlint.yaml` are merged with the rules in `commitlint.yaml`, if any.

This works recursively, enabling shareable configuration to extend on an indefinite chain of other shareable configurations.

## Relative config

You can also load local configuration by using a relative path to the file.

> This must always start with a `.` (dot).

```yaml
# commitlint.yaml
include: ./lints/commitlint.yaml
```
