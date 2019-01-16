Expand and enforce linting guidelines

Let's talk about linting.  As noted in the docs, there isn't really a consistent style applied to Twinkle.  That's okay!  But with around 17,000 lines of code, maybe it's also okay to have some more options in place.  As of #400 we have the basics via `eslint:recommended`, and `no-caller` was added in cd45282 (`max-len` is listed but unused).

I went through the [eslint rules](https://eslint.org/docs/rules/) and picked out some possibilities; the list is a combination of options that we already follow, options we don't, options I just personally prefer, and options that I thought might seem reasonable to at least someone out there.  Some are listed with different configurations but this is a _long_ list; still, it is by no means meant to be exhaustive or limiting, so feel free to proffer others.  Many are probably unnecessary or overkill.

I generated a table with the current results from each, arranged alphabetically by category, and intend to update the ✔️ or ❌ marks as this conversation goes forward.  The links will take you to the online docs page for each option, which should explain each in full.  I've made some suggestions for a few of them, in particular those with multiple configurations listed, to get us started.

This isn't urgent (see also #477), and there are a number of PRs I think we should review/merge beforehand to avoid conflicts, but once we've got a firm list I'll go through and make the changes.

cc @MusikAnimal @atlight @mc10 @azatoth


| Use?      | Option      | Config      | Curr errors | Fix?    | Category    | Notes?      |
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
| ❌  | [no-extra-parens](https://eslint.org/docs/rules/no-extra-parens) | "error" | 146 | Yes | Possible errors | Alt|
| ❌  |   [no-extra-parens](https://eslint.org/docs/rules/no-extra-parens) | ["error", "functions"] | 0 | Yes | Possible errors | Alt; might be allow additional clarity in ternaries|
| ✔️  |   [no-extra-parens](https://eslint.org/docs/rules/no-extra-parens) | ["error", "all", { "nestedBinaryExpressions": false }] | 113 | Yes | Possible errors | Alt; required for `no-mixed-operators` |
| ❔  |   [no-prototype-builtins](https://eslint.org/docs/rules/no-prototype-builtins) | "error" | 0 | No |  Possible errors| |
| ❔  |   [block-scoped-var](https://eslint.org/docs/rules/block-scoped-var) | "error" | 0 | No | Best practices | |
| ✔️  |   [curly](https://eslint.org/docs/rules/curly) | "error" | 20 | Yes | Best practices | Alt|
| ❌  |   [curly](https://eslint.org/docs/rules/curly) | ["error", "multi"] | 787 | Yes | Best practices | Alt|
| ❌  |   [curly](https://eslint.org/docs/rules/curly) | ["error", "multi-line"] | 5 | Yes | Best practices | Alt|
| ❔  |   [default-case](https://eslint.org/docs/rules/default-case) | "error" | 2 | No | Best practices | |
| ❌  |   [eqeqeq](https://eslint.org/docs/rules/eqeqeq) | "error" | 8 | Mixed | Best practices | Alt|
| ✔️  |   [eqeqeq](https://eslint.org/docs/rules/eqeqeq) | ["error", "smart"] | 8 | Mixed | Best practices | Alt|
| ✔️  |   [guard-for-in](https://eslint.org/docs/rules/guard-for-in) | "error" | 0 | No | Best practices | |
| ❔  |   [no-else-return](https://eslint.org/docs/rules/no-else-return) | "error" | 6 | Yes | Best practices | |
| ❔  |   [no-empty-function](https://eslint.org/docs/rules/no-empty-function) | "error" | 2 | No | Best practices | |
| ❔  |   [no-eq-null](https://eslint.org/docs/rules/no-eq-null) | "error" | 0 | No |  Best practices| |
| ❔  |   [no-global-assign](https://eslint.org/docs/rules/no-global-assign) | "error" | 0 | No | Best practices | See also `no-undefined` and `no-shadow-restricted-names`|
| ✔️  |   [no-implicit-coercion](https://eslint.org/docs/rules/no-implicit-coercion) | ["error", { "boolean": false }] | 0 | Yes | Best practices | Alt|
| ❌  |   [no-implicit-coercion](https://eslint.org/docs/rules/no-implicit-coercion) | ["error"] | 18 | Yes | Best practices | Alt|
| ❔  |   [no-lone-blocks](https://eslint.org/docs/rules/no-lone-blocks) | "error" | 0 | No | Best practices | |
| ✔️  |   [no-multi-spaces](https://eslint.org/docs/rules/no-multi-spaces) | ["error", { "ignoreEOLComments": true }] | 17 | Yes | Best practices | Alt|
| ❌  |   [no-multi-spaces](https://eslint.org/docs/rules/no-multi-spaces) | ["error"] | 251 | Yes | Best practices | Alt|
| ❔  |   [no-script-url](https://eslint.org/docs/rules/no-script-url) | "error" | 3 | No | Best practices | |
| ❔  |   [no-useless-catch](https://eslint.org/docs/rules/no-useless-catch) | "error" | 0 | No | Best practices | |
| ❔  |   [no-useless-return](https://eslint.org/docs/rules/no-useless-return) | "error" | 0 | Yes | Best practices | |
| ❔  |   [yoda](https://eslint.org/docs/rules/yoda) | "error" | 0 | Yes | Best practices | |
| ❔  |   [no-shadow-restricted-names](https://eslint.org/docs/rules/no-shadow-restricted-names) | "error" | 2 | No | Variables | Dislikes the format of the anonymous functions in `twinkle.js` and `morebits.js`; see also `no-undefined`|
| ❔  |   [no-undefined](https://eslint.org/docs/rules/no-undefined) | "error" | 24 | No | Variables | Alternatively, can use `no-global-assign` and `no-shadow-restricted-names` to allowed usage of `undefined` while still being safe, but either way, they dislike the format of the anonymous functions in `twinkle.js` and `morebits.js`|
| ❔  |   [array-bracket-spacing](https://eslint.org/docs/rules/array-bracket-spacing) | ["error", "never"] | 118 | Yes | Stylistic | |
| ❔  |   [block-spacing](https://eslint.org/docs/rules/block-spacing) | "error" | 0 | Yes | Stylistic | |
| ✔️  |   [brace-style](https://eslint.org/docs/rules/brace-style) | ["error", "1tbs", { "allowSingleLine": true }] | 33 | Yes (27) | Stylistics | Alt|
| ❌  |   [brace-style](https://eslint.org/docs/rules/brace-style) | ["error", "1tbs"] | 75 | Yes (69) | Stylistic | Alt|
| ❔  |   [comma-dangle](https://eslint.org/docs/rules/comma-dangle) | "error" | 3 | Yes | Stylistic | |
| ❔  |   [comma-spacing](https://eslint.org/docs/rules/comma-spacing) | ["error", { "before": false, "after": true }] | 22 | Yes | Stylistic | |
| ❔  |   [computed-property-spacing](https://eslint.org/docs/rules/computed-property-spacing) | ["error", "never"] | 42 | Yes | Stylistic | |
| ❔  |   [func-call-spacing](https://eslint.org/docs/rules/func-call-spacing) | ["error", "never"] | 4 | Yes | Stylistic | |
| ❌  |   [indent](https://eslint.org/docs/rules/indent) | ["error", "tab"] | 14604 | Yes | Stylistic | Alt; mostly due to not indenting after the wrapper function in each module|
| ❌  |   [indent](https://eslint.org/docs/rules/indent) | ["error", "tab", { "outerIIFEBody": 0 }] | 4484 | Yes | Stylistic | Alt; allow 0 indent after wrapper function, seems reasonable|
| ✔️  |   [indent](https://eslint.org/docs/rules/indent) | ["error", "tab", { "outerIIFEBody": 0, "SwitchCase": 1 }] | 3303 | Yes | Stylistic | Alt; enforce a tab before `case` statements|
| ❌  |   [indent](https://eslint.org/docs/rules/indent) | ["error", "tab", { "outerIIFEBody": 0, "ArrayExpression": "off", "ObjectExpression": "off" }] | 2082 | Yes | Stylistic | Alt; allow Twinkle to use 2 indents instead of 1 in multi-line arrays and objects|
| ❌  |   [indent](https://eslint.org/docs/rules/indent) | ["error", "tab", { "outerIIFEBody": 0, "SwitchCase": 1, "ArrayExpression": "off", "ObjectExpression": "off" }] | 1201 | Yes | Stylistic | Alt; all of the above|
| ❌  |   [key-spacing](https://eslint.org/docs/rules/key-spacing) | ["error", {"singleLine": {"beforeColon": true, "afterColon": true}}] | 1420 | Yes | Stylistic | Alt|
| ❌  |   [key-spacing](https://eslint.org/docs/rules/key-spacing) | ["error", {"singleLine": {"beforeColon": true, "afterColon": false}}] | 2476 | Yes | Stylistic | Alt|
| ✔️  |   [key-spacing](https://eslint.org/docs/rules/key-spacing) | ["error", {"singleLine": {"beforeColon": false, "afterColon": true}}] | 212 | Yes | Stylistic | Alt|
| ❌  |   [key-spacing](https://eslint.org/docs/rules/key-spacing) | ["error", {"singleLine": {"beforeColon": false, "afterColon": false}}] | 1268 | Yes | Stylistic | Alt|
| ✔️  |   [keyword-spacing](https://eslint.org/docs/rules/keyword-spacing) | ["error", { "after": true , "before": true}] | 454 | Yes | Stylistic | Alt|
| ❌  |   [keyword-spacing](https://eslint.org/docs/rules/keyword-spacing) | ["error", { "after": true , "before": false}] | 734 | Yes | Stylistic | Alt|
| ❌  |   [keyword-spacing](https://eslint.org/docs/rules/keyword-spacing) | ["error", { "after": false , "before": true}] | 1333 | Yes | Stylistic | Alt|
| ❌  |   [keyword-spacing](https://eslint.org/docs/rules/keyword-spacing) | ["error", { "after": false , "before": false}] | 1613 | Yes | Stylistic | Alt|
| ✔️  |   [linebreak-style](https://eslint.org/docs/rules/linebreak-style) | ["error", "unix"] | 0 | Yes | Stylistic | |
| ❔  |   [lines-between-class-members](https://eslint.org/docs/rules/lines-between-class-members) | ["error", "never"] | 0 | Yes | Stylistic | |
| ❌  |   [multiline-comment-style](https://eslint.org/docs/rules/multiline-comment-style) | ["error", "separate-lines"] | 24 | Yes | Stylistic |Alt; probably fine to mix-and-match these |
| ❌  |   [multiline-comment-style](https://eslint.org/docs/rules/multiline-comment-style) | ["error", "bare-block"] | 130 | Yes | Stylistic | Alt; probably fine to mix-and-match these|
| ❌  |   [multiline-comment-style](https://eslint.org/docs/rules/multiline-comment-style) | ["error", "starred-block"] | 127 | Yes | Stylistic | Alt; probably fine to mix-and-match these|
| ✔️  |   [no-bitwise](https://eslint.org/docs/rules/no-bitwise) | "error" | 0 | No |  Stylistic| |
| ❔  |   [no-lonely-if](https://eslint.org/docs/rules/no-lonely-if) | "error" | 6 | Yes (5) | Stylistic | |
| ✔️  |   [no-mixed-operators](https://eslint.org/docs/rules/no-mixed-operators) | "error" | 6 | No | Stylistic | |
| ❔  |   [no-multiple-empty-lines](https://eslint.org/docs/rules/no-multiple-empty-lines) | "error" | 24 | Yes | Stylistic | |
| ❌  |   [no-tabs](https://eslint.org/docs/rules/no-tabs) | ["error"] | 17653 | No | Stylistic | Alt; lolno|
| ✔️  |   [no-tabs](https://eslint.org/docs/rules/no-tabs) | ["error", { "allowIndentationTabs": true }] | 11 | No | Stylistic |Alt; will complain about indentation tabs in commented code, though (but we should just remove those) |
| ✔️  |   [no-trailing-spaces](https://eslint.org/docs/rules/no-trailing-spaces) | "error" | 2 | Yes | Stylistic | |
| ❔  |   [no-unneeded-ternary](https://eslint.org/docs/rules/no-unneeded-ternary) | "error" | 2 | Yes | Stylistic | |
| ❔  |   [no-whitespace-before-property](https://eslint.org/docs/rules/no-whitespace-before-property) | "error" | 0 | Yes | Stylistic | |
| ❔  |   [operator-linebreak](https://eslint.org/docs/rules/operator-linebreak) | ["error", "after"] | 0 | Yes | Stylistic | |
| ❔  |   [quotes](https://eslint.org/docs/rules/quotes) | ["error", "single", { "avoidEscape": true }] | 4532 | Yes | Stylistic | Alt; Slight preference (56-44)|
| ❔  |   [quotes](https://eslint.org/docs/rules/quotes) | ["error", "double", { "avoidEscape": true }] | 5790 | Yes | Stylistic | Alt; slight underdog (44-56)|
| ❔  |   [semi](https://eslint.org/docs/rules/semi) | ["error", "always"] | 2 | Yes | Stylistic | |
| ❔  |   [space-before-blocks](https://eslint.org/docs/rules/space-before-blocks) | "error" | 60 | Yes | Stylistic | Complains about the current style of the wrapper function for each module|
| ✔️  |   [space-in-parens](https://eslint.org/docs/rules/space-in-parens) | ["error", "never"] | 4452 | Yes | Stylistic | Alt; about time we committed to one style|
| ❌  |   [space-in-parens](https://eslint.org/docs/rules/space-in-parens) | ["error", "always"] | 9340 | Yes | Stylistic | Alt|
| ❔  |   [space-infix-ops](https://eslint.org/docs/rules/space-infix-ops) | "error" | 67 | Yes | Stylistic | |
| ❔  |   [space-unary-ops](https://eslint.org/docs/rules/space-unary-ops) | "error" | 20 | Yes | Stylistic | |
| ❌  |   [spaced-comment](https://eslint.org/docs/rules/spaced-comment) | ["error", "never"] | 1168 | Yes | Stylistic | Alt|
| ✔️  |   [spaced-comment](https://eslint.org/docs/rules/spaced-comment) | ["error", "always", { "line": { "exceptions": ["-"] }, "block": { "balanced": true } }] | 86 | Yes | Stylistic | Alt; would require a space before \<nowiki\> tags|
| ❌  |   [spaced-comment](https://eslint.org/docs/rules/spaced-comment) | ["error", "always", { "line": { "exceptions": ["-", "\<nowiki\>"] }, "block": { "balanced": true } }] | 64 | Yes | Stylistic | Alt; don't require a space before \<nowiki\> tags|
| ❔  |   [switch-colon-spacing](https://eslint.org/docs/rules/switch-colon-spacing) | "error" | 0 | Yes | Stylistic | |


<details>
  <summary>Updated .eslintrc.json with the above options</summary>
  
```json
{
	"extends": [
		"eslint:recommended"
	],
	"root": true,
	"env": {
		"browser": true,
		"jquery": true
	},
	"globals": {
		"mw": true,
		"moment": true
	},
	"rules": {
		"no-caller": "error",
		"no-extra-parens": ["error", "all", { "nestedBinaryExpressions": false }],
		"curly": "error",
		"eqeqeq": ["error", "smart"],
		"guard-for-in": "error",
		"no-implicit-coercion": ["error", { "boolean": false }],
		"no-multi-spaces": ["error", { "ignoreEOLComments": true }],
		"brace-style": ["error", "1tbs", { "allowSingleLine": true }],
		"indent": ["error", "tab", { "outerIIFEBody": 0, "SwitchCase": 1 }],
		"key-spacing": ["error", {"singleLine": {"beforeColon": false, "afterColon": true}}],
		"keyword-spacing": ["error", { "after": true , "before": true}],
		"linebreak-style": ["error", "unix"],
		"no-bitwise": "error",
		"no-mixed-operators": "error",
		"no-tabs": ["error", { "allowIndentationTabs": true }],
		"no-trailing-spaces": "error",
		"space-in-parens": ["error", "never"],
		"spaced-comment": ["error", "always", { "line": { "exceptions": ["-"] }, "block": { "balanced": true } }]
	}
}

```
</details>