karma-cson-fixtures-preprocessor
================================

##### Preprocessor for converting .cson files into .js files and making them accessible from karma test environment

## Installation
```json
{
    "devDependencies": {
        "karma": "~0.12.1",
        "karma-cson-fixtures-preprocessor": "0.0.x"
    }
}
```

## Configuration
```coffee
// karma.conf.js
module.exports = (config) ->
  config.set({
    preprocessors:
      "./fixtures/**/*.cson": ["cson_fixtures"]
    files: [
      "./fixtures/**/*.cson"
    ]
    csonFixturesPreprocessor:
      // strip this from the file path \ fixture name
      stripPrefix: "test/fixtures",
      // strip this to the file path \ fixture name
      prependPrefix: "mock/",
      // change the global fixtures variable name
      variableName: "__mocks__"

```

## How it works

Preprocessor requires .json files and converts them into .js files by storing json data as javascript objects under `__fixtures__` namespace.

the following file:
`./fixtures/test.json`
```coffee
{
    a: "test"
}
```
will be accessible in your test environment:
```js
var fixture = window.__fixtures__["fixtures/test"];
fixture["a"] // => 'test'
```
