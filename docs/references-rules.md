# Rules

Rules are made up by a name and a configuration list. The configuration list contains:

- **Level** `[0..2]`: `0` disables the rule. For `1` it will be considered a warning for `2` an error.
- **Applicable** `always|never`: `never` inverts the rule.
- **Value**: value to use for this rule.

```yaml
rules:
  type-case:
    - 2
    - always
    - lower-case
```

### Available rules

#### body-full-stop

- **condition**: `body` ends with `value`
- **rule**: `never`
- **value**

```
'.'
```

#### body-leading-blank

- **condition**: `body` begins with blank line
- **rule**: `always`

#### body-empty

- **condition**: `body` is empty
- **rule**: `never`

#### body-max-length

- **condition**: `body` has `value` or less characters
- **rule**: `always`
- **value**

```
Infinity
```

#### body-max-line-length

- **condition**: `body` lines has `value` or less characters
- **rule**: `always`
- **value**

```
Infinity
```

#### body-min-length

- **condition**: `body` has `value` or more characters
- **rule**: `always`
- **value**

```
0
```

#### body-case

- **condition**: `body` is in case `value`
- **rule**: `always`
- **value**

```
'lower-case'
```

- **possible values**

```yaml
- lower-case    # default
- upper-case    # UPPERCASE
- camel-case    # camelCase
- kebab-case    # kebab-case
- pascal-case   # PascalCase
- sentence-case # Sentence case
- snake-case    # snake_case
- start-case    # Start Case
```

#### footer-leading-blank

- **condition**: `footer` begins with blank line
- **rule**: `always`

#### footer-empty

- **condition**: `footer` is empty
- **rule**: `never`

#### footer-max-length

- **condition**: `footer` has `value` or less characters
- **rule**: `always`
- **value**

```
Infinity
```

#### footer-max-line-length

- **condition**: `footer` lines has `value` or less characters
- **rule**: `always`
- **value**

```
Infinity
```

#### footer-min-length

- **condition**: `footer` has `value` or more characters
- **rule**: `always`
- **value**

```
0
```

#### header-case

- **condition**: `header` is in case `value`
- **rule**: `always`
- **value**

```
'lower-case'
```

- **possible values**

```yaml
- lower-case    # default
- upper-case    # UPPERCASE
- camel-case    # camelCase
- kebab-case    # kebab-case
- pascal-case   # PascalCase
- sentence-case # Sentence case
- snake-case    # snake_case
- start-case    # Start Case
```

#### header-full-stop

- **condition**: `header` ends with `value`
- **rule**: `never`
- **value**

```
'.'
```

#### header-max-length

- **condition**: `header` has `value` or less characters
- **rule**: `always`
- **value**

```
72
```

#### header-min-length

- **condition**: `header` has `value` or more characters
- **rule**: `always`
- **value**

```
0
```

#### scope-enum

- **condition**: `scope` is found in value
- **rule**: `always`
- **value**
  ```
  []
  ```

#### scope-case

- **condition**: `scope` is in case `value`
- **rule**: `always`
- **value**

```
'lower-case'
```

- **possible values**

```yaml
- lower-case    # default
- upper-case    # UPPERCASE
- camel-case    # camelCase
- kebab-case    # kebab-case
- pascal-case   # PascalCase
- sentence-case # Sentence case
- snake-case    # snake_case
- start-case    # Start Case
```

#### scope-empty

- **condition**: `scope` is empty
- **rule**: `never`

#### scope-max-length

- **condition**: `scope` has `value` or less characters
- **rule**: `always`
- **value**

```
Infinity
```

#### scope-min-length

- **condition**: `scope` has `value` or more characters
- **rule**: `always`
- **value**

```
0
```

#### type-enum

- **condition**: `type` is found in value
- **rule**: `always`
- **value**
  ```js
  ['feat', 'fix', 'docs', 'style', 'refactor', 'test', 'revert']
  ```

#### type-case

- **description**: `type` is in case `value`
- **rule**: `always`
- **value**
  ```
  'lower-case'
  ```
- **possible values**

```yaml
- lower-case    # default
- upper-case    # UPPERCASE
- camel-case    # camelCase
- kebab-case    # kebab-case
- pascal-case   # PascalCase
- sentence-case # Sentence case
- snake-case    # snake_case
- start-case    # Start Case
```

#### type-empty

- **condition**: `type` is empty
- **rule**: `never`

#### type-max-length

- **condition**: `type` has `value` or less characters
- **rule**: `always`
- **value**

```
Infinity
```

#### type-min-length

- **condition**: `type` has `value` or more characters
- **rule**: `always`
- **value**

```
0
```